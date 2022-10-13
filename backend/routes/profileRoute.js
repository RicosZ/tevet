const express = require('express');
const router = express.Router();

const ProfileController = require('../controllers/profile/profileController');



router.get('/:id',ProfileController.GetProfile);
router.patch('/:id',ProfileController.UpdateProfile);


module.exports = router;