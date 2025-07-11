const Activity = require('../models/activity');

class ActivityController {
  // GET /activities
  async getAllActivities(req, res) {
    try {
      const activities = await Activity.find();
      res.status(200).json(activities);
    } catch (error) {
      res.status(500).json({ message: 'Failed to fetch activities', error: error.message });
    }
  }

  // POST /activities
  async createActivity(req, res) {
    try {
      const { name, description, type, date, time, available, details } = req.body;
      const newActivity = new Activity({ name, description, type, date, time, available, details });
      await newActivity.save();
      res.status(201).json(newActivity);
    } catch (error) {
      res.status(400).json({ message: 'Failed to create activity', error: error.message });
    }
  }
}

module.exports = ActivityController; 