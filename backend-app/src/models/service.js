const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
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
    enum: ['room', 'activity', 'restaurant', 'transport', 'other'],
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

serviceSchema.statics.seedExamples = async function() {
  const examples = [
    { name: 'Suite Ocean View', description: 'Phòng hướng biển sang trọng', type: 'room', available: true },
    { name: 'Đưa rước sân bay', description: 'Dịch vụ đưa rước sân bay', type: 'transport', available: true },
    { name: 'Bộ bơi nam', description: 'Thuê bộ bơi nam', type: 'other', available: true },
    { name: 'Hướng dẫn viên', description: 'Dịch vụ hướng dẫn viên du lịch', type: 'other', available: true },
    { name: 'Dịch vụ giặt ủi', description: 'Giặt ủi quần áo', type: 'other', available: true },
  ];
  await this.deleteMany({});
  await this.insertMany(examples);
};

const Service = mongoose.model('Service', serviceSchema);

module.exports = Service; 