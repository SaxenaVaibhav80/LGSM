const mongoose= require("mongoose");

const OrdersSchema = new mongoose.Schema({
    order_id: { 
        type: String, 
        required: true, 
        unique: true 
    },
    shop_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Shops', 
        required: true 
    },
    customer_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Customers', 
        required: true 
    },
    items: [{
        item_name: String,
        quantity: Number,
        price: Number
    }],
    total_amount: { type: Number, required: true },
    pickup_time: { type: Date, required: true },
    order_status: { type: String, required: true }
});

module.exports = mongoose.model('Orders', OrdersSchema);