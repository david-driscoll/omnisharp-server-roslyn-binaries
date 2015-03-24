var fs= require('fs')
    , path = require('path')
    , serverPath = path.resolve(__dirname, './server/' + (process.platform === 'win32' ? 'omnisharp.cmd' : 'omnisharp'));

module.exports = serverPath;

