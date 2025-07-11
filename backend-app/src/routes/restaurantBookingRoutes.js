const express = require('express');
const router = express.Router();
const restaurantBookingController = require('../controllers/restaurantBookingController');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/', restaurantBookingController.getRestaurantBookings);
router.post('/', restaurantBookingController.createRestaurantBooking);
// ... other restaurant booking endpoints ...

module.exports = router; 