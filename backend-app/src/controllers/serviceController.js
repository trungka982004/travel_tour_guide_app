const Service = require('../models/service');

class ServiceController {
  // GET /services
  async getAllServices(req, res) {
    try {
      const services = await Service.find();
      res.status(200).json(services);
    } catch (error) {
      res.status(500).json({ message: 'Failed to fetch services', error: error.message });
    }
  }

  // POST /services
  async createService(req, res) {
    try {
      const { name, description, type, available, details } = req.body;
      const newService = new Service({ name, description, type, available, details });
      await newService.save();
      res.status(201).json(newService);
    } catch (error) {
      res.status(400).json({ message: 'Failed to create service', error: error.message });
    }
  }
}

module.exports = ServiceController; 