const express = require('express');
const RecommendationController = require('../controllers/recommendationController');

const router = express.Router();
const recommendationController = new RecommendationController();

router.get('/', recommendationController.getRecommendations.bind(recommendationController));

module.exports = router; 