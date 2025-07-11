const Restaurant = require('../models/restaurant');

class RestaurantController {
  // GET /restaurants
  async getAllRestaurants(req, res) {
    try {
      const restaurants = await Restaurant.find();
      res.status(200).json(restaurants);
    } catch (error) {
      res.status(500).json({ message: 'Failed to fetch restaurants', error: error.message });
    }
  }

  // POST /restaurants
  async createRestaurant(req, res) {
    try {
      const { name, description, type, openHours, available, menu } = req.body;
      const newRestaurant = new Restaurant({ name, description, type, openHours, available, menu });
      await newRestaurant.save();
      res.status(201).json(newRestaurant);
    } catch (error) {
      res.status(400).json({ message: 'Failed to create restaurant', error: error.message });
    }
  }
}

module.exports = RestaurantController; 