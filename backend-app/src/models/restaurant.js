const mongoose = require('mongoose');

const menuItemSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
});

const restaurantSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  type: {
    type: String,
    required: true,
    enum: ['seafood', 'buffet', 'cafe', 'other'],
  },
  openHours: {
    type: String,
    required: true,
  },
  available: {
    type: Boolean,
    default: true,
  },
  menu: [menuItemSchema],
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

restaurantSchema.statics.seedExamples = async function() {
  const examples = [
    { name: 'Blue Sea Restaurant', description: 'Nhà hàng hải sản', type: 'seafood', openHours: '11:00-22:00', menu: [{ name: 'Cá nướng', price: 150000 }] },
    { name: 'Buffet Paradise', description: 'Buffet đa dạng', type: 'buffet', openHours: '06:00-10:00', menu: [{ name: 'Bánh mì', price: 30000 }] },
    { name: 'Cafe View', description: 'Cà phê sân vườn', type: 'cafe', openHours: '07:00-23:00', menu: [{ name: 'Cà phê sữa', price: 40000 }] },
    { name: 'BBQ Garden', description: 'BBQ ngoài trời', type: 'buffet', openHours: '17:00-22:00', menu: [{ name: 'Thịt nướng', price: 120000 }] },
    { name: 'Sunset Bar', description: 'Bar ngắm hoàng hôn', type: 'cafe', openHours: '16:00-23:00', menu: [{ name: 'Cocktail', price: 90000 }] },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const Restaurant = mongoose.model('Restaurant', restaurantSchema);

module.exports = Restaurant; 