const express = require('express');
const router = express.Router();
const serviceBookingController = require('../controllers/serviceBookingController');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/', serviceBookingController.getServiceBookings);
router.post('/', serviceBookingController.createServiceBooking);
// ... other service booking endpoints ...

module.exports = router; 