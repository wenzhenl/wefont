(function($) {
    $.fn.bootstrapValidator.i18n.phone = $.extend($.fn.bootstrapValidator.i18n.phone || {}, {
        'default': 'Please enter a valid phone number',
        countryNotSupported: 'The country code %s is not supported',
        country: 'Please enter a valid phone number in %s',
        countries: {
            GB: 'United Kingdom',
            US: 'USA'
        }
    });

    $.fn.bootstrapValidator.validators.phone = {
        html5Attributes: {
            message: 'message',
            country: 'country'
        },

        // The supported countries
        COUNTRY_CODES: ['GB', 'US'],

        /**
         * Return true if the input value contains a valid phone number for the country
         * selected in the options
         *
         * @param {BootstrapValidator} validator Validate plugin instance
         * @param {jQuery} $field Field element
         * @param {Object} options Consist of key:
         * - message: The invalid message
         * - country: The ISO-3166 country code. It can be
         *      - A country code
         *      - Name of field which its value defines the country code
         *      - Name of callback function that returns the country code
         *      - A callback function that returns the country code
         *
         * Currently it only supports United State (US) or United Kingdom (GB) countries
         * @returns {Boolean|Object}
         */
        validate: function(validator, $field, options) {
            var value = $field.val();
            if (value === '') {
                return true;
            }

            var country = options.country;
            if (typeof country !== 'string' || $.inArray(country, this.COUNTRY_CODES) === -1) {
                // Try to determine the country
                country = validator.getDynamicOption($field, country);
            }

            if (!country || $.inArray(country.toUpperCase(), this.COUNTRY_CODES) === -1) {
                return {
                    valid: false,
                    message: $.fn.bootstrapValidator.helpers.format($.fn.bootstrapValidator.i18n.phone.countryNotSupported, country)
                };
            }

            var isValid = true;
            switch (country.toUpperCase()) {
            	case 'GB':
            		// http://aa-asterisk.org.uk/index.php/Regular_Expressions_for_Validating_and_Formatting_GB_Telephone_Numbers#Match_GB_telephone_number_in_any_format
            		// Test: http://regexr.com/38uhv
            		value   = $.trim(value);
            		isValid = (/^\(?(?:(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?\(?(?:0\)?[\s-]?\(?)?|0)(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}|\d{3}\)?[\s-]?\d{3}[\s-]?\d{3,4}|\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3})|\d{5}\)?[\s-]?\d{4,5}|8(?:00[\s-]?11[\s-]?11|45[\s-]?46[\s-]?4\d))(?:(?:[\s-]?(?:x|ext\.?\s?|\#)\d+)?)$/).test(value);
                    break;

                case 'US':
                /* falls through */
                default:
                    // Make sure US phone numbers have 10 digits
                    // May start with 1, +1, or 1-; should discard
                    // Area code may be delimited with (), & sections may be delimited with . or -
                    // Test: http://regexr.com/38mqi
                    value   = value.replace(/\D/g, '');
                    isValid = (/^(?:(1\-?)|(\+1 ?))?\(?(\d{3})[\)\-\.]?(\d{3})[\-\.]?(\d{4})$/).test(value) && (value.length === 10);
                    break;
            }

            return {
                valid: isValid,
                message: $.fn.bootstrapValidator.helpers.format(options.message || $.fn.bootstrapValidator.i18n.phone.country, $.fn.bootstrapValidator.i18n.phone.countries[country])
            };
        }
    };
}(window.jQuery));
