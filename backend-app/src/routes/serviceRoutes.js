const express = require('express');
const ServiceController = require('../controllers/serviceController');

const router = express.Router();
const serviceController = new ServiceController();

router.get('/', serviceController.getAllServices.bind(serviceController));
router.post('/', serviceController.createService.bind(serviceController));

module.exports = router; 