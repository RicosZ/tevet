const ErrorResponse = require("./errorResponse");

const validation = {
    email: {
        match: /^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]+)$/,
    },
    phone: {
        match: /^[0-9]*$/,
        min: 10,
        max: 10,
    },
    password: {
        match: /(?:\d+[a-zA-Z]|[a-zA-Z]+\d)[a-zA-Z\d]*/,
        min: 8,
        max: 16,
    },
    fullName: {
        match: /^[^-\s][a-zA-Zก-๙\s]*[^\s]$/,
        min: 1,
        max: 30,
    },
    tagName: {
        match: /^[^-\s][a-zA-Zก-๙\s\d]*[^\s]$/,
        min: 1,
        max: 15,
    },
    commentDetail: {
        match: /^.*[\S].*$/,
        min: 1,
        max: 500,
    },
    topicSubject: {
        match: /^.*[\S].*$/,
        min: 1,
        max: 500,
    },
    topicDetail: {
        match: /^.*[\S].*$/,
        min: 1,
        max: 1000,
    },
    check: (type, data) => {
        //filter type
        if (!(type in validation)) return true;

        type = validation[type];
        const match = Object.values(type)[0].test(data); //test is function for validate data
        const min = Object.values(type)[1];
        const max = Object.values(type)[2];
        return match
            ? min !== undefined
                ? data.length >= min
                    ? max !== undefined
                        ? data.length <= max
                        : true
                    : false
                : true
            : false;
    },
    checkFull: (obj) => {
        // parameter ex { email, phone, password, fullName }
        
        // Check missing data
        Object.keys(obj).forEach((key) => {
            if (!obj[key]) {
                throw new ErrorResponse(`Please complete the form ${key}`, 400);
            }
        });

        // Check validate
        Object.keys(obj).forEach((key) => {
            if (!validation.check(key, obj[key]))
                throw new ErrorResponse(`Please provide a valid ${key}`, 400);
        });
    },
    checkDocDuplicate: async (obj) => {
        // parameter ex. [{User, email}, {Profile, phone}]

        for (const e of obj) {
            const isValid = await Object.values(e)[0].findOne({
                [Object.keys(e)[1]]: Object.values(e)[1],
            });
            if (isValid)
                throw new ErrorResponse(
                    `Duplicate ${Object.keys(e)[1]} Entered`,
                    409
                );
        }
    },
};

module.exports = validation;
