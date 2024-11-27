const express= require("express")
const db = require("./config/dbConfig.js")
const http= require("http")
const dotenv = require("dotenv")
dotenv.config()
const bcrypt=require("bcrypt")
const userModel = require("./models/user.js")
const port = process.env.PORT
const app = express()
const jwt = require("jsonwebtoken")
const bodyParser = require("body-parser")
const server = http.createServer(app)
app.use(bodyParser.urlencoded({extended:true}))

app.get("/",(req,res)=>
{
    res.send("working")
})


// ---------- creating route for signup post request handler  ------------------>

app.post("/signup",async(req,res)=>
{
  const username = req.body.username  // ye signup jab tum kroge to whn se data ayega name wala  or username me store ho jyega 
  const email = req.body.email// ye signup jab tum kroge to whn se data ayega email wala  or username me store ho jyega 
  const password = req.body.password// ye signup jab tum kroge to whn se data ayega password wala  or username me store ho jyega 
  const phone = req.body.phone// ye signup jab tum kroge to whn se data ayega phone number wala  or username me store ho jyega 


  const isExist = await userModel.find({
    email:email
  })

  if(!(username && email && password && phone))
    {
        res.status(400).send("all field are required")
    }
  if(isExist)
    {
     res.status(409).json("user already exist")
    }

  else{
    const encPass= await bcrypt.hash(password,10)   // yhn password ko encrypt kardia h maine okay?
    const user = await userModel.create({
        name:username,
        email:email,
        password:encPass,  // Yhn encrpted pass stpre ho rha h ok
        phone:phone
      })

    res.redirect("/")
  }

})


server.listen(port)