// const User = require('../model/userModel');
const CrateController = require('../controller/crateController');
const UserController = require('../controller/userController');

module.exports = app => {
    app.get('/user', async (req, res) => {
        const users = await UserController.findAll();
        res.json({ users });
    });

    app.get('/user/:userId', async (req, res) => {
        const id = req.params.userId;
        const user = await UserController.findOneById(id);
        if (user !== null) {
            res.json(user)
        } else {
            res.json({ error: 'No user found' })
        }
    });

    app.get('/user/:userId/number/:number', async (req, res) => {
        const { userId, number } = req.params;
        if (userId && number) {
            console.log(number);
            console.log(userId);
            const user = await UserController.findOneByUserIdAndNumber(userId, number);
            if (user) {
                res.json(user.crates[0]);
            }
        }
        res.json({ error: 'ERROR' });
    });

    app.get('/user/:userId/:title', async (req, res) => {
        const { userId, title } = req.params;
        if (userId && title) {
            const user = await UserController.findOneByUserIdAndTitle(userId, title);
            if (user) {
                console.log('LENGTH', user.crates.length);
                if (user.crates.length > 0) {
                    console.log('kleiner error');
                    res.json(user.crates[0]);
                } else {
                    res.json({ error: 'No crate found' })
                }
            } else {
                res.json({ error: 'No crate found' })
            }
        } else {
            res.json({ error: 'No userId or crateId found' })
        }
    });


    app.post('/user', async (req, res) => {
        if (req.body.firstName && req.body.lastName && req.body.email) {
            const { firstName, lastName, email } = req.body;
            const user = await UserController.create(firstName, lastName, email);
            res.json(user);

        } else {
            res.json({ error: 'User info missing' });
        }
    });

    app.post('/user/crate/', async (req, res) => {
        const { userId, crateId } = req.body;
        if (userId && crateId) {
            const crate = await CrateController.findOneById(crateId);
            const user = await UserController.findOneById(userId);

            if (crate !== null && user !== null) {
                // BUG: At the moment you can add multiple the same crates
                const newUser = await UserController.addCrate(user, crate);
                res.json(newUser);
            }
        }
        res.json({ error: 'Something went wrong' });
    });

    app.post('/user/newcrate/', async (req, res) => {
        const { userId, title } = req.body;
        if (userId && title) {
            const user = await UserController.findOneById(userId);
            const crate = await CrateController.create(title);

            if (crate !== null && user !== null) {
                // BUG: At the moment you can add multiple the same crates
                const newUser = await UserController.addCrate(user, crate);
                res.json({ crate: crate });
            }
        }
        res.json({ error: 'Something went wrong' });
    });
}