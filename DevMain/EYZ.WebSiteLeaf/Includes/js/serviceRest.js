
'use strict';
angular.module('serviceRest', [])
.factory('serviceRest', ['$rootScope', '$http', 'ngAuthSettings', 'authService', function ($rootScope, $http, ngAuthSettings, authService) {
    return {
        Get: function (Uri,action, callback, errorCallback) {
            var _Uri = Uri + '/' + action;
            $rootScope.loading = true;
            return $http(
                {
                    method: 'GET',
                    url: _Uri
                }).
                success(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    callback(data);
                }).
                error(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    //Funcion para control de errores
                    errorCallback(data);
                });
        },
        Patch: function (Uri, action, callback, errorCallback) {
            var _Uri = Uri + '/' + action;
            $rootScope.loading = true;
            return $http(
                {
                    method: 'PATCH',
                    url: _Uri
                }).
                success(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    callback(data);
                }).
                error(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    //Funcion para control de errores
                    errorCallback(data);
                });
        },
        Post: function (Uri, action, data, callback, errorCallback) {
            var _Uri = Uri + '/' + action;
            $rootScope.loading = true;
            return $http(
                {
                    method: 'POST',
                    url: _Uri,
                    data: data
                }).
                success(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    callback(data);
                }).
                error(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    errorCallback(data);
                });
        },
        Put: function (Uri, action, data, callback, errorCallback) {
            var _Uri = Uri + '/' + action;
            $rootScope.loading = true;
            return $http(
                {
                    method: 'PUT',
                    url: _Uri,
                    data: data
                }).
                success(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    callback(data);
                }).
                error(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    errorCallback(data);
                });
        },
        Delete: function (Uri, action, data, callback, errorCallback) {
            var _Uri = Uri + '/' + action;
            $rootScope.loading = true;
            return $http(
                {
                    method: 'DELETE',
                    url: _Uri,
                    data: data
                }).
                success(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    callback(data);
                }).
                error(function (data, status, headers, config) {
                    $rootScope.loading = false;
                    errorCallback(data);
                });
        }
    };
}]);