const express= require("express")
const db = require("./config/dbConfig.js")
const http= require("http")
const dotenv = require("dotenv")
dotenv.config()
const app = express()

const server = http.createServer(app)

app.get("/",(req,res)=>
{
    res.send("working")
})



server.listen(9000)