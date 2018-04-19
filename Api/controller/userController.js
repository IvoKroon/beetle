const User = require('../model/userModel');

module.exports = {
    // Find all recipes
    findAll: async () => {
        let users;
        try {
            return await User.find();
        } catch (err) {
            throw err;
        }
    },

    // Create new recipe
    create: async (firstName, lastName, email) => {
        try {
            const user = new User({ firstName, lastName, email });
            return await user.save();
        } catch (err) {
            throw err;
        }
    },

    remove: async id => {
        try {
            return await User.find({ _id: id }).remove().exec();
        } catch (err) {
            throw err;
        }
    },

    addCrate: async (user, crate) => {
        try {
            user.crates.push(crate);
            return await user.save();
        } catch (err) {
            throw err;
        }
    },

    findOneByUserIdAndTitle: async (userId, title) => {
        try {
            return await User
                .findOne({ '_id': userId })
                .populate({
                    path: 'crates',
                    match: { title: { $in: title } }
                }).exec();
        } catch (err) {
            throw err;
        }
    },

    findOneByUserIdAndNumber: async (userId, number) => {
        try {
            console.log('NUMBER', number)
            return await User
                .findOne({ '_id': userId })
                .slice('crates', [parseInt(number), 1])
                .populate('crates')
                .exec();
        } catch (err) {
            throw err;
        }
    },

    findOneById: async id => {
        try {
            if (id.match(/^[0-9a-fA-F]{24}$/)) {
                return await User.findById(id).populate('crates').exec();
            } else {
                return null;
            }

        } catch (err) {
            throw err;
        }
    }
}