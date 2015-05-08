var fs = require('fs'),
    path = require('path'),
    serverPath = process.env['OMNISHARP'],
    win32 = process.platform === 'win32',
    command = win32 ? 'omnisharp.cmd' : 'omnisharp';
    
// Long paths... are evil.
if (win32 && !serverPath && __dirname.indexOf('omnisharp-node-client') > -1) {
    var localPath = path.resolve(__dirname, '../../../../..', 'node_modules/omnisharp-server-roslyn-binaries/lib/server/' + command);
    var nodeClientPath = path.resolve(__dirname, '../../../../..', 'node_modules/omnisharp-node-client/');
    var lstats;
    if (fs.existsSync(nodeClientPath)) {
        lstats = fs.lstatSync(nodeClientPath);
    }
    
    if ((!lstats || !lstats.isSymbolicLink()) && fs.existsSync(localPath)) {
        serverPath = localPath;
    }
}

if (!serverPath) {    
    serverPath = path.resolve(__dirname, './server/' + command);
}

module.exports = serverPath;