const mongoose = require('mongoose');

const itemSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

const Item = mongoose.model('Item', itemSchema);

module.exports = {
  User: require('./user'),
  Activity: require('./activity'),
  Service: require('./service'),
  Restaurant: require('./restaurant'),
  Booking: require('./booking'),
  ActivityBooking: require('./activityBooking'),
  ServiceBooking: require('./serviceBooking'),
  RestaurantBooking: require('./restaurantBooking'),
};