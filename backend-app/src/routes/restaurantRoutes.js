const express = require('express');
const RestaurantController = require('../controllers/restaurantController');

const router = express.Router();
const restaurantController = new RestaurantController();

router.get('/', restaurantController.getAllRestaurants.bind(restaurantController));
router.post('/', restaurantController.createRestaurant.bind(restaurantController));

module.exports = router; 