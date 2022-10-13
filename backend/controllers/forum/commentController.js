const express = require("express");
const router = express.Router();
const ErrorResponse = require("../../utils/errorResponse");
const mongoose = require("mongoose");

const Comment = require("../../models/commentModel");
const Topic = require("../../models/topicModel");
const { findByIdAndDelete } = require("../../models/commentModel");
const validation = require("../../utils/validation");
const Category = require("../../models/categoryModel");
const User = require("../../models/userModel");
class CommentController {
    static async createComment(req, res, next) {

        const { topicId, commentBy, commentDetail } = req.body;
        try {
            await validation.checkFull({topicId, commentBy, commentDetail})
            const comment = await Comment.create({ topicId, commentBy, commentDetail });
            const topic = await Topic.findOneAndUpdate({ _id: mongoose.Types.ObjectId(topicId) }, {
                $push: { comments: { _id: comment._id, detail: comment.commentDetail }, }, 
                $inc: {countComment:1}
            })
            if (!topic) {
                await Comment.findByIdAndDelete(comment._id);
                return next(new ErrorResponse("Not found topic", 400))
            }
            const isCustomer = await User.findOne({ _id: commentBy }).select('isCustomer');
            if (!isCustomer.isCustomer) {
                await Category.findOneAndUpdate({
                    _id: topic.category._id, $or : [{doctorId: commentBy}, {doctorId: {$exists: false}}]
                }, { $inc: { replyDcount: 1 }, $set: { replyDlast: new Date(Date.now()) } })
            }
           

            return res.status(201).json({success: true, })
        } catch (error) {
            return next(error)
        }


    }

    static async deleteComment(req, res, next) {
        const { commentId } = req.params;
        const { topicId } = req.body;
        try {
            if (!mongoose.Types.ObjectId.isValid(commentId))
                return next(new ErrorResponse("BAD REQUEST", 400));
            const comment = await Comment.findByIdAndDelete(commentId);
            const topic = await Topic.findOneAndUpdate(
                { _id: topicId },
                {$pull: {comments: {_id: mongoose.Types.ObjectId(commentId)} }, $inc: {countComment:-1}}
            )
            const isCustomer = await User.findOne({ _id: comment.commentBy }).select('isCustomer');
            if (!isCustomer.isCustomer) { 
                await Category.updateOne({
                    _id: topic.category._id, $or : [{doctorId: comment.commentBy}, {doctorId: {$exists: false}}]
                },
                { $inc: { replyDcount: -1 }, })
            }
            
            
            return res.json({ success: true });
        } catch (error) {
            return next(error);
        }
    }

    static async editComment(req, res, next) {
        const { commentId } = req.params;
        const { topicId, commentDetail, commentBy } = req.body;

        try {
            if (!mongoose.Types.ObjectId.isValid(commentId))
                return next(new ErrorResponse("BAD REQUEST", 400));
            
            validation.checkFull({topicId, commentBy, commentDetail})
            
            const comment = await Comment.findOneAndUpdate(
                {_id: commentId, commentBy},
                { commentDetail },
                { new: true }
            );

            if (comment?.commentBy == commentBy) {
                await Topic.updateOne(
                    { _id: topicId, 'comments._id': commentId},
                    { $set: { 'comments.$.detail': commentDetail } },
                    { new: true}
                )
            } else {
                return next(new ErrorResponse("You are not authorized"), 401)
            }

            return res.json({ success: true });
        } catch (error) {
            return next(error);
        }
    }

    static async getComment(req, res, next) {
        const { topicId, page } = req.query;
        try {
            const limit = 15 ; 
            const skip = page ? (page - 1) * limit : 0;
            
            const match = { $match: { ...(topicId && {topicId: mongoose.Types.ObjectId(topicId)}) } };
            const lookup = {$lookup: {
                    from: 'user',
                    localField: 'commentBy',
                    foreignField: '_id',
                    pipeline: [{$project: {_id: 0, isCustomer: 1, image: 1, postName: 1}}],
                    as: 'by'
                }
            }
            const set = {$set: {
                isCustomer: { $arrayElemAt: ['$by.isCustomer', 0] },
                image: {$arrayElemAt: ['$by.image',0]},
                postName: {$arrayElemAt: ['$by.postName',0]}}
            }
            const project = { $project: { __v: 0, by: 0 } }
            const comments = await Comment.aggregate(Array.prototype.concat(
                [match], [lookup], [set], [project], [{ $skip: skip }], (page  ? [{ $limit: limit }] : []) ))

            res.status(200).json({ success: true, data: comments });
        } catch (error) {
            return next(error);
        }
    }
}

module.exports = CommentController;
