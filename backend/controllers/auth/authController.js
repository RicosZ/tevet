const Profile = require("../../models/profileModel");
const User = require("../../models/userModel");
const ErrorResponse = require("../../utils/errorResponse");
const jwt = require("jsonwebtoken");
const axios = require("axios");
const validation = require("../../utils/validation");
const sendEmailforsendinblue = require("../../utils/sendmailSendinblue")
const sendEmailforgoogle = require("../../utils/sendmailGoogle");
const Category = require("../../models/categoryModel");
const crypto = require("crypto");
const bcrypt = require("bcrypt");

class authController {
    static async login(req, res, next) {
        try {
            const { email, password } = req.body;

            // Check missing & match of value
            validation.checkFull({ email, password });

            const user = await User.findOne({ email });
            if (!user) return next(new ErrorResponse("Not found user", 401));

            const isMatch = await user.matchPassword(password);
            if (!isMatch)
                return next(new ErrorResponse("Password is incorrect"), 401);
            
            // Get refresh token and access token
            // const accessToken = await renewAuthToken(user, req, res);

            const {accessToken , refreshToken} = await renewAuthToken(user, req, res);
            
            return res
                .status(200)
                .json({
                    success: true,
                    accessToken,
                    refreshToken,
                    isCustomer: user.isCustomer,
                });
        } catch (error) {
            next(error);
        }
    }

    static async register(req, res, next) {
        try {
            const { email, phone, password, fullName } = req.body;
            
            // Check missing & match of value
            validation.checkFull({ email, phone, password, fullName });

            // Check duplicate
            await validation.checkDocDuplicate([
                { User, email },
                { Profile, phone },
            ]);
            
            // Send OTP => uncomment for turn on
            let otpData; // <== do not comment this
            // otpData = await sendOTP(phone);

            const hashPassword = await bcrypt.hash(password, 10);
            // JWT sign OTP and response token to client
            const otpToken = await createOtpToken({
                email,
                phone,
                password: hashPassword,
                fullName,
                ...otpData,
                
            })
            ;

            return res.status(200).json({ success: true, otpToken });
        } catch (error) {
            return next(error);
        }
    }

    static async sendOtp(req, res, next) {
        try {
            const { otpToken } = req.body;
            const decoded = await verifyOtpToken(otpToken);
            delete decoded.iat, delete decoded.exp;

            // Send OTP => uncomment for turn on
            let otpData; // <== do not comment this
            // otpData = await sendOTP(decoded.phone);

            // JWT sign OTP and response new token to client
            const newOtpToken = await createOtpToken({
                ...decoded,
                ...otpData,
            });

            return res
                .status(200)
                .json({ success: true, otpToken: newOtpToken });
        } catch (error) {
            return next(error);
        }
    }

    static async verifyOtp(req, res, next) {
        try {
            const { otpToken, otpCode } = req.body;
            const decoded = await verifyOtpToken(otpToken);
            const { email, password, fullName, phone } = decoded;
            // Verify OTP => uncomment for turn on
            // const verifySuccess = await verifyOTP(decoded, otpCode);
            // if (!verifySuccess)
            //     return next(new ErrorResponse("Verify OTP fail", 403));

            const user = await createUserProfile(
                email,
                password,
                fullName,
                phone,
                true
            );

            // Authorization
            if (req.cookies?.refreshToken)
                res.clearCookie("refreshToken", { httpOnly: true, sameSite: "None", secure: true, });

            // Get refresh token get access token
            const accessToken = await renewAuthToken(user, req, res);

            return res
                .status(201)
                .json({
                    success: true,
                    accessToken,
                    isCustomer: user.isCustomer,
                });
        } catch (error) {
            return next(error);
        }
    }

    static async registerDoctor(req, res, next) {
        try {
            const { email, password, fullName, phone } = req.body;

            // Check missing & match of value
            validation.checkFull({ email, password, fullName, phone });

            // Check duplicate
            await validation.checkDocDuplicate([
                { User, email },
                { Profile, phone },
            ]);

            // Create profile when user created
            const doctor = await createUserProfile(email, password, fullName, phone, false);

            await Category.create({doctorId: doctor._id, catName: doctor.fullName, slug: doctor.fullName.replaceAll(" ", '-')})

            return res.status(201).json({ success: true });
        } catch (error) {
            next(error);
        }
    }

