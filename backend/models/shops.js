const mongoose= require("mongoose");

const ShopSchema = new mongoose.Schema({
    shopId:{
      type:String,
      required:true
    },
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
    location: { 
        type: String,
        required: true 
    },
    pincode: {
        type: String,
        required: true
    },
    inventory: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Inventory' }],
    orders: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Orders' }],
    debt_customers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Customers' }]
});

const Shop = mongoose.model("Shops", ShopSchema);

module.exports = Shop;