
const mongoose= require("mongoose");

const TransactionsSchema = new mongoose.Schema({

    order_id:{
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Orders',
        required: true
        },
    customer_id:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Customers',
        required: true
    },
    amount:{ 
        type: Number,
        required: true 
    },
    payment_method: { 
        type: String,
        required: true 
    }
});

module.exports = mongoose.model('Transactions', TransactionsSchema);