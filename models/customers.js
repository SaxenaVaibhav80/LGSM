const mongoose= require("mongoose")

const CustomerSchema = new mongoose.Schema({
    customer_id:{
        type: String,
        required: true,
        unique: true 
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
    debt_balance: { 
        type: Number, 
        required: true, 
        default: 0 
    },
    shop_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Shops',
        required: true 
    },
    order_history: [{ 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Orders'
    }]
});

module.exports = mongoose.model('Customers', CustomerSchema);