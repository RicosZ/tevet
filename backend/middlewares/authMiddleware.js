const jwt = require('jsonwebtoken');
const User = require('../models/userModel');
const ErrorResponse = require('../utils/errorResponse');

const verifyJWT = async (req, res, next) => {
    let token;
    if (req.headers.authorization &&req.headers.authorization.startsWith(`Bearer`)) {
        token = req.headers.authorization.split(" ")[1];
    }
    if (!token) {
        return next(new ErrorResponse("Not found token", 401));
    }

    try {

        const decoded = await jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        const user = await User.findById(decoded.id);

        req.user = user;

        next();
    } catch (error) {
        return next(new ErrorResponse("Not authorized to acccess this route", 401));
    }
}

module.exports = verifyJWT;