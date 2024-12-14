const mongoose= require("mongoose")

const InventorySchema = new mongoose.Schema({
    shop_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Shops', 
        required: true 
    },
    loose: [
        {
           productName: String,
           productType:String,
           category: String,
           quantity: Number,
           unit: String,
           pricePerUnit: Number,
           expiry: Date, 
        }
    ],
    packed:[
        {
            productName: String,
            productType:String,
            category: String,
            quantity: Number,
            unit: String,
            pricePerUnit: Number,
            expiry: Date, 

        }
    ],
    categories: [{
        category:String,
        productName:String,
        discription:String,

        count:{
           type: Number,
           default:0
        }
    }],

    units:[String]
});

const Inventory = mongoose.model('Inventory', InventorySchema);

module.exports = Inventory;