const mongoose= require("mongoose")

const InventorySchema = new mongoose.Schema({
    shop_id: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Shops', 
        required: true 
    },
    items: [
        {
            item_catagory: { 
                type: String,
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
            packets: [
                {
                    packet_weight: { 
                        type: Number, 
                        required: true 
                    },
                    packet_quantity: { 
                        type: Number, 
                        required: true 
                    }
                }
            ],
            price: { 
                type: Number, 
                required: true
            },
            low_stock_threshold: { 
                type: Number, 
                required: true 
            },
            item_icon: { 
                type: String,
                required: false 
            }
        }
    ]
});

const Inventory = mongoose.model('Inventory', InventorySchema);

module.exports = Inventory;