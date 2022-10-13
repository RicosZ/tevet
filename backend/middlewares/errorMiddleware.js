const ErrorResponse = require('../utils/errorResponse.js')

module.exports = (err, req, res, next) => {
    // initialize error  
    err.statusCode = err.statusCode || 500;
    err.message = err.message || "Internal Server Error";

    // Duplicate key error in mongoose

    if (err.code === 11000) {
        const message = `Duplicate ${Object.keys(err.keyValue)} Entered`;
        err = new ErrorResponse (message, 400)
    }

    // response error
    return res.status(err.statusCode).json({
        success: false,
        message: err.message,
    });
}; 