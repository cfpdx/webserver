var express = require('express');
var router = express.Router();

// Handle all other routes by serving the React app's "index.html"
router.get('/*', (req, res) => {
  res.set('Cache-Control', 'no-store, no-cache, must-revalidate, private')
  res.sendFile(path.join(__dirname, 'client', 'index.html'));
});

module.exports = router;
