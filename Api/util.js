module.exports = {
    checkObjectId: (id) => {
        return id.match(/^[0-9a-fA-F]{24}$/);
    },

    toTime: (days = 0, hours = 0, minutes = 0) => {
        return parseInt(days) * 86400 + parseInt(hours) * 3600 + parseInt(minutes) * 60;
    },
}