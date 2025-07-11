require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('MongoDB connected!'))
.catch((err) => console.error('MongoDB connection error:', err));

const routes = require('./routes');
const serviceRoutes = require('./routes/serviceRoutes');
const serviceBookingRoutes = require('./routes/serviceBookingRoutes');
const activityRoutes = require('./routes/activityRoutes');
const activityBookingRoutes = require('./routes/activityBookingRoutes');
const restaurantRoutes = require('./routes/restaurantRoutes');
const restaurantBookingRoutes = require('./routes/restaurantBookingRoutes');
const bookingRoutes = require('./routes/bookingRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');

// Register routes
app.use('/api', routes);
app.use('/api/services', serviceRoutes);
app.use('/api/service-bookings', serviceBookingRoutes);
app.use('/api/activities', activityRoutes);
app.use('/api/activity-bookings', activityBookingRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/restaurant-bookings', restaurantBookingRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/recommendations', recommendationRoutes);

// Simple route
app.get('/', (req, res) => {
  res.send('Hello from Express and MongoDB!');
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});