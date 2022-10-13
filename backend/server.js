require('dotenv').config();
const express = require('express');
const cors = require("cors")
const cookieParser = require('cookie-parser')

const authRoute = require('./routes/authRoute')
const profileRoute = require('./routes/profileRoute')
const forumRoute = require('./routes/forumRoute')

const connectDB = require('./config/db');
const startServer = require('./config/startserver');
const errorHandler = require('./middlewares/errorMiddleware');
const app = express();

app.use(express.json());
app.use(cors());
// app.use(cors({
//     origin: ["http://localhost:4444"],
//     credentials: true,
// }));
app.use(cookieParser());

//route
app.use('/api/v1/auth', authRoute)
app.use('/api/v1/profile', profileRoute)
app.use('/api/v1/forum', forumRoute)

// Error Handler
app.use(errorHandler)

connectDB()
const ser = startServer(app);

const io = require('socket.io')(ser);
const connectedUser = new Set();


io.on('connection', (socket) => {
    console.log('Connect Successfully', socket.id);
    connectedUser.add(socket.id)
    io.emit('connected-user',connectedUser.size)
    socket.on('disconnect',()=>{
        console.log('Disconnected',socket.id);
        connectedUser.delete(socket.id)
        io.emit('connected-user',connectedUser.size)
    });

    socket.on('message',(data)=>{
        console.log(data);
        socket.broadcast.emit('message-receive',data);
    });
});
// scoket(startServer);