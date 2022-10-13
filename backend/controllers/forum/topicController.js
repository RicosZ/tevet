const topic = require("../../models/topicModel");
const Comment = require("../../models/commentModel");
const ErrorResponse = require("../../utils/errorResponse");
const mongoose = require("mongoose");
const { findByIdAndDelete } = require("../../models/topicModel");
const Topic = require("../../models/topicModel");
const User = require("../../models/userModel");
const Category = require("../../models/categoryModel");
const validation = require("../../utils/validation");

class TopicController {
    static async getPaginationTopic(req, res, next) {
        try {
            const { categorySlug, topicSubject, page, sort, value, userId, like } = req.query; // ส่ง value เพิ่ม -> value มีค่า 1 || -1
            // console.log(category);
            let nextpage;
            const limit = 9; // 12 มาจากหน้า UI
            if (page > 1) {
                nextpage = (page - 1) * limit;
            } else {
                nextpage = 0;
            }
            // console.log(nextpage);
            let matchCategory;
            let matchTopic;
            categorySlug ? matchCategory = {$match: { 'category.slug': categorySlug }} : matchCategory = {$match: {}}
            topicSubject ? matchTopic = {$match: { topicSubject: RegExp(topicSubject) }} : matchTopic = {$match: {}}

            //หน้ากระทู้ของฉัน
            let match;
            if (like && userId) {
            match = {
                $match: {
                    likes: { $in: [mongoose.Types.ObjectId(userId)] },
                },
            };
            }else if (userId) {
                match = {
                    $match: { 'topicBy._id': mongoose.Types.ObjectId(userId) },
                };
            }else{
                match = {$match: {}};
            }

            // console.log(match);

            //ยังหาวิธีอื่นไม่เจอ
            let sortcommand;
            if (sort) {
                sortcommand = { $sort: { [sort.toString()]: parseInt(value) } };
            }else{
                sortcommand = { $sort: { createdAt: -1 } };
            }
            // console.log(sortcomand);

            // if (!mongoose.Types.ObjectId.isValid(category)) return next(new ErrorResponse("BAD REQUEST",400));
            const Topic = await topic.aggregate(Array.prototype.concat(
                [matchCategory],
                [matchTopic],
                [match],
                [{
                    $set: {
                        tags: "$tags.name",
                    },
                }],
                [{
                    $project: {
                        'topicBy': 1,
                        topicSubject: 1,
                        topicDetail: 1,
                        countLike: {
                            $size: "$likes",
                        },
                        slugId: 1,
                        countViews: 1,
                        countComment: 1,
                        createdAt: 1,
                        tags: 1,
                    },
                }],
                [sortcommand],
                [{
                    $skip: nextpage,
                }],
                [{
                    $limit: limit,
                }],
            ));
            return res.status(200).json({
                success: true,
                data: Topic,
            });
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async getTopic(req, res, next) {
        try {
            const { slugId } = req.params;
            const filter = { slugId };
            const update = { $inc: { countViews: 1 } }; // $inc บวกเลขเพิ่ม
            const opts = { new: true };
            const project = {
                $project: { 
                    __v: 1, 
                    postName: 1,
                    image: 1,
                    topicSubject: 1,
                    topicDetail: 1,
                    topicBy: 1,
                    likes: 1,
                    countLike: {
                        $size: '$likes'
                    },
                    countViews: 1,
                    countComment: 1,
                    createdAt: 1,
                    updatedAt:1,
                    tags: 1,
                    isCustomer: 1
                }
               }
            // if (!mongoose.Types.ObjectId.isValid(topicId))
            //     return next(new ErrorResponse("BAD REQUEST", 400));
            const Topic = await topic
                .aggregate([{
                    $match: {
                     slugId: parseInt(slugId),
                    }
                   }, {
                    $lookup: {
                     from: 'user',
                     localField: 'topicBy._id',
                     foreignField: '_id',
                     pipeline: [
                      {
                       $project: { postName: 1, image: 1, isCustomer: 1, _id: 0 }
                      }
                     ],
                     as: 'by'
                    }
                   }, {
                    $set: {
                        topicBy: '$topicBy._id',
                        isCustomer: {$arrayElemAt: [ '$by.isCustomer', 0 ]},
                     postName: {
                      $arrayElemAt: [ '$by.postName', 0 ]
                     },
                     image: {
                      $arrayElemAt: [ '$by.image', 0 ]
                     },
                     tags: '$tags.name' }
                   }, project,
                ])
                .then(async data => {
                    await topic.findOneAndUpdate({ _id: data[0]._id }, update, opts)
                    data[0].countViews++
                    return data[0]
                });
            res.json({
                success: true,
                data: Topic,
            });
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async createTopic(req, res, next) {
        try {
            //category = {_id, name, slug}
            const { category, topicSubject, topicDetail, topicBy, tags } = req.body;
            // console.log(category);
            // console.log(topicSubject);
            // console.log(topicDetail);
            // console.log(topicBy);
            // console.log(tags);
            
            const userPost = await User.find({ _id: topicBy }).select('_id postName.name')
            // console.log('ss ddd'.replaceAll(" ", "-"));
            const slug = topicSubject.replaceAll(" ", "-");
            const slugId = await topic.find().count()+1
            const Topic = await topic.create({
                category,
                topicSubject,
                slug,
                slugId,
                topicDetail,
                topicBy: {_id: userPost[0]._id, name: userPost[0].postName.name},
                // likes,
                // countViews,
                // countComment,
                tags,
                // commentId,
                // commentDetail,
            });

            await Category.updateOne({ _id: category._id }, { $inc: { topicCount: 1 } });

            return res.json({
                success: true,
                // data: Topic,
            });
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async editTopic(req, res, next) {
        try {
            const { topicId } = req.params;
            const { topicSubject, topicDetail, tags } = req.body;
            validation.checkFull({topicSubject,topicDetail});
            const filter = { _id: topicId };
            const update = {
                topicSubject,
                slug: topicSubject.replaceAll(" ", "-"),
                topicDetail,
                tags,
            };
            const opts = { new: true };
            const Topic = await topic.findOneAndUpdate(filter, update, opts);
            if (Topic === null) {
                return next(new ErrorResponse("BAD REQUEST", 400));
            } else if (Topic !== undefined) {
                return res.json({
                    success: true,
                    data: Topic,
                });
            }
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async likeTopic(req, res, next) {
        try {
            const { topicId } = req.params;
            const { userId } = req.body;
            if (
                !mongoose.Types.ObjectId.isValid(topicId) &&
                !mongoose.Types.ObjectId.isValid(userId)
            )
                return next(new ErrorResponse("BAD REQUEST", 400));
            const filter = { _id: topicId };
            const likedTopic = await topic.findOne(filter);
            let update;
            if (likedTopic.likes.includes(userId)) {
                update = { $pull: { likes: userId } };
            } else {
                update = { $push: { likes: userId } }; // ใช้ pull ถ้า dislike
            }
            const opts = { new: true };
            const Topic = await topic.findOneAndUpdate(filter, update, opts);
            return res.status(200).json({
                success: true,
                data: Topic,
            });
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async deleteTopic(req, res, next) {
        try {
            const { topicId } = req.params;
            if (!mongoose.Types.ObjectId.isValid(topicId))
                return next(new ErrorResponse("BAD REQUEST", 400));


            const matchTopic = { $match: {_id: mongoose.Types.ObjectId(topicId)} }
            const lookupCat = { $lookup: { from: 'category', localField: 'category._id', foreignField: '_id', as: 'category' } }
            const lookupCom = { $lookup: { from: 'comment', localField: 'comments._id', foreignField: '_id', as: 'comments' } }
            const unwindCom = { $unwind: { path: '$comments' } }
            const matchDoctor = { $match: { $expr: { $eq: [{ $arrayElemAt: ['$category.doctorId', 0] }, '$comments.commentBy'] } } }
            const group = { $group: { _id: '$comments.commentBy', amountDoc: { $sum: 1 } } }
            
            let amountDoctorReply = await topic.aggregate([
                matchTopic, lookupCat, lookupCom, unwindCom, matchDoctor, group
            ])
            if(amountDoctorReply.length > 0)
                amountDoctorReply = amountDoctorReply[0].amountDoc

            const Topic = await topic.findOneAndDelete({_id: topicId});
            const comment = await Comment.deleteMany({ topicId: topicId });

            await Category.updateOne({ _id: Topic.category._id }, { $inc: { topicCount: -1, replyDcount: -amountDoctorReply } });
            

            return res.json({
                success: true,
                // topic: deleteTopic,
                // comment: deleteComment
            });
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async searchTopic(req, res, next) {
        const {find, value=1, page} = req.query;
        const doctor = req.query.doctor ? req.query.doctor?.split(';') : [];
        const tags = req.query.tags ? req.query.tags?.split(';') : [];
        const searchBy = req.query.searchBy ? req.query.searchBy.split(';') : ['subject', 'detail', 'op'];
        // sort => createdAt, topicSubject, countLike, countComment, countViews 
        const sort = req.query.sort || null// default
        try {
            if (!req.query.find)
                return res.status(200).json({ success: true, search: [] })
            
            const match = {
                $match: {
                    $and: [
                        ...(doctor.length > 0 ? [{ 'category.slug': { $in: doctor, $exists: true } }]: [{}]) ,
                        ...(tags.length > 0 ? [{ 'tags.name': { $in: tags } }] : [{}])
                    ]
                }
            }
            const setTagsName = { $set: { tags: '$tags.name' } }
            const queryIn = Array.prototype.concat(
                ...(searchBy.includes('subject') ? [{ topicSubject: RegExp(find) }] : []),
                ...(searchBy.includes('detail') ? [{ topicDetail: RegExp(find) }] : []),
                ...(searchBy.includes('op') ? [{ 'topicBy.name': RegExp(find) }] : []),
                ...(searchBy.length === 3 ? [{ 'comments.detail': RegExp(find) }] : [])
            )
            const query = { $match: {$or: queryIn } }
            const queryComment = searchBy.length === 3
                ? {
                    $addFields: {
                        comments: {
                            $first: {
                                $filter: {
                                    input: '$comments.detail', cond: {
                                        $regexMatch: { input: '$$this', regex: find }
                                    }
                                }
                            }
                        }
                    }
                }
                : { $unset: ['comments'] }

            const sortCommand = sort === 'countLike'
                ? [{ $addFields: { countLike: { $size: '$likes' } } }, { $sort: { countLike: parseInt(value) } }]
                : sort && [{ $sort: { [sort.toString()]: parseInt(value) } }];

            const limit = 5
            const skip = page ? (page - 1) * limit : 0;


            const search = await Topic.aggregate(Array.prototype.concat(
                [match], [setTagsName], [query], [queryComment], ...(sort ? [...sortCommand] : []), [{ $skip: skip }], [{ $limit: limit }],
            ))

            res.status(200).json({success: true, search})
        } catch (error) {
            return next(error)
        }
    }
    
}

module.exports = TopicController;
