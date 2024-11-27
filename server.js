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

app.post("/signup",async(req,res)=>
{
  const username = req.body.username  // ye signup jab tum kroge to whn se data ayega name wala  or username me store ho jyega 
  const email = req.body.email// ye signup jab tum kroge to whn se data ayega email wala  or username me store ho jyega 
  const password = req.body.password// ye signup jab tum kroge to whn se data ayega password wala  or username me store ho jyega 
  const phone = req.body.phone// ye signup jab tum kroge to whn se data ayega phone number wala  or username me store ho jyega 

  try {

    if (!(username && email && password && phone)) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const isExist = await userModel.findOne({ email: email });
    if (isExist) {
      return res.status(409).json({ error: "User already exists" });
    }
    const encPass = await bcrypt.hash(password, 10);    // yhn password encrypted ho rha h ...hum encrypted password save kr rhe h Data base me


    const user = await userModel.create({
      name: username,
      email: email,
      password: encPass,
      phone: phone,
    });

    res.status(201).json({
      message: "us er created",
      userId: user._id,
    });
  } catch (err) {
    console.error("Signup Error:", err);
    res.status(500).json({ error: "Internal server error" });
  }
});



// ---------- login post request handler ------------------------------->


app.post("/login",async(req,res)=>
{

    const email = req.body.email
    const password = req.body.password
    
    try {
      
        const user = await userModel.findOne({ email: email });
        if (!user) {
          return res.status(404).json({ error: "User not found" });
        }
    
        const passverify = await bcrypt.compare(password, user.password);  // hum verify kr rhe h password
        if (!passverify) {
          return res.status(400).json({ error: "Incorrect password" });
        }
    
    
        const token = jwt.sign(
          { id: user._id, name: user.name },
          secret_key,
          { expiresIn: "24h" }
        );
    
        const options = {
          expires: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours
          httpOnly: true,
        };
    
        res.status(200).cookie("token", token, options).json({
          message: "loggedin successful",
          token: token,
          userId: user._id,
        });
      } catch (err) {
        console.error("Login Error:", err);
        res.status(500).json({ error: "any server error" });
      }
})


server.listen(port)