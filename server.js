const express = require("express");
const db = require("./config/dbConfig.js");
const http = require("http");
const dotenv = require("dotenv");
const bcrypt = require("bcrypt");
const userModel = require("./models/user.js");
const jwt = require("jsonwebtoken");
const shopkeeperModel = require("./models/shopkeeper.js")
const cors = require("cors");
const cookieParser = require("cookie-parser");

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;
const secret_key = process.env.SECRET_KEY;

// Middleware
app.use(cors({
  origin: true, // Allow all origins in development
  credentials: true // Allow credentials
}));
app.use(express.json()); // For parsing application/json
app.use(cookieParser()); // For parsing cookies
app.use(express.urlencoded({ extended: true }));

// Health check route
app.get("/", (req, res) => {
  res.json({ status: "Server is running" });
});

// Signup route
app.post("/api/signup", async (req, res) => {
  const { username, email, password, phone } = req.body;

  try {
    if (!(username && email && password && phone)) {
      return res.status(400).json({ 
        success: false,
        message: "All fields are required" 
      });
    }

    const isExist = await userModel.findOne({ email });
    if (isExist) {
      return res.status(409).json({ 
        success: false,
        message: "User already exists" 
      });
    }

    const encPass = await bcrypt.hash(password, 10);

    const user = await userModel.create({
      name: username,
      email,
      password: encPass,
      phone,
    });

    res.status(201).json({
      success: true,
      message: "User created successfully",
      data: {
        userId: user._id,
        email: user.email,
        name: user.name
      }
    });
  } catch (err) {
    console.error("Signup Error:", err);
    res.status(500).json({ 
      success: false,
      message: "Internal server error" 
    });
  }
});

// Login route
app.post("/api/login", async (req, res) => {
  const { email, password } = req.body;
  
  try {
    const user = await userModel.findOne({ email });
    if (!user) {
      return res.status(404).json({ 
        success: false,
        message: "User not found" 
      });
    }

    const passverify = await bcrypt.compare(password, user.password);
    if (!passverify) {
      return res.status(401).json({ 
        success: false,
        message: "Incorrect password" 
      });
    }

    const token = jwt.sign(
      { id: user._id, name: user.name },
      secret_key,
      { expiresIn: "24h" }
    );

    // Set token in cookie
    res.cookie('token', token, {
      expires: new Date(Date.now() + 24 * 60 * 60 * 1000),
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production', // Use secure cookies in production
      sameSite: 'none' // Required for cross-origin cookies
    });

    res.status(200).json({
      success: true,
      message: "Login successful",
      data: {
        token,
        userId: user._id,
        name: user.name,
        email: user.email
      }
    });
  } catch (err) {
    console.error("Login Error:", err);
    res.status(500).json({ 
      success: false,
      message: "Internal server error" 
    });
  }
});

// ---------------------------- Get uuid -------------------------->
app.post("/api/getuid",async(req,res)=>
{
  const token = req.cookies.token
  if(token)
  {
    try{

      const verification = jwt.verify(token,secret_key)
      const id = verification.id
      const user = await shopkeeperModel.findOne({_id:id})
      const shopname = user. ShopName
      const pin = user.pincode
      const existCode = await shopkeeperModel.find({pincode:pin})
      const quantity = existCode.length
      const last_id = user._id.toString().slice(-3);  // ye last ke 3 digit dega obj   _id ke 
      const abbr = shopname.split(" ").map(word=>word[0]).join('')
      const upperabbr= abbr.toUpperCase();

      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
      
      if(existCode)
      {
        const uid = `${pin}${last_id}${upperabbr}${quantity+1}`
        res.status(200).json({
          uid:uid
        })
      }
      else{
        const uid = `${pin}${last_id}${upperabbr}${1}`
        res.status(200).json({
          uid:uid
        })
      }

    }catch(err)
    {
       res.send(409).json("malwared token")
    }
  }
})


// Start server
const server = http.createServer(app);
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});