const mongoose = require("mongoose");
const validation = require("../utils/validation");

const tagSchema = new mongoose.Schema(
    {
        name:{
            type: String,
            required: true,
            unique: true,
            match: [validation.tagName.match],
            maxlength: validation.tagName.max,
        }
    }
)

const collectionName = 'tag';
const Tag = mongoose.model('Tag', tagSchema, collectionName);

module.exports = Tag;