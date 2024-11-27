const mongoose= require("mongoose")

const DebtSystemSchema = new mongoose.Schema({

    customer_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Customers', 
        required: true 
    },
    shop_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Shops', 
        required: true 
    },
    debt_limit: { 
        type: Number, 
        required: true 
    },
    current_debt: { 
        type: Number, 
        required: true, 
        default: 0 
    },
    debt_history: [{
        amount: Number,
        date: { type: Date, default: Date.now },
        description: String
    }]
});

module.exports = mongoose.model('DebtSystem', DebtSystemSchema);