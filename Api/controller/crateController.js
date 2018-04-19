const Util = require('../util');
const Crate = require('../model/crateModel');

module.exports = {
    // Find all crates
    findAll: async () => {
        let crates;
        try {
            return await Crate.find();
        } catch (err) {
            throw err;
        }
    },

    // Create new Crate
    create: async title => {
        try {
            const crate = new Crate({ title, temperature: 99, humidity: 90 });
            return await crate.save();

        } catch (err) {
            throw err;
        }
    },

    update: async (crateId, temperature, humidity) => {
        try {
            const crate = await Crate.findById(crateId);
            if (crate) {
                crate.temperature = temperature;
                crate.humidity = humidity;
                return await crate.save()
            }
            return false;


        } catch (err) {
            throw err;
        }
    },

    addRecipe: async (crate, recipe) => {
        try {
            crate.recipe = recipe;
            return await crate.save();
        } catch (err) {
            throw err;
        }
    },

    // Find one create by id
    findOneById: async id => {
        try {
            if (Util.checkObjectId(id)) {
                return await Crate.findById(id);
            } else {
                return false;
            }
        } catch (err) {
            throw err;
        }
    },

    remove: async id => {
        try {
            return await Crate.find({ _id: id }).remove().exec();
        } catch (err) {
            throw err;
        }
    }
}