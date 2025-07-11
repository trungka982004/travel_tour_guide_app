const mongoose = require('mongoose');

const restaurantBookingSchema = new mongoose.Schema({
  restaurant: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true,
  },
  user: {
    type: String,
    required: true,
  },
  date: {
    type: Date,
    required: true,
  },
  time: {
    type: String,
    required: true,
  },
  people: {
    type: Number,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    default: 'pending',
    enum: ['pending', 'confirmed', 'cancelled'],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

restaurantBookingSchema.statics.seedExamples = async function(userIds, restaurantIds) {
  const examples = [
    { restaurant: restaurantIds[0], user: userIds[0], date: new Date('2025-07-13'), time: '19:00', people: 2, location: 'indoor' },
    { restaurant: restaurantIds[1], user: userIds[1], date: new Date('2025-07-14'), time: '12:00', people: 4, location: 'outdoor' },
    { restaurant: restaurantIds[2], user: userIds[2], date: new Date('2025-07-15'), time: '08:00', people: 1, location: 'indoor' },
    { restaurant: restaurantIds[3], user: userIds[3], date: new Date('2025-07-16'), time: '20:00', people: 3, location: 'outdoor' },
    { restaurant: restaurantIds[4], user: userIds[4], date: new Date('2025-07-17'), time: '18:00', people: 2, location: 'indoor' },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const RestaurantBooking = mongoose.model('RestaurantBooking', restaurantBookingSchema);

module.exports = RestaurantBooking; 