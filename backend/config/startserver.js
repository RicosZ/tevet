const PORT = process.env.PORT

//start server
const startServer = (app) => app.listen(PORT, () => {
    console.log(`server start at port ${PORT}`)
})

module.exports = startServer;