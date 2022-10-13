const mongoose = require("mongoose");
const validation = require("../utils/validation");

const commentSchema = new mongoose.Schema(
    {
        topicId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Topic",
            required: true,
        },
        commentDetail: {
            type: String,
            required: true,
            match: [validation.commentDetail.match],
            maxlength: validation.commentDetail.max,
        },
        commentBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },
    },
    {
        timestamps: true,
    }
);

const collectionName = "comment";
const Comment = mongoose.model("Comment", commentSchema, collectionName);

module.exports = Comment;
