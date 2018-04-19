const RecipePartController = require('../controller/recipePartController');

module.exports = app => {
    // CREATE: crate
    app.post('/recipepart', async (req, res) => {
        const { title, description, days, hours, minutes } = req.body;
        if (title && description && days && hours && minutes) {
            // make right time
            dayTime = parseInt(days) * 86400;
            hourTime = parseInt(hours) * 3600;
            minuteTime = parseInt(minutes) * 60;

            time = dayTime + hourTime + minuteTime;
            const recipePart = await RecipePartController.create(title, description, time);
            res.json(recipePart);
        } else {
            res.json({ error: 'Error no title found' });
        }
    });
    // REMOVE: crate
    app.delete('/recipepart', async (req, res) => {
        const { id } = req.body;
        if (id) {
            if (RecipePartController.remove(id)) {
                res.json({ success: 'Successfull removed' })
            } else {
                res.json({ error: 'Something went wrong removing' })
            }
        } else {
            res.json({ error: 'Error no title found!' });
        }
    });

    // GET: crate by id
    app.get('/recipepart/:id', async (req, res) => {
        const { id } = req.params;
        const recipePartController = await RecipePartController.findOneById(id);
        if (recipePartController !== null) {
            res.json(recipePartController);
        } else {
            res.json({ error: 'No user found' })
        }

    })
}