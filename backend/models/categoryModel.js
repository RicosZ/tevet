const mongoose = require("mongoose");

const categorySchema = new mongoose.Schema({
    doctorId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
    },
    catName: {
        type: String,
        required: true,
    },
    slug: String,
    replyDcount: {
        type: Number,
        default: 0,
    },
    replyDlast: {
        type: Date,
    },
    topicCount: {
        type: Number,
        default: 0,
    },
});

const collectionName = "category";
const Category = mongoose.model("Category", categorySchema, collectionName);

module.exports = Category;