    static async refreshToken(req, res, next) {
        const { currentToken } = req.body
        try {
           
            if (!currentToken)
                return next(new ErrorResponse("You are not authorized", 401));
            // const currentRefreshToken = req.cookies.refreshToken;
            const currentRefreshToken = currentToken;

            const foundUser = await User.findOne({ refreshToken: currentRefreshToken, }).exec();
            await jwt.verify(currentRefreshToken, process.env.REFRESH_TOKEN_SECRET, async (err, decoded) => {
                
                    if (!foundUser) {
                        if (err) throw next(new ErrorResponse("You are not authorized"));
                        const hackedUser = await User.findById(decoded.id);
                        hackedUser.refreshToken = [];
                        await hackedUser.save();
                        throw next( new ErrorResponse("Detected reuse token", 403) );
                    }

                    // When findOne function is หลอน ไป find ตัวอื่นมา เก็บไว้เผื่อได้ใช้
                    // if (!foundUser.refreshToken.find((ref) => ref === currentRefreshToken))
                    //     throw next(new ErrorResponse("You are not same user", 403));

                    // Token expired
                    if (err) {
                        const removeExpireToken = foundUser.refreshToken.filter(
                            (ref) => ref !== currentRefreshToken
                        );
                        foundUser.refreshToken = [...removeExpireToken];
                        await foundUser.save();
                        throw next(new ErrorResponse("Token is expired"), 401);
                    }
                    // if (err || foundUser._id !== decoded.id) throw next(new ErrorResponse("You are not same user", 403))
                }
            );

            // Renew access&refresh token
            // const accessToken = await renewAuthToken(foundUser, req, res);
            const Token = await renewAuthToken(foundUser, req, res);
            const accessToken = Token.accessToken;
            // const accessToken = Token.accessToken;
            // console.log(accessToken);

            return res
                .status(200)
                .json({
                    success: true,
                    accessToken,
                    isCustomer: foundUser.isCustomer,
                });
        } catch (error) {
            return next(error);
        }
    }

    static async logout(req, res, next) {
        try {
            if (!req.cookies?.refreshToken)
                return next(new ErrorResponse("You are not authorized", 401));
            
            const refreshToken = req.cookies.refreshToken;

            const foundUser = await User.findOne({ refreshToken });
            if (!foundUser) {
                res.clearCookie("refreshToken", {
                    httpOnly: true,
                    sameSite: "None",
                    secure: true,
                });
                return next(new ErrorResponse("You are not authorized", 401));
            }

            const removeCurrentToken = foundUser.refreshToken.filter(
                (ref) => ref !== refreshToken
            );
            foundUser.refreshToken = [...removeCurrentToken];
            await foundUser.save();
            res.clearCookie("refreshToken", {
                httpOnly: true,
                sameSite: "None",
                secure: true,
            });

            return res
                .status(200)
                .json({ success: true, message: "logout success" });
        } catch (error) {
            next(error);
        }
    }
    static async google(req, res, next) {
        try {
            const email = req.user.email;
            const fullname = req.user.displayName;
            const image = req.user.picture;
            const user = await User.findOne({email: req.user.email});
            if(user){
                const accessToken = await renewAuthToken(user, req, res);      
                return res.status(200).json({success: true, accessToken, isCustomer: user.isCustomer})
            }else{
                const token = jwt.sign(
                    {
                        email,
                        fullname,
                        image
                    },
                    process.env.ACCESS_TOKEN_SECRET,
                    {
                        expiresIn: '10m',
                    }
                )
                // res.cookie("googleUser", token, {
                //     httpOnly: true,
                //     // secure: true,
                //     sameSite: "None",
                //     maxAge: 10 * 60 * 1000,
                // });
                // return res.redirect(307,"/api/v1/auth/register/")
                return res.status(200).json({ data: token, method: 'social' })
            }
            
        } catch (error) {
            next(error)
        }
    }

    static async forgotpassword(req,res,next){

        const { email } = req.body   //Tarit@kkumail.com

        try {
        const user = await User.findOne({email}) //เช็คเจอ email นี้ ใน doc แล้ว

        if (!user) return next(new ErrorResponse("You are not authorized", 401)); //ถ้าไม่มี email ใน doc มึงแสดง Error เลยนะสัส

        const resetToken = user.resetPassword(); // เช็คแล้ว Token ที่เข้ารหัสเรียบร้อยมาเก็บไว้ใน resetToken แล้วนะควย

        await user.save(); //save resetToken,Expire

        const resetUrl = `http://localhost:3000/password/${resetToken}`;

        const message = `
         <h1>You have requested a password reset</h1>
         <p>Please make a put request to the following link:</p>
         <a href=${resetUrl} clicktracking=off>${resetUrl}</a>
       `;

       try {
        await sendEmailforsendinblue({ //ส่งเมลที่ require มา    //ถ้าจะเปลี่ยนการส่งเมลจาก sendinblue เป็น google ให้เปลี่ยน sendEmail เป็น sendEmailgoogle ตัวรับรับเหมือนกัน
          to: user.email, //email ใน database มึงนั่นแหละ
          subject: "Password Reset Request",
          text: message, //ในส่วนตัวอากิวเมนที่จะส่งไป 3 ตัว
        });
      
        return res.status(200).json({ success: true });

      } catch (err) {

        console.log(err);
  
        user.resetPasswordToken = undefined; 
        user.resetPasswordExpire = undefined;
  
        await user.save();
  
        return next(new ErrorResponse("Email could not be sent", 500));
      }
        } catch (error) {
            res.send(error)
        }
    }
    static async resetPassword(req, res, next) {
        try {
            const { password } = req.body;
            await validation.checkFull({password});
            const { resetToken } = req.params;
            const resetPasswordToken = crypto.createHash("sha256").update(resetToken).digest("hex");
            // console.log(resetPasswordToken);
            const query = {resetPasswordToken: resetPasswordToken , resetPasswordExpire: { $gt: Date.now() } }

            const user = await User.findOne(query);
            if(user){

                user.password = password;
                user.resetPasswordToken = '';
                user.resetPasswordExpire = '';
                await user.save();

                return res.status(200).json({ success: true, data: user });
            }else{
                return res.status(400).json({ success: false, error:'Token expired' });
            }
            
        } catch (error) {
            return next(error)
        }
    }
}

