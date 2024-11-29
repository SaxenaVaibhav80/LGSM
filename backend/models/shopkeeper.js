
const mongoose = require("mongoose");

const ShopkeeperSchema = new mongoose.Schema({
    ShopName: { 
        type: String,
        required: true
    },
    ShopkeeperName: { 
        type: String,
        required: true
    },
    email: { 
        type: String,
        required: true,
        unique: true 
    },
    address:{
        type: String,
        required: true,
    },
    phone: { 
        type: String, 
        required: true 
    },
    pincode:{
        type: String, 
        required: true 
    },
    password: { 
        type: String, 
        required: true 
    },
    shop: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: "Shops", 
        required: true ,
        default:null
    }
    
});

const ShopKeeper = mongoose.model("ShopKeeper",  ShopkeeperSchema );

module.exports =  ShopKeeper;