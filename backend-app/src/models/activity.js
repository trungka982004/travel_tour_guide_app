const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
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
    enum: ['sport', 'culture', 'relaxation', 'excursion', 'other'],
  },
  date: {
    type: Date,
    required: true,
  },
  time: {
    type: String,
    required: true,
  },
  available: {
    type: Boolean,
    default: true,
  },
  details: {
    type: Object,
    default: {},
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

activitySchema.statics.seedExamples = async function() {
  const examples = [
    { name: 'Tour Vũng Tàu', description: 'Tham quan thành phố biển Vũng Tàu', type: 'excursion', date: new Date('2025-07-13'), time: '08:00', available: true },
    { name: 'Tour Hồ Tràm', description: 'Khám phá Hồ Tràm hoang sơ', type: 'excursion', date: new Date('2025-07-14'), time: '09:00', available: true },
    { name: 'Kayak Adventure', description: 'Chèo kayak trên biển', type: 'sport', date: new Date('2025-07-12'), time: '10:00', available: true },
    { name: 'Yoga Buổi Sáng', description: 'Yoga thư giãn buổi sáng', type: 'relaxation', date: new Date('2025-07-12'), time: '06:30', available: true },
    { name: 'BBQ Party', description: 'Tiệc BBQ ngoài trời', type: 'culture', date: new Date('2025-07-12'), time: '19:00', available: true },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const Activity = mongoose.model('Activity', activitySchema);

module.exports = Activity; 