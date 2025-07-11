const express = require('express');
const ActivityController = require('../controllers/activityController');

const router = express.Router();
const activityController = new ActivityController();

router.get('/', activityController.getAllActivities.bind(activityController));
router.post('/', activityController.createActivity.bind(activityController));

module.exports = router; 