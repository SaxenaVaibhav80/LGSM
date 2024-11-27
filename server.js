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
const secret_key = process.env.secret_key
app.use(bodyParser.urlencoded({extended:true}))

app.get("/",(req,res)=>
{
    res.send("working")
})


// ---------- creating route for signup post request handler  ------------------>

app.post("/api/signup",async(req,res)=>
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


// ---------- login post request handler ------------------------------->


app.post("/api/login",async(req,res)=>
{

    const email = req.body.email
    const password = req.body.password
    try{
        const user = await userModel.findOne({email:email})
        if(user)
        {
            const passverify=await bcrypt.compare(password,user.password)  // password verification ho rha h agr shi hoga to hi neeche ki cheeze execute hogi else koi verification error ayega wo catch block me jyega 
            if(passverify){
                const token = jwt.sign(
                    {id:user._id,name:user.firstname},
                    secret_key,
                    {
                     expiresIn:'24h'                             //24 hr me exoire hoga token
                    }
                )
                const options={
                    expires:new Date(Date.now()+24*60*60*1000),   // 24 hr me cookie se token v remove ho jyega after expiry
                    httpOnly:true
                };
                res.status(200).cookie("token",token,options)
                res.redirect("/TODO")
            }
            else{
                res.status(400).send("password incorrect")
            }
        }

    }catch(err)
    { 
        res.status(400).json(err)
    }
    

})


server.listen(port)