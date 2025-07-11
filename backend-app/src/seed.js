require('dotenv').config();
const mongoose = require('mongoose');
const { User, Activity, Service, Restaurant, Booking, ActivityBooking, ServiceBooking, RestaurantBooking } = require('./models');
const db = require('./config/db');

async function seed() {
  await db();
  console.log('Seeding users...');
  await User.seedExamples();
  const users = await User.find();
  console.log('Seeding activities...');
  await Activity.seedExamples();
  const activities = await Activity.find();
  console.log('Seeding services...');
  await Service.seedExamples();
  const services = await Service.find();
  console.log('Seeding restaurants...');
  await Restaurant.seedExamples();
  const restaurants = await Restaurant.find();
  console.log('Seeding bookings...');
  await Booking.seedExamples(users.map(u => u._id), services.map(s => s._id));
  console.log('Seeding activity bookings...');
  await ActivityBooking.seedExamples(users.map(u => u._id), activities.map(a => a._id));
  console.log('Seeding service bookings...');
  await ServiceBooking.seedExamples(users.map(u => u._id), services.map(s => s._id));
  console.log('Seeding restaurant bookings...');
  await RestaurantBooking.seedExamples(users.map(u => u._id), restaurants.map(r => r._id));
  console.log('Seeding complete!');
  mongoose.connection.close();
}

seed(); 