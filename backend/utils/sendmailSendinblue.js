const nodemailer = require("nodemailer");
const ErrorResponse = require("./errorResponse");

const sendEmailforsendinblue = async (options,next) => {
  const transporter = nodemailer.createTransport({
    host: 'smtp-relay.sendinblue.com',
    port: process.env.SEN_PORT,
    auth: {
      user: process.env.SEN_USER,
      pass: process.env.SEN_PASSWORD
    },
  });

  const mailOptions = {
    from: process.env.SEN_USER,
    to: options.to,
    subject: options.subject,
    html: options.text,
  };

  try {
    await transporter.sendMail(mailOptions);
  } catch (error) {
    throw next(error)
  }
};

module.exports = sendEmailforsendinblue;