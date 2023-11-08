var express = require('express');
var router = express.Router();

router.get('/api/test', (req, res) => {
  // Handle API request
  res.json({ message: 'Test api get response' });
});

router.post('/api/test', (req, res) => {
  // Handle API request
  res.json({ message: 'Test api post response' });
});

module.exports = router;