const mongoose = require('mongoose');

//connect mongodb
const connectDB = () => mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log("mongoDB connected")
}).catch((error) => {
    console.log(error.message);
})

module.exports = connectDB;