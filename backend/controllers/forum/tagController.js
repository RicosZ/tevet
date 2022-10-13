const express = require("express");
const mongoose = require("mongoose");
const ErrorResponse = require("../../utils/errorResponse");

const Tag = require("../../models/tagModel");
const Topic = require("../../models/topicModel");
const { findById } = require("../../models/tagModel");
const validation = require("../../utils/validation");

const router = express.Router();

class TagController {
    static async getTag(req, res, next) {
        try {
            const tag = await Tag.find({});
            return res.json({ success: true, data: tag });
        } catch (error) {
            return next(error);
        }
    }

    static async deleteTag(req, res, next) {
        const { tagId } = req.params;

        try {
            if (!mongoose.Types.ObjectId.isValid(tagId))
                return next(new ErrorResponse("BAD REQUEST", 400));
            //เช็คเพิ่มกรณี ID ตรงกับ Type ที่ดักไว้ตอนแรกถึงจะผิดแต่มันส่งสถานะ true ซึ่ง front-end อาจเข้าใจผิดได้ว่าลบ Tag ไปแล้ว 
            //(ต่อ) จึงทำการดักเพิ่มว่า ID นั้นไม่มีใน DataBase จะ return Error กลับไป
               const checktagId =  await Tag.findByIdAndDelete({_id:tagId});
               if(!checktagId) return next(new ErrorResponse("์Don't have ID Tag id in database", 400));
                await Topic.updateMany(
                    {"tags._id":tagId},
                    { $pull: { tags: { _id: mongoose.Types.ObjectId(tagId) } } },
                    { new: true }
                );
                return res.json({ success: true });
        } catch (error) {
            return next(error);
        }
    }

    static async updateTag(req, res, next) {
        const { tagId } = req.params;
        const { name } = req.body;
        try {
            validation.checkFull({tagName: name})
            await validation.checkDocDuplicate([{ Tag, name }]);
            
            await Tag.findByIdAndUpdate(tagId, { name });
            await Topic.updateMany(
                { "tags._id": tagId },
                { $set: { "tags.$.name": name } },
                { new: true }
            );

            return res.status(200).json({ success: true });
        } catch (error) {
            return next(error);
        }
    }

    static async createTag(req, res, next) {
        const { name } = req.body;
        try {
            validation.checkFull({tagName: name})
            await validation.checkDocDuplicate([{ Tag, name }]);
            await Tag.create({ name });

            res.status(201).json({ success: true });
        } catch (error) {
            return next(error);
        }
    }
}

module.exports = TagController;
