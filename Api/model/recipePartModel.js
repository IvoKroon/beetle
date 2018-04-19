const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// create a schema
const recipeStepSchema = new Schema({
    title: String,
    description: String,
    time: Number,
});

// the schema is useless so far
// we need to create a model using it
const RecipeStep = mongoose.model('RecipePart', recipeStepSchema);

// make this available to our users in our Node applications
module.exports = RecipeStep;