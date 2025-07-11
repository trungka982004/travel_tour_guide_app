const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/', bookingController.getBookings);
router.post('/', bookingController.createBooking);
router.patch('/bookings/:id/cancel', bookingController.cancelBooking);
router.patch('/bookings/:id/restore', bookingController.restoreBooking);
router.patch('/bookings/:id', bookingController.updateBooking);

module.exports = router; 