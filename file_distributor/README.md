# File Distributor

Python 3 scripts which download a file from Dropbox and upload it to pCloud and Google Drive.

## Setup

### Custom Modules

Complete the _Setup_ sections of the following Python modules from [Utilities](https://github.com/jleung51/utilities) to set them up in this directory:

* [Logger](https://github.com/jleung51/utilities/tree/master/python_modules/logger)
* [Google API](https://github.com/jleung51/utilities/tree/master/python_modules/api_wrappers/google_api)
* [pCloud API](https://github.com/jleung51/utilities/tree/master/python_modules/api_wrappers/pcloud_api)

### Dropbox

Install the pip dependency `dropbox`.

Follow the first few steps in the [Dropbox Developers Tutorial](https://www.dropbox.com/developers/documentation/python#tutorial) to create a Dropbox API application and generate its access token.

### All Scripts

In `file_distributor.cfg`, fill in the variables as described.
