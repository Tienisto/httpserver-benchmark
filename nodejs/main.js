const http = require('http');
const https = require('https');
const fs = require('fs');

const PORT = 3000;
const HOST = '0.0.0.0';

const privateKey = fs.readFileSync('privateKey.pem', 'utf8');
const certificate = fs.readFileSync('cert.pem', 'utf8');

const credentials = { key: privateKey, cert: certificate };

const requestHandler = async (request, response) => {
    // const fileStream = fs.createWriteStream('uploaded_file');

    for await (const chunk of request) {
        // fileStream.write(chunk);
    }

    // fileStream.end();
    response.statusCode = 200;
    response.end();
};

// const server = http.createServer(requestHandler); // disable https
const server = https.createServer(credentials, requestHandler);

server.listen(PORT, HOST, () => {
    console.log(`Server listening on https://${HOST}:${PORT}`);
});