const createOtpToken = async (obj) => {
    return await jwt.sign(obj, process.env.OTP_TOKEN_SECRET, {
        expiresIn: "25m",
    });
};

const verifyOtpToken = async (token) => {
    return await jwt.verify(token, process.env.OTP_TOKEN_SECRET);
};

const sendOTP = async (phone) => {
    // Config request 'OTP API' for send OTP .
    const data = JSON.stringify({
        msisdn: String(phone),
        sender: "SMSOTP",
        digits: 6,
        lifetime: 10,
        message:
            "หมายเลข OTP ของท่านคือ {otp} กรุณากรอกในระบบภายในเวลา {lifetime} นาที หมายเลขอ้างอิงคือ {ref}",
    });

    const config = {
        method: "post",
        url: "https://www.havesms.com/api/otp/send",
        headers: {
            Authorization: `Bearer ${process.env.HAVESMS_TOKEN}`,
            "Content-Type": "application/json",
        },
        data: data,
    };

    const resData = axios(config)
        .then(function (response) {
            const transaction = {
                transaction: {
                    des: response.data.description,
                    ref: response.data.ref,
                    id: response.data.transaction_id,
                    exp: response.data.expired_at,
                },
            };
            return transaction;
        })
        .catch(function (error) {
            throw new ErrorResponse("OTP ERROR: " + error.message, 401);
        });

    return resData;
};

const verifyOTP = async (transaction, otpCode) => {
    try {
        // Config request 'OTP API' for OTP verify.
        const data = JSON.stringify({
            msisdn: String(transaction.phone),
            otp: String(otpCode),
            transaction_id: transaction.transaction.id,
        });
        const config = {
            method: "post",
            url: "https://www.havesms.com/api/otp/verify",
            headers: {
                Authorization: `Bearer ${process.env.HAVESMS_TOKEN}`,
                "Content-Type": "application/json",
            },
            data: data,
        };

        const isSuccess = await axios(config)
            .then(function (response) {
                // Send success
                return true;
            })
            .catch(function (error) {
                // Send not success

                return false;
            });

        return isSuccess;
    } catch (error) {
        return false;
    }
};

const createUserProfile = async (
    email,
    password,
    fullName,
    phone,
    isCustomer,
) => {
    const user = await User.create({
        isCustomer: isCustomer,
        email,
        password,
        fullName,
        image: "imageurl",
        postName: {
            ...(isCustomer && { id: (await User.count()) + 1 || "1" }),
            name: fullName,
        },
    }).catch((error) => {
        throw error;
    });

    // Create profile when user created
    await Profile.create({
        userId: user._id,
        email: user.email,
        phone: phone,
        fullName: user.fullName,
        postName: { id: user.postName.id, name: user.postName.name },
        slug: user.fullName.replaceAll(" ", "-"),
        image: "imageurl",
    }).catch(async (error) => {
        // Delete user when profile fail to created
        await User.findByIdAndDelete({ _id: user._id });
        throw error;
    });

    return user;
};

const renewAuthToken = async (user, req, res) => {
    const {currentToken} = req.body
    try {
        // renew access&refresh token
        const accessToken = await user.createAccessToken();
        const refreshToken = await user.createRefreshToken();
        // filter current refresh token out of database
        const newRefreshTokenArray = !currentToken
            ? user.refreshToken
            : user.refreshToken.filter((rt) => rt !== currentToken);
        
        // set new token to database
        user.refreshToken = [...newRefreshTokenArray, refreshToken];
        await user.save();
        // set new refresh token in cookie
        res.cookie("refreshToken", refreshToken, {
            httpOnly: true,
            // secure: true,
            sameSite: "None",
            maxAge: 24 * 60 * 60 * 1000,
        });
        // const Token = {accessToken , refreshToken};

        return {accessToken , refreshToken};
    } catch (error) {
        throw error;
    }
};

module.exports = authController;
