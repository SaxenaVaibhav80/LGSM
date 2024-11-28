const mongoose = require("mongoose");

const ShopkeeperSchema = new mongoose.Schema({
    name: { 
        type: String,
        required: true
    },
    email: { 
        type: String,
        required: true,
        unique: true 
    },
    phone: { 
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
        required: true 
    }
});

module.exports = mongoose.model("ShopKeeper", ShopkeeperSchema);
