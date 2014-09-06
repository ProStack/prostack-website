# ProStack Website

## Building and running the site (for development).

1.  Install [Mimosa](http://mimosa.io/).
2.  Install Node.js modules.  From the website directory: `npm install`.
3.  Build and serve the site: `mimosa watch -s` (again, from the website directory).

The command `mimosa watch -s` will allow Mimosa to watch the directory for changes and recompile the bundled JavaScript files and templates.  The `-s` switch will tell Mimosa to serve the website.

## Running the site.

1.  This assumes you've executed `mimosa build`.
2.  Execute the server: `node run.js`.

## Configuring the server.

The server uses a configuration file in the "config" folder.  The configuration is selected based on the `ENVIRONMENT` variable, which can be set via BASH.  If that variable is not set, the default environment will be `development`.
