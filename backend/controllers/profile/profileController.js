const profile = require("../../models/profileModel");
const ErrorResponse = require("../../utils/errorResponse");
const User = require("../../models/userModel");
const Topic = require("../../models/topicModel");
const Category = require("../../models/categoryModel");
class ProfileController {
    static async GetProfile(req, res, next) {
        const { id } = req.params;
        try {
            const Profile = await profile.findOne({ userId: id });
            if(!Profile){
                return next(new ErrorResponse("Not found user",404));
            }
            if (Profile !== undefined) {
                return res.status(200).json({
                    success: true,
                    data: Profile,
                });
            }
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
    static async UpdateProfile(req, res, next) {
        try {
            const { id } = req.params;
            const {
                image,
                postName,
                fullName,
                birthdate,
                address,
                typeConsult,
                experiences,
                educations,
                about,
                signature,
                isCustomer
            } = req.body;
            const slug = fullName.replaceAll(" ", "-");
            const filter = { userId: id };

            const opts = { new: true };


            const user = await User.findOne({ _id: id });
            if(!user){
                return next(new ErrorResponse("Your not authorized",401));
            }
            user.fullName = fullName;
            user.image = image;
            user.postName.name = isCustomer === true ? postName.name : fullName;
            user.save();
            
            const update = {
                image,
                'postName.name': user.postName.name,
                fullName,
                slug,
                birthdate,
                address,
                typeConsult,
                experiences,
                educations,
                about,
                signature,
            };
            const Profile = await profile.findOneAndUpdate(
                filter,
                update,
                opts
            );

            // go to userModel for update this //เก็บไว้เฉยๆรอเทสมีเผื่อบัค
            // if (user.isCustomer === false) {
            //     const category = await Category.findOneAndUpdate({ doctorId: user._id }, { $set: { catName: fullName, slug: slug } });
            //     await Topic.updateMany({'category._id': category._id}, {$set: {'category.name': fullName, 'category.slug': slug}})
            // }
            // const updateInTopic = await Topic.updateMany({"topicBy._id": id}, {$set:{"topicBy.name": user.postName.name}}, opts);

            
            if (Profile === null) {
                return next(new ErrorResponse("BAD REQUEST", 400));
            } else if (Profile !== undefined) {
                return res.json({
                    success: true,
                });
            }
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }
}

module.exports = ProfileController;
