const Util = require('../util');
const RecipeController = require('../controller/recipeController');


module.exports = app => {
    // CREATE: crate
    app.post('/recipe', async (req, res) => {
        const { title, description } = req.body;
        if (title && description) {
            const recipe = await RecipeController.create(title, description);
            res.json(recipe);
        } else {
            res.json({ error: 'Error no title or description found' });
        }
    });
    // REMOVE: crate
    app.delete('/recipe', async (req, res) => {
        const { id } = req.body;
        if (id) {
            if (RecipeController.remove(id)) {
                res.json({ success: 'Successfull removed' })
            } else {
                res.json({ error: 'Something went wrong removing' })
            }
        } else {
            res.json({ error: 'Error no ID found!' });
        }
    });

    // GET: all crates
    app.get('/recipe', async (req, res) => {
        const recipes = await RecipeController.findAll();
        res.json(recipes);
    });

    app.post('/recipe/addpart', async (req, res) => {
        const { recipeId, title, description, days, hours, minutes } = req.body;
        if (recipeId && title && description && days && hours && minutes) {
            const time = Util.toTime(days, hours, minutes);
            const recipe = await RecipeController.addRecipePart(recipeId, title, description, time);
            if (recipe) {
                res.json(recipe);
            } else {
                res.json({ error: 'Something went wrong' });
            }
        } else {
            res.json({ error: 'Missing one of the parameters (recipeId, title, description, days, hours, minutes)' })
        }
    });

    // GET: crate by id
    app.get('/recipe/:id', async (req, res) => {
        const id = req.params.id;
        const recipe = await RecipeController.findOneById(id);
        console.log(recipe.recipeParts[0].title);
        if (recipe !== null) {
            res.json(recipe)
        } else {
            res.json({ error: 'No user found' })
        }

    })
}