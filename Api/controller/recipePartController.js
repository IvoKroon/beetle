const RecipePart = require('../model/recipePartModel');

module.exports = {
    // Find all recipes
    findAll: async () => {
        let recipePart;
        try {
            return await RecipePart.find();
        } catch (err) {
            throw err;
        }
    },

    // Create new recipe
    create: async (title, description, time) => {
        try {
            const recipePart = new RecipePart({ title, description, time });
            return await recipePart.save();

        } catch (err) {
            throw err;
        }
    },

    remove: async id => {
        try {
            return await RecipePart.find({ _id: id }).remove().exec();
        } catch (err) {
            throw err;
        }
    },
    findOneById: async (id) => {
        try {
            return await RecipePart.findOne({ _id: id });
        } catch (err) {
            throw err;
        }
    }
}