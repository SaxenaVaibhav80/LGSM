const express= require("express")
const db = require("./config/dbConfig.js")
const http= require("http")
const dotenv = require("dotenv")
dotenv.config()
const userModel = require("./models/user.js")
const port = process.env.PORT
const app = express()

const server = http.createServer(app)

app.get("/",(req,res)=>
{
    res.send("working")
})



server.listen(port)