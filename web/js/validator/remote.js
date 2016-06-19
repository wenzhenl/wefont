(function($) {
    $.fn.bootstrapValidator.i18n.remote = $.extend($.fn.bootstrapValidator.i18n.remote || {}, {
        'default': 'Please enter a valid value'
    });

    $.fn.bootstrapValidator.validators.remote = {
        html5Attributes: {
            message: 'message',
            url: 'url',
            name: 'name'
        },

        /**
         * Request a remote server to check the input value
         *
         * @param {BootstrapValidator} validator Plugin instance
         * @param {jQuery} $field Field element
         * @param {Object} options Can consist of the following keys:
         * - url {String|Function}
         * - type {String} [optional] Can be GET or POST (default)
         * - data {Object|Function} [optional]: By default, it will take the value
         *  {
         *      <fieldName>: <fieldValue>
         *  }
         * - name {String} [optional]: Override the field name for the request.
         * - message: The invalid message
         * @returns {Boolean|Deferred}
         */
        validate: function(validator, $field, options) {
            var value = $field.val();
            if (value === '') {
                return true;
            }

            var name = $field.attr('data-bv-field'),
                data = options.data || {},
                url  = options.url,
                type = options.type || 'POST';

            // Support dynamic data
            if ('function' === typeof data) {
                data = data.call(this, validator);
            }

            // Support dynamic url
            if ('function' === typeof url) {
                url = url.call(this, validator);
            }

            data[options.name || name] = value;

            var dfd = new $.Deferred();
            var xhr = $.ajax({
                type: type,
                url: url,
                dataType: 'json',
                data: data
            });
            xhr.then(function(response) {
                dfd.resolve($field, 'remote', response.valid === true || response.valid === 'true', response.message ? response.message : null);
            });

            dfd.fail(function() {
                xhr.abort();
            });

            return dfd;
        }
    };
}(window.jQuery));
