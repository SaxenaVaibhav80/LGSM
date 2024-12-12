const express = require("express");
const db = require("./config/dbConfig.js");
const http = require("http");
const dotenv = require("dotenv");
const bcrypt = require("bcrypt");
const userModel = require("./models/user.js");
const jwt = require("jsonwebtoken");
const shopkeeperModel = require("./models/shopkeeper.js")
const inventoryModel = require("./models/inventory.js")
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
    const uid = `${pin}${upperabbr}${day}_${quantity+1}`
    return uid
  }
  else{
    const uid = `${pin}${upperabbr}_${day}1`
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
        shopID:shop.shopId
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

//-----sending catagories ----------->

app.get('/categories', (req, res) => {
  const categories = [

      {
          name: "Groceries",
          image_url: "https://media.istockphoto.com/id/1248691232/vector/set-of-packs-of-cereals-grains-nuts-on-shelf-for-kitchen-storage.jpg?s=612x612&w=0&k=20&c=LV9HUtSoSrYG-gSPW7A6Bpo6IiuwHhQfrwumd1SacvQ="
      },
      {
          name: "Fruits and Vegetables",
          image_url: "https://cdn-icons-png.flaticon.com/512/3362/3362707.png"
      },
      {
          name: "Dairy",
          image_url: "https://static.vecteezy.com/system/resources/previews/027/276/924/non_2x/dairy-products-icon-in-illustration-vector.jpg"
      },
      {
          name: "Snacks",
          image_url: "https://img.freepik.com/premium-vector/food-snack-illustration-vector-eat-set-icon-isolated-sweet-dessert-drink-chocolate-candy_1013341-5743.jpg"
      },
      {
          name: "Beverages",
          image_url: "https://cdn-icons-png.freepik.com/256/2405/2405451.png?semt=ais_hybrid"
      },
      {
          name: "Household",
          image_url: "https://cdn-icons-png.flaticon.com/256/11512/11512671.png"
      },
      {
          name: "Personal Care",
          image_url: "https://cdn-icons-png.flaticon.com/512/3901/3901586.png"
      },
      {
          name: "Baby Care",
          image_url: "https://st2.depositphotos.com/47577860/45962/v/450/depositphotos_459622354-stock-illustration-baby-care-dream-icon.jpg"
      },
      {
          name: "Health and Wellness",
          image_url: "https://cdn-icons-png.flaticon.com/512/4480/4480318.png"
      },
      {
          name: "Home and Kitchen",
          image_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYXHxpUc7lb0Oi9gD3Q7J0kKHsSxoq3RoBlQ&s"
      },
      {
          name: "Pet Care",
          image_url: "https://cdn-icons-png.flaticon.com/512/2138/2138440.png"
      },
      {
          name: "Stationary and Books",
          image_url: "https://static.vecteezy.com/system/resources/previews/014/367/543/non_2x/stationary-book-calculator-pen-business-flat-line-filled-icon-banner-template-free-vector.jpg"
      },
      {
          name: "Festival and Seasonal",
          image_url: "https://img.freepik.com/premium-vector/diwali-festive-offer-background-design-template_649214-869.jpg"
      }
  ];

    res.json({ success: true, data: categories });
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

// ----------------------Add stock post handler --------------------------->

app.post("/api/addStock", async (req, res) => {
  const { productName, productType, category, quantity, unit, pricePerUnit, expiryDate, productImage , token} = req.body;


  if (token) {
    try {
      const verification = jwt.verify(token, secret_key);
      const shopkeeper_id = verification.id;
      const shopkeeper = await shopkeeperModel.findOne({_id:shopkeeper_id }).populate("shop");
      console.log(shopkeeper)

      if (!shopkeeper || !shopkeeper.shop) {
        return res.status(404).json({ message: "Shop not found" });
      }

      let inventory = await inventoryModel.findOne({ shop_id: shopkeeper.shop._id });

      if (!inventory) {
        inventory = await inventoryModel.create({
          shop_id: shopkeeper.shop._id,
          loose: [],
          packed: []
        });
      }

      const existingProduct = await inventoryModel.findOne({
        shop_id: shopkeeper.shop._id,
        $or: [
          { 'loose.productName': productName, 'loose.category': category },
          { 'packed.productName': productName, 'packed.category': category }
        ]
      });

      if (existingProduct) {
        return res.status(400).json({ message: "Product already exists" });
      }

     
      if (productType === 'Loose') {
        await inventoryModel.updateOne(
          { shop_id: shopkeeper.shop._id },
          {
            $push: {
              loose: {
                productName, productType, category, quantity, unit, pricePerUnit, expiryDate, productImage
              }
            }
          }
        );
        res.status(201).json({ message: "Loose product added successfully" });
      } else if (productType === 'Packed') {
        await inventoryModel.updateOne(
          { shop_id: shopkeeper.shop._id },
          {
            $push: {
              packed: {
                productName, productType, category, quantity, unit, pricePerUnit, expiryDate, productImage
              }
            }
          }
        );
        res.status(201).json({ message: "Packed product added successfully" });
      } else {
        return res.status(400).json({ message: "Invalid product type. It should be 'loose' or 'packed'" });
      }

    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: "Internal server error" });
    }
  } else {
    return res.status(401).json({ message: "Unauthorized. Please login." });
  }
});




//----------------------- shopkeeper login router-------------------------->

app.post("/api/shopkeeper/login", async (req, res) => {
  const { shopid, password } = req.body;
  console.log(shopid,password)
  

  try {
   
    const shop = await ShopsModel.findOne({ shopId: shopid })
    const shopkeeper = await shopkeeperModel.findOne({shop:shop._id})

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