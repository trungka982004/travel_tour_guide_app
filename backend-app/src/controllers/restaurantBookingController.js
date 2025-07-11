const RestaurantBooking = require('../models/restaurantBooking');

exports.createRestaurantBooking = async (req, res) => {
  try {
    const { restaurant, date, time, people, location } = req.body;
    if (!restaurant || !date || !time || !people || !location) {
      return res.status(400).json({ message: 'Missing fields' });
    }
    const booking = new RestaurantBooking({
      restaurant,
      user: req.user._id,
      date,
      time,
      people,
      location,
    });
    await booking.save();
    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

exports.getRestaurantBookings = async (req, res) => {
  try {
    const bookings = await RestaurantBooking.find({ user: req.user._id });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
}; 