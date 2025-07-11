const ActivityBooking = require('../models/activityBooking');

exports.createActivityBooking = async (req, res) => {
  try {
    const { activity, date } = req.body;
    if (!activity || !date) {
      return res.status(400).json({ message: 'Missing fields' });
    }
    const booking = new ActivityBooking({
      activity,
      user: req.user._id,
      date,
    });
    await booking.save();
    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getActivityBookings = async (req, res) => {
  try {
    const bookings = await ActivityBooking.find({ user: req.user._id });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
}; 