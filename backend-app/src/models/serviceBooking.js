const mongoose = require('mongoose');

const serviceBookingSchema = new mongoose.Schema({
  service: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Service',
    required: true,
  },
  user: {
    type: String, // Replace with ObjectId ref 'User' if user system is implemented
    required: true,
  },
  date: {
    type: Date,
    required: true,
  },
  details: {
    type: Object,
    default: {},
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

serviceBookingSchema.statics.seedExamples = async function(userIds, serviceIds) {
  const examples = [
    { service: serviceIds[0], user: userIds[0], date: new Date('2025-07-13') },
    { service: serviceIds[1], user: userIds[1], date: new Date('2025-07-14') },
    { service: serviceIds[2], user: userIds[2], date: new Date('2025-07-15') },
    { service: serviceIds[3], user: userIds[3], date: new Date('2025-07-16') },
    { service: serviceIds[4], user: userIds[4], date: new Date('2025-07-17') },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const ServiceBooking = mongoose.model('ServiceBooking', serviceBookingSchema);

module.exports = ServiceBooking; 