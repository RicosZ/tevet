const express = require("express");
const mongoose = require("mongoose");

const router = express.Router();

const Category = require("../../models/categoryModel");
const { findById } = require("../../models/topicModel");
const ErrorResponse = require("../../utils/errorResponse");

class CategoryController {
    static async createCategory(req, res, next) {
        const { doctorId, catName } = req.body;

        try {
            
            // if (!mongoose.Types.ObjectId.isValid(doctorId))
            //     return res.json({
            //         success: false,
            //         message: "Doctor id is't Valid",
            //     });

            if(!catName) return next(new ErrorResponse("Please fill Category name",404))
            const newcategory = await Category.create({ doctorId, catName, slug: catName.replaceAll(" ", "-") });
            return res.json({ success: true });
        } catch (error) {
            return next(error);
        }
    }

    static async getCategory(req, res, next) {
        const { categoryId } = req.params;

        try {
            //เช็ค type ของ id ใน mongoose ว่าครบ 25 ตัวมั้ย ถ้าครบ 25 จะผ่าน โดยไม่สนว่ามีใน database ไหม
            if (!mongoose.Types.ObjectId.isValid(categoryId)) return next(new ErrorResponse("BAD REQUEST", 400));
            const category = await Category.findById({ _id: categoryId });
            //เช็ค ID ใน category ว่ามีไหม
            if (!category) return next(new ErrorResponse("BAD REQUEST", 400));
            return res.json({ success: true, data: category });
        } catch (error) {
            return next(error);
        }
    }

    static async getPaginationCategory(req, res, next) {
        try {
            const { categoryname, page, sort, value=1 } = req.query; // ส่ง value เพิ่ม -> value มีค่า 1 || -1 // categoryname -> แถบ search ใน UI
            // console.log(category);
            let nextpage;
            const limit = 9; // 12 มาจากหน้า UI // รอ responsive อีกรอบ
            if (page > 1) {
                nextpage = (page - 1) * limit;
            } else {
                nextpage = 0;
            }
            // console.log(nextpage);

            //ยังหาวิธีอื่นไม่เจอ
            let sortcommand;
            if (sort) {
                sortcommand = { $sort: { [sort.toString()]: parseInt(value) } };
            } else {
                sortcommand = { $sort: { catName: 1 } };
            }
            // console.log(sortcomand);
            let match;
            if (categoryname) {
                match = {
                    $match: { catName: RegExp(categoryname) },
                };
            } else {
                match = { $match: { catName: RegExp("(?:)") } };
            }

            const category = await Category.aggregate([
                match, sortcommand, { $skip: nextpage }, { $limit: limit },
            ]);
            return res.status(200).json({
                success: true,
                data: category,
            });
        } catch (error) {
            if (error !== undefined) {
                return next(error);
            }
        }
    }

    static async getCategoryList(req, res, next) {
        try {
            const categories = await Category.find().select('_id catName slug')
            return res.status(200).json({success:true, categories})
        } catch (error) {
            return next(error)
        }
    }
}

module.exports = CategoryController;
