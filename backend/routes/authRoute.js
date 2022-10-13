const express = require('express');
// const session = require('express-session')
const authController = require('../controllers/auth/authController');
const router = express.Router();
// const passport = require('passport');

// router.use(session({ secret: 'keyboard cat', resave: true, saveUninitialized: true }))
// router.use(passport.initialize());
// router.use(passport.session());

router.post('/login', authController.login);

router.post('/register', authController.register);

router.get('/logout', authController.logout)

router.post('/doctor', authController.registerDoctor);

router.post('/refresh', authController.refreshToken)

router.post('/otp/verify', authController.verifyOtp);

router.post('/otp/send', authController.sendOtp);



// router.get('/google',
//     passport.authenticate('google',{scope: ['email','profile'] })
// );

// router.get('/google/callback',
//     passport.authenticate('google',),authController.google);


router.post('/password',authController.forgotpassword)


router.post('/forgotpassword',authController.forgotpassword)
router.patch('/password/:resetToken',authController.resetPassword);


module.exports = router;