const mongoose = require("mongoose");

const profileSchema = new mongoose.Schema(
    {
        userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
        email: {
            type: String,
            required: true,
            unique: true,
            match: [/^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]+)$/],
        },
        phone: {
            type: String,
            required: true,
            unique: true,
            match: [/^[0-9]*$/],
            minlength: 10,
            maxlength: 10,
        },
        image: String,
        postName: {
            id: { type: Number },
            name: { type: String, required: true, maxlength: 30 },
        },
        fullName: {
            type: String,
            required: true,
            maxlength: 30,
            match: [/^[^-\s][a-zA-Zก-๙\s]*[^\s]$/],
        },
        slug: String,
        birthdate: Date,
        address: String,
        typeConsult: {
            general: Boolean,
            other: [String],
        },
        experiences: [
            {
                title: String,
                since: String,
            },
        ],
        educations: [
            {
                title: String,
                since: String,
            },
        ],
        about: String,
        signature: String,
    },
    {
        timestamps: true,
    }
);

const collectionName = "profile";
const Profile = mongoose.model("Profile", profileSchema, collectionName);

module.exports = Profile;
