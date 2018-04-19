const Http = require('http');

module.exports = {
    get: (url, callback) => {
        Http.get(url, (resp) => {
            let data = '';
            // A chunk of data has been recieved.
            resp.on('data', (chunk) => { data += chunk; });
            // The whole response has been received. Print out the result.
            resp.on('end', () => {
                if (resp.statusCode === 200) {
                    callback(JSON.parse(data, false));
                } else {
                    callback(JSON.parse(data, {
                        Error: {
                            statusCode: resp.statusCode,
                        }
                    }));
                }
            });
        }).on("error", (err) => {
            console.log("Error: " + err.message);
        });
    },
}