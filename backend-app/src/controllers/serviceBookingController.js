const ServiceBooking = require('../models/serviceBooking');

exports.createServiceBooking = async (req, res) => {
  try {
    const { service, date, details } = req.body;
    if (!service || !date) {
      return res.status(400).json({ message: 'Missing fields' });
    }
    const booking = new ServiceBooking({
      service,
      user: req.user._id,
      date,
      details,
    });
    await booking.save();
    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getServiceBookings = async (req, res) => {
  try {
    const bookings = await ServiceBooking.find({ user: req.user._id });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
}; 