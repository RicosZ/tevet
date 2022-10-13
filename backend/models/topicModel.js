const mongoose = require("mongoose");
const validation = require("../utils/validation");

const topicSchema = new mongoose.Schema(
    {
        category: {
            _id: {
                type: mongoose.Schema.Types.ObjectId,
                ref: "Catagory",
                required: true,
            },
            name: String,
            slug: String
        },
        topicSubject: {
            type: String,
            required: true,
            match: [validation.topicSubject.match],
            maxlength: validation.topicSubject.max,
        },
        slug: String,
        slugId: Number,
        topicDetail: {
            type: String,
            required: true,
            match: [validation.topicDetail.match],
            maxlength: validation.topicDetail.max,
        },
        topicBy: {
            _id: {
                type: mongoose.Schema.Types.ObjectId,
                ref: "User",
                required: true,
            },
            name: String,
        },
        likes: {
            type: [mongoose.Schema.Types.ObjectId],
            ref: "User",
        },
        countViews: {
            type: Number,
            default: 0,
        },
        countComment: {
            type: Number,
            default: 0,
        },
        tags: [
            {
                _id: { type: mongoose.Schema.Types.ObjectId, ref: "Tag" },
                name: String,
            },
        ],
        comments: [{
            _id: {
                type: mongoose.Schema.Types.ObjectId,
                ref: "Comment",
            },
            detail: {
                type: String,
            },
        }]
    },
    {
        timestamps: true,
    }
);

const collectionName = "topic";
const Topic = mongoose.model("Topic", topicSchema, collectionName);
module.exports = Topic;
