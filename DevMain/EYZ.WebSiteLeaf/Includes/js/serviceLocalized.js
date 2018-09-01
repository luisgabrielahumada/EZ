'use strict';
angular.module('serviceLocalized', [])
.factory('serviceLocalized', ['$http', '$q', function ($http, $q) {
    var serviceLocalizedFactory = {};

    
    var _localizedString = {
        language:""
    };
    var _settingGetlanguage = function () {
        $http.get('../LocalResources/es-CO.json').then(
            function (response) {
                fillLanguage(response.data.language);
            }
        );
    };
    function fillLanguage(language) {
        _localizedString.language = language;
    }
    serviceLocalizedFactory.Getlanguage = _settingGetlanguage;
    serviceLocalizedFactory.localizedString = _localizedString.language;
    return serviceLocalizedFactory;
}]);