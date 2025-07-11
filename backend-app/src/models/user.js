const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
}, { timestamps: true });

userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

userSchema.methods.comparePassword = function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

userSchema.statics.seedExamples = async function() {
  const examples = [
    { name: 'Alice', email: 'alice@example.com', password: 'password123' },
    { name: 'Bob', email: 'bob@example.com', password: 'password123' },
    { name: 'Charlie', email: 'charlie@example.com', password: 'password123' },
    { name: 'David', email: 'david@example.com', password: 'password123' },
    { name: 'Eve', email: 'eve@example.com', password: 'password123' },
  ];
  await this.deleteMany({});
  for (const user of examples) {
    await this.create(user);
  }
};

module.exports = mongoose.model('User', userSchema); 