const express = require('express');

const mongoose = require('mongoose');

const bodyParser = require('body-parser');
const dbdata = require('./config').database;
const app = express();
const port = 3002;

const crateController = require('./controller/crateController')

app.use(bodyParser.urlencoded({ extended: true }));

mongoose.connect(dbdata.url);
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', err => {
    if (err) throw err

    require('./routes')(app);

    app.listen(port, () => {
        console.log('We are live  ' + port);
        updater();
    });
});

//CHANGE DATA EVERY FIVE SECONDS
function updater() {
    const crateController = require('./controller/crateController');

    async function updateCrate() {
        const crates = await crateController.findAll();
        for (const crate in crates) {
            const temperature = Math.floor(Math.random() * (40 - 10)) + 10;
            const humidity = Math.floor(Math.random() * (100 - 70)) + 70;
            await crateController.update(crates[crate]._id, temperature, humidity);
        }

        setTimeout(updateCrate, 1 * 5000);
    }
    setTimeout(updateCrate, 1 * 5000);
}
