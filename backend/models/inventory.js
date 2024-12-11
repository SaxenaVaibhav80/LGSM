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
    ]
});

const Inventory = mongoose.model('Inventory', InventorySchema);

module.exports = Inventory;