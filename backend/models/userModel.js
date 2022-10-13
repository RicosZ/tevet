const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const validation = require("../utils/validation");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const Category = require("./categoryModel");
const Topic = require("./topicModel");

const userSchema = new mongoose.Schema(
    {
        isCustomer: { type: Boolean, required: true },
        email: {
            type: String,
            required: true,
            unique: true,
            match: [validation.email.match],
        },
        password: {
            type: String,
            required: true,
            match: [validation.password.match],
        },
        fullName: {
            type: String,
            required: true,
            maxlength: validation.fullName.max,
            match: [validation.fullName.match],
        },
        image: String,
        postName: {
            id: { type: Number },
            name: {
                type: String,
                required: true,
                maxlength: validation.fullName.max,
            },
        },
        categoriesId: { type: mongoose.Schema.Types.ObjectId, ref: "Category" },
        resetPasswordToken: String,
        resetPasswordExpire: Date,
        refreshToken: [{ type: String }],
    },
    {
        timestamps: true,
    }
);

userSchema.pre("save", async function (next) {
    // when do not update password => !true = false
    if (!this.isModified("password")) {

        //when fullName & postName.name is changed => update in category & topic collection
        if (this.isModified('fullName') && this.isCustomer === false) {
            const category = await Category.findOneAndUpdate({ doctorId: this._id }, { $set: { catName: this.fullName, slug: this.fullName.replaceAll(" ", "-") } });
            await Topic.updateMany({ 'category._id': category._id }, { $set: { 'category.name': this.fullName, 'category.slug': this.fullName.replaceAll(" ", "-") } })
            console.log("debug for check update doctor in category&topic when having edit fullName")
        }
        if (this.isModified('postName.name')) {
            await Topic.updateMany({ "topicBy._id": this._id }, { $set: { "topicBy.name": this.postName.name } });
            console.log("debug for check update in topic when having edit postName.name")
        }
        
        return next();
    }
    if (this.password.length > 16) {
        return next();
    }
    this.password = await bcrypt.hash(this.password, 10);
    next();
});

userSchema.methods.matchPassword = async function (password) {
    return await bcrypt.compare(password, this.password);
};

userSchema.methods.createAccessToken = async function () {
    return await jwt.sign(
        { id: this._id, isCustomer: this.isCustomer },
        process.env.ACCESS_TOKEN_SECRET,
        { expiresIn: "15s" }
    );
};

userSchema.methods.createRefreshToken = async function () {
    return await jwt.sign(
        { id: this._id, isCustomer: this.isCustomer },
        process.env.REFRESH_TOKEN_SECRET,
        { expiresIn: "15m" }
    );
};

userSchema.methods.resetPassword = function () {
    //เข้ารหัส Token ที่จะส่งให้ api resetpassword อีกที
    const resetToken = crypto.randomBytes(20).toString("hex");
 
    //Token resetPasswordToken ที่เข้ารหัส crypto จะไปถูกเก็บใน database
    this.resetPasswordToken = crypto.createHash("sha256").update(resetToken).digest("hex");
  
    // เซ็ต token expire 
    this.resetPasswordExpire = Date.now() + 10 * (60 * 1000); ; // Ten Minutes Token resetPasswordExpire เป็นเวลาของ Token ใน database
  
    return resetToken;
  };




const collectionName = "user";
const User = mongoose.model("User", userSchema, collectionName);

module.exports = User;
