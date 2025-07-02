require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('MongoDB connected!'))
.catch((err) => console.error('MongoDB connection error:', err));

// Simple route
app.get('/', (req, res) => {
  res.send('Hello from Express and MongoDB!');
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});