const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middleware/auth');

// Auth endpoints
router.post('/auth/register', userController.register);
router.post('/auth/login', userController.login);

// Booking-related routers (all JWT-protected)
router.use('/bookings', require('./bookingRoutes'));
router.use('/service-bookings', require('./serviceBookingRoutes'));
router.use('/activity-bookings', require('./activityBookingRoutes'));
router.use('/restaurant-bookings', require('./restaurantBookingRoutes'));
router.patch('/user', auth, userController.updateProfile);

// ... other resource routes ...
router.use('/services', auth, require('./serviceRoutes'));
router.use('/activities', auth, require('./activityRoutes'));
router.use('/restaurants', auth, require('./restaurantRoutes'));
router.use('/recommendations', auth, require('./recommendationRoutes'));

module.exports = router;