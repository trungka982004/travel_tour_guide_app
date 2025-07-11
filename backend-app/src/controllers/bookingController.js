const Booking = require('../models/booking');

exports.createBooking = async (req, res) => {
  try {
    const { service, startDate, endDate, details } = req.body;
    if (!service || !startDate || !endDate) {
      return res.status(400).json({ message: 'Missing fields' });
    }
    const booking = new Booking({
      service,
      user: req.user._id,
      startDate,
      endDate,
      details,
    });
    await booking.save();
    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getBookings = async (req, res) => {
  try {
    const bookings = await Booking.find({ user: req.user._id });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.cancelBooking = async (req, res) => {
  try {
    const { id } = req.params;
    const booking = await Booking.findByIdAndUpdate(
      id,
      { status: 'cancelled' },
      { new: true }
    );
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }
    res.status(200).json(booking);
  } catch (error) {
    res.status(400).json({ message: 'Failed to cancel booking', error: error.message });
  }
};

exports.restoreBooking = async (req, res) => {
  try {
    const { id } = req.params;
    const booking = await Booking.findByIdAndUpdate(
      id,
      { status: 'pending' },
      { new: true }
    );
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }
    res.status(200).json(booking);
  } catch (error) {
    res.status(400).json({ message: 'Failed to restore booking', error: error.message });
  }
};

exports.updateBooking = async (req, res) => {
  try {
    const { id } = req.params;
    const { startDate, endDate } = req.body;
    const booking = await Booking.findByIdAndUpdate(
      id,
      { startDate, endDate },
      { new: true }
    );
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }
    res.status(200).json(booking);
  } catch (error) {
    res.status(400).json({ message: 'Failed to update booking', error: error.message });
  }
}; 