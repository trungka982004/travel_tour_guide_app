const mongoose = require('mongoose');

const activityBookingSchema = new mongoose.Schema({
  activity: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Activity',
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

activityBookingSchema.statics.seedExamples = async function(userIds, activityIds) {
  const examples = [
    { activity: activityIds[0], user: userIds[0], date: new Date('2025-07-13') },
    { activity: activityIds[1], user: userIds[1], date: new Date('2025-07-14') },
    { activity: activityIds[2], user: userIds[2], date: new Date('2025-07-15') },
    { activity: activityIds[3], user: userIds[3], date: new Date('2025-07-16') },
    { activity: activityIds[4], user: userIds[4], date: new Date('2025-07-17') },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const ActivityBooking = mongoose.model('ActivityBooking', activityBookingSchema);

module.exports = ActivityBooking; 