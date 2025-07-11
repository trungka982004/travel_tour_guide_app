const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  service: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Service',
    required: true,
  },
  user: {
    type: String,
    required: true,
  },
  startDate: {
    type: Date,
    required: true,
  },
  endDate: {
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

bookingSchema.statics.seedExamples = async function(userIds, serviceIds) {
  const examples = [
    { service: serviceIds[0], user: userIds[0], startDate: new Date('2025-07-13'), endDate: new Date('2025-07-14') },
    { service: serviceIds[1], user: userIds[1], startDate: new Date('2025-07-14'), endDate: new Date('2025-07-15') },
    { service: serviceIds[2], user: userIds[2], startDate: new Date('2025-07-15'), endDate: new Date('2025-07-16') },
    { service: serviceIds[3], user: userIds[3], startDate: new Date('2025-07-16'), endDate: new Date('2025-07-17') },
    { service: serviceIds[4], user: userIds[4], startDate: new Date('2025-07-17'), endDate: new Date('2025-07-18') },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const Booking = mongoose.model('Booking', bookingSchema);

module.exports = Booking; 