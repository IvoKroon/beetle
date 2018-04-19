const Recipe = require('../model/recipeModel');
const RecipePartController = require('../controller/recipePartController');
const Util = require('../util');

module.exports = {
    // Find all recipes
    findAll: async () => {
        let recipes;
        try {
            return await Recipe.find().populate('recipeParts').exec();
        } catch (err) {
            throw err;
        }
    },

    // Create new recipe
    create: async (title, description) => {
        try {
            const recipe = new Recipe({ title, description });
            return await recipe.save();

        } catch (err) {
            throw err;
        }
    },

    addRecipePart: async (recipeId, title, description, time) => {
        try {
            const recipePart = await RecipePartController.create(title, description, time);
            if (Util.checkObjectId(recipeId)) {
                const recipe = await Recipe.findById(recipeId);
                if (recipe !== null) {
                    recipe.recipeParts.push(recipePart);
                    return await recipe.save();
                }
            }
            return false;
        } catch (err) {
            throw err;
        }
    },

    remove: async id => {
        try {
            return await Recipe.find({ _id: id }).remove().exec();
        } catch (err) {
            throw err;
        }
    },

    findOneById: async (id) => {
        try {
            return await Recipe.findById(id).populate('recipeParts').exec();
        } catch (err) {
            throw err;
        }
    }
}