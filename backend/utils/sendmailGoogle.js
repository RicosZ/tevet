const nodemailer = require("nodemailer")
const google = require("googleapis")
const oAuth2 = google.auth
const OAUTH_PLAYGROUND = 'https://developers.google.com/oauthplayground'



const sendEmailgoogle = async (options) => {
let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      type: 'OAuth2',
      user: process.env.MAIL_USERNAME,
      pass: process.env.MAIL_PASSWORD,
      clientId: process.env.OAUTH_CLIENTID,
      clientSecret: process.env.OAUTH_CLIENT_SECRET,
      accessToken: process.env.OAUTH_ACCESS_TOKEN,
      refreshToken: process.env.OAUTH_REFRESH_TOKEN
    }
  });  

  let mailOptions = {
    from: process.env.MAIL_USERNAME,
    to: options.to,
    subject:  options.subject,
    html: options.text
  };

  try {
    await transporter.sendMail(mailOptions);
  } catch (error) {
    throw next(error)
  }
}

  module.exports = sendEmailgoogle