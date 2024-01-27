const fs = require('fs');
const http = require('http');
const https = require('https');

async function uploadFile(sourcePath, destinationPath) {
    const fileStream = fs.createReadStream(sourcePath);

    const url = new URL(destinationPath);
    const httpModule = url.protocol === 'https:' ? https : http;
    const options = {
        hostname: url.hostname,
        port: url.port,
        path: url.pathname,
        method: 'POST',
        headers: {
            'Content-Type': 'application/octet-stream'
        },
        // Custom agent with rejectUnauthorized set to false
        agent: new httpModule.Agent({
            rejectUnauthorized: false
        }),
    };

    return new Promise((resolve, reject) => {
        const req = httpModule.request(options, res => {
            res.on('data', d => {
                process.stdout.write(d);
            });
            res.on('end', resolve);
        });

        req.on('error', error => {
            console.error(error);
            reject(error);
        });

        fileStream.on('error', error => {
            console.error(error);
            reject(error);
        });

        const startTime = Date.now();
        fileStream.pipe(req).on('finish', () => {
            const endTime = Date.now();
            const fileSize = fs.statSync(sourcePath).size / 1024 / 1024; // Size in MB
            const timeElapsed = endTime - startTime; // Time in ms
            const speed = fileSize / (timeElapsed / 1000); // Speed in MB/s

            console.log(`File size: ${fileSize} MB`);
            console.log(`Speed: ${speed} MB/s`);
            console.log(`Time: ${timeElapsed} ms`);
        });
    });
}

async function main() {
    console.log('Uploading file...');
    await uploadFile('../dart/test_file', 'https://localhost:3000');
}

main().catch(console.error);
