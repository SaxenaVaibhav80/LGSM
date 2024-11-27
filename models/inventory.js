const mongoose= require("mongoose")

const InventorySchema = new mongoose.Schema({
    inventory_id: { 
        type: String,
        required: true,
        unique: true 
    },
    shop_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Shops', 
        required: true 
    },
    item_name: { 
        type: String, 
        required: true 
    },
    item_type: { 
        type: String, 
        required: true
     },
    stock_quantity: { 
        type: Number, 
        required: true 
    },
    price: {
        type: Number,
        required: true 
    },
    low_stock_threshold: {
        type: Number, 
        required: true 
    }
});

module.exports = mongoose.model('Inventory', InventorySchema);