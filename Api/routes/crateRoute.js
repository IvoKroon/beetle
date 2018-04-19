const Crate = require('../controller/crateController');
const Recipe = require('../controller/recipeController');

module.exports = app => {
    // CREATE: crate
    app.post('/crate', async (req, res) => {
        if (req.body.title) {
            const { title } = req.body;
            const crate = await Crate.create(title);
            res.json({ crate });
        } else {
            res.json({ error: 'Error no title found' });
        }
    });
    // REMOVE: crate
    app.delete('/crate', async (req, res) => {
        if (req.body.id) {
            const { id } = req.body;
            if (Crate.remove(id)) {
                res.json({ success: 'Successfull removed' })
            } else {
                res.json({ error: 'Something went wrong removing' })
            }
        } else {
            res.json({ error: 'Error no title found!' });
        }
    });

    // GET: all crates
    app.get('/crate', async (req, res) => {
        if (req.query.userId && req.query.title) {
            const { userId, title } = req.query;

        } else {
            const crates = await Crate.findAll();
            res.json(crates);
        }
    });

    // GET: crate by id
    app.get('/crate/:id', async (req, res) => {
        const id = req.params.id;
        const crate = await Crate.findOneById(id);
        if (crate !== null) {
            res.json({ crate })
        } else {
            res.json({ error: 'No crate found' })
        }
    });



    app.post('/crate/addrecipe/', async (req, res) => {
        const { crateId, recipeId } = req.body;
        if (crateId && recipeId) {
            const crate = await Crate.findOneById(crateId);
            const recipe = await Recipe.findOneById(recipeId);
            if (crate !== null && recipe !== null) {
                const result = await Crate.addRecipe(crate, recipe);
                res.json(result);
            } else {
                res.json({ error: 'Not the right crate or recipe ID' })
            }
        } else {
            res.json({ error: 'No crate or recipe ID found' })
        }
    });
}