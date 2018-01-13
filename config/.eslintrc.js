module.exports = {
    "env": {
        "browser": true,
        "es6": true,
        "node": true
    },
    "extends": "eslint:recommended",
    "parserOptions": {
        "sourceType": "module"
    },
    "rules": {
        "no-console": 0,
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ],
        "no-extra-parens": 2,
        // "require-jsdoc": 1,
        "valid-jsdoc": 1,
        "no-eval": 2,
        // "no-magic-numbers": 1,
        "no-self-compare": 2,
        // "vars-on-top": 2,
        "yoda": 2,
        "camelcase": 2,
        // "arrow-body-style": 1,
        "arrow-spacing": 2,
        "arrow-parens": 2,
        "eol-last": 2,
        // "capitalized-comments": 2,
        "brace-style": 2
    }
};

