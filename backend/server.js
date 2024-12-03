const express = require("express");
const db = require("./config/dbConfig.js");
const http = require("http");
const dotenv = require("dotenv");
const bcrypt = require("bcrypt");
const userModel = require("./models/user.js");
const jwt = require("jsonwebtoken");
const shopkeeperModel = require("./models/shopkeeper.js")
const ShopsModel = require("./models/shops.js")
const cors = require("cors");
const cookieParser = require("cookie-parser");

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;       // taking port from env else default port 3000
const secret_key = process.env.SECRET_KEY;

// --------------------------------------- cors-------------------------------------->
app.use(cors({
  origin: true, 
  credentials: true
}));
app.use(express.json()); 
app.use(cookieParser()); 
app.use(express.urlencoded({ extended: true }));


app.get("/", (req, res) => {
  res.json({ status: "Server is running" });
});

// -----------------------------user signup route---------------------------------->

app.post("/api/user/signup", async (req, res) => {
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
// -----------------------generate uuid function ------------------------------------------->

async function getuuid(shopname,pincode)
{

  const pin = pincode
  const now = new Date();
  const existCode = await shopkeeperModel.find({pincode:pin})
  const quantity = existCode.length
  const abbr = shopname.split(" ").map(word=>word[0]).join('')
  const day = String(now.getDate()).padStart(2, '0');                         
  const upperabbr= abbr.toUpperCase()


  if(existCode.length > 0)
  {  
    const uid = `${pin}${upperabbr}${day}${quantity+1}`
    return uid
  }
  else{
    const uid = `${pin}${upperabbr}${day}1`
    return uid
  }
}

//------------------------ shopkeeper signup------------------------->

app.post("/api/shopkeeper/signup", async (req, res) => {
  const { ShopName, ShopkeeperName, email, address, phone, pincode, password } = req.body;

  console.log(ShopName,pincode)

  try {
    if (!(ShopName && ShopkeeperName && email && phone && pincode && password)) {
      return res.status(400).json({ 
        success: false,
        message: "All fields are required" 
      });
    }

    const isExist = await shopkeeperModel.findOne({ email });
    if (isExist) {
      return res.status(409).json({ 
        success: false,
        message: "User already exists" 
      });
    }

    const uuid = await getuuid(ShopName,pincode)
    const encPass = await bcrypt.hash(password, 10);

    const shop = await ShopsModel.create({
     shopId:uuid,
     name:ShopName,
     email:email,
     phone:phone,
     location:address
    });
    
    const shopkeeper = await shopkeeperModel.create({
      ShopName:ShopName,
      ShopkeeperName:ShopkeeperName,
      email:email,
      address:address,
      phone:phone,
      pincode:pincode,
      password: encPass,
      shop: shop._id
    });

    res.status(200).json({
      success: true,
      message: "shopkeeper and shop created successfully",
      data: {
        name: shop.name,
        shopID:shop._id
      }
    });

  }catch (err) {
    console.error("Signup Error:", err);
    res.status(500).json({ 
      success: false,
      message: "Internal server error" 
    });
  }
});

//-----------------user login route------------------------------------------>

app.post("/api/user/login", async (req, res) => {
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

//----------------------- shopkeeper login router-------------------------->

app.post("/api/shopkeeper/login", async (req, res) => {
  const { shopid, password } = req.body;

  try {
   
    const shopkeeper = await shopkeeperModel.findOne()
      .populate({
        path: 'shop',
        match: { shopId: shopid } 
      });

    if (!shopkeeper) {
      return res.status(404).json({
        success: false,
        message: "Shop ID not found"
      });
    }

    const passverify = await bcrypt.compare(password, shopkeeper.password);
    if (!passverify) {
      return res.status(401).json({
        success: false,
        message: "Incorrect password"
      });
    }

    const token = jwt.sign(
      { id: shopkeeper._id, name: shopkeeper.ShopkeeperName },
      secret_key,
      { expiresIn: "24h" }
    );

    res.cookie('token', token, {
      expires: new Date(Date.now() + 24 * 60 * 60 * 1000),
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'none'
    });

    res.status(200).json({
      success: true,
      message: "Login successful",
      data: {
        token:token,
        userId: shopkeeper._id,
        name: shopkeeper.ShopkeeperName,
        email: shopkeeper.email
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


// Start server
const server = http.createServer(app);
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});