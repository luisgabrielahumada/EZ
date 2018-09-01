'use strict';
angular.module('authService', [])
.factory('authService', ['$http', '$q', 'localStorageService', function ($http, $q, localStorageService) {
    var authServiceFactory = {};

    //autenticacion
    var _authentication = {
        IsAuth: false,
        UserName: "",
        UseRefreshTokens: false,
        Session: "",
        Section: "",
        UpdatedId: 0
    };

    //autenticacion
    var _auditSystem = {
        IsTrace: false
    };

    //configuracion
    var _setting = {
        Uri: ""
    };


    var _SettingApiServiceBaseUri = function () {
        $http.get('../Settings.json').then(
            function (response) {
                ConfigSettings(response.data.Settings);
            }
        );
    };


    function ConfigSettings(setting) {
        if (setting.appSettings.active === 'LOCAL') {
            _setting.Uri = setting.appUriLocal.value;
        }
        if (setting.appSettings.active === 'REMOTE') {
            _setting.Uri = setting.appUriRemote.value;
        }
    }

    var _fillAuthData = function () {
        var authData = localStorageService.get('authorizationBussinesData');
        var auditSystem = localStorageService.get('auditSystemBussinesData');
        if (authData) {
            _authentication.IsAuth = true;
            _authentication.UserName = authData.UserName;
            _authentication.UseRefreshTokens = authData.UseRefreshTokens;
            _authentication.Session = authData.Session;
            _authentication.Profile = authData.Profile;
            _authentication.UpdatedId = authData.UpdatedId;
            _authentication.Section = authData.Section;
        }
        //Manejo del Trace
        if (auditSystem) {
            _auditSystem.isTrace = auditSystem.isTrace;
        }
    };


    var _logOut = function () {
        localStorageService.remove('authorizationBussinesData');
        localStorageService.remove('pageAction' + _authentication.Session);
        localStorageService.remove('auditSystemBussinesData');
        _authentication.IsAuth = false;
        _authentication.UserName = "";
        _authentication.IsTrace = "";
        _authentication.Profile = "";
        _authentication.UseRefreshTokens = false;
        _authentication.UpdatedId = 0;
        _auditSystem.IsTrace = false;
    };



    authServiceFactory.fillAuthData = _fillAuthData;
    authServiceFactory.authentication = _authentication;
    authServiceFactory.settingApiServiceBase = _SettingApiServiceBaseUri;
    authServiceFactory.ApiSettings = _setting;
    authServiceFactory.logOut = _logOut;
    authServiceFactory.auditSystem = _auditSystem;
    return authServiceFactory;
}]);