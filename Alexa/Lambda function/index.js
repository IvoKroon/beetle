'use strict';
const Alexa = require('alexa-sdk');
const HttpHandler = require('./httpHandler');

const APP_ID = '';

const USER_ID = '';

const SKILL_NAME = 'Beetle';
const HELP_MESSAGE = 'You can ask stuff about your crates.';
const HELP_REPROMPT = 'What can I help you with?';
const STOP_MESSAGE = 'Goodbye!';

exports.handler = function (event, context, callback) {
    var alexa = Alexa.handler(event, context);
    alexa.appId = APP_ID;
    alexa.registerHandlers(handlers);
    alexa.execute();
};

const handlers = {
    'LaunchRequest': function () {
        this.emit('GetStatusFromAllIntent');
    },
    'GetStatusIntent': function () {
        const respond = 'The temperature is 20 celsius';
        this.response.cardRenderer(SKILL_NAME, respond);
        this.response.speak(respond);
        this.emit(':responseReady');
    },
    'GetStatusFromAllIntent': function () {
        // const slotData = this.event.request.intent.slots.CrateName.value;
        let respond = 'Something went wrong';
        const url = `http://145.24.222.175/user/${USER_ID}/`;
        const crates = HttpHandler.get(url, (data, err) => {
            if (!err) {
                respond = '';
                for (const crate in data.crates) {
                    const { title, humidity, temperature } = data.crates[crate]
                    respond += `<s>In <emphasis level="moderate">${title}</emphasis> is the humidity <emphasis level="moderate">${humidity} %</emphasis>   and the temperature <emphasis level="moderate">${temperature} celsius</emphasis> </s>`;
                }
            }

            this.response.cardRenderer(SKILL_NAME, respond);
            this.response.speak(respond);
            this.emit(':responseReady');
        });
    },
    'GetStatusFromIntent': function () {
        // let respond = 'Something went wrong could not find ' + slot;
        const slot = this.event.request.intent.slots.CrateName.value;
        let respond = 'Something went wrong could not find ' + slot;
        const url = `http://145.24.222.175/user/${USER_ID}/${slot}`;
        const crates = HttpHandler.get(url, (data, err) => {
            if (!err) {
                if (!data.error) {
                    respond = '';
                    const { title, humidity, temperature } = data;
                    respond = `<s>In <emphasis level="moderate">${title}</emphasis> is the humidity <emphasis level="moderate">${humidity} %</emphasis>   and the temperature <emphasis level="moderate">${temperature} celsius</emphasis> </s>`;
                }
            }
            // const respond = 'The temperature is 20 celsius'
            this.response.cardRenderer(SKILL_NAME, respond);
            this.response.speak(respond);
            this.emit(':responseReady');
        });
    },

    'GetStatusFromByNumberIntent': function () {
        let respond = 'Something went wrong';
        const slot = this.event.request.intent.slots.CrateName.value;
        const number = getNumber(slot);
        const url = `http://145.24.222.175/user/${USER_ID}/number/${number}`;
        const crates = HttpHandler.get(url, (data, err) => {
            if (!err) {
                const { title, humidity, temperature } = data.crates[0];
                respond = `<s>In <emphasis level="moderate">${title}</emphasis> is the humidity <emphasis level="moderate">${humidity} %</emphasis>   and the temperature <emphasis level="moderate">${temperature} celsius</emphasis> </s>`;
            }
            // const respond = 'The temperature is 20 celsius'
            this.response.cardRenderer(SKILL_NAME, respond);
            this.response.speak(respond);
            this.emit(':responseReady');
        });
    },

    'AMAZON.HelpIntent': function () {
        const speechOutput = HELP_MESSAGE;
        const reprompt = HELP_REPROMPT;

        this.response.speak(speechOutput).listen(reprompt);
        this.emit(':responseReady');
    },
    'AMAZON.CancelIntent': function () {
        this.response.speak(STOP_MESSAGE);
        this.emit(':responseReady');
    },
    'AMAZON.StopIntent': function () {
        this.response.speak(STOP_MESSAGE);
        this.emit(':responseReady');
    },
};

function getNumber(numberString) {
    switch (numberString) {
        case 'one':
            return 1;
        case 'two':
            return 2;
        case 'three':
            return 3;
        case 'four':
            return 4;
        case 'five':
            return 5;
        case 'six':
            return 6;
        case 'seven':
            return 7;
        case 'eight':
            return 8;
        case 'nine':
            return 9;
        default:
            return false;
    }
}
