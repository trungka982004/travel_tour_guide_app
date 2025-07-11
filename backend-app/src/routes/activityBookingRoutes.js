const express = require('express');
const router = express.Router();
const activityBookingController = require('../controllers/activityBookingController');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/', activityBookingController.getActivityBookings);
router.post('/', activityBookingController.createActivityBooking);
// ... other activity booking endpoints ...

module.exports = router; 