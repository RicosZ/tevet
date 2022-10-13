const express = require("express");
const TopicController = require("../controllers/forum/topicController");
const TagController = require("../controllers/forum/tagController");
const CategoryController = require("../controllers/forum/categoryController");
const CommentController = require("../controllers/forum/commentController");
const router = express.Router();

const auth = require('../middlewares/authMiddleware');

router.post("/comments", CommentController.createComment);
router.delete("/comments/:commentId", CommentController.deleteComment);
router.patch("/comments/:commentId", CommentController.editComment);
router.get("/comments", CommentController.getComment);

router.post("/categories", CategoryController.createCategory);
router.get("/categories",auth, CategoryController.getPaginationCategory);
router.get("/categories/:categoryId", CategoryController.getCategory);
router.get("/categories/list/name", CategoryController.getCategoryList)

router.get("/tags", TagController.getTag);
router.delete("/tags/:tagId", TagController.deleteTag);
router.put("/tags/:tagId", TagController.updateTag);
router.post("/tags", TagController.createTag);

router.get("/topics/", TopicController.getPaginationTopic);
router.get("/topics/:slugId", TopicController.getTopic);
router.post("/topics", TopicController.createTopic);
router.patch("/topics/:topicId", TopicController.editTopic);
router.patch("/topics/like/:topicId", TopicController.likeTopic);
router.delete("/topics/:topicId", TopicController.deleteTopic);
router.get('/search', TopicController.searchTopic);

module.exports = router;
