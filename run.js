require('coffee-script');

// Determine the environment to use from the Environment property
// 'ENVIRONMENT'.  This will default to 'development'.
var environment = process.env.ENVIRONMENT || "development";

// Grab the correct config for the environment.
var config = require("./config/" + environment + ".json");

// Start the server.
require('./server.coffee').startServer(config, function(l){});
