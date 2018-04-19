const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const Crate = require('./crateModel')

// create a schema
const userSchema = new Schema({
    firstName: String,
    lastName: String,
    email: String,
    crates: [{ type: Schema.Types.ObjectId, ref: 'Crate' }]
});

// the schema is useless so far
// we need to create a model using it
const User = mongoose.model('User', userSchema);

// make this available to our users in our Node applications
module.exports = User;