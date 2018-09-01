'use strict';
angular.module('Auth.Login', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'serviceRest'])
Auth.config(function ($routeProvider) {
    $routeProvider.when("/Login", {
        controller: "LoginCtrl",
        templateUrl: "Partial/Login.html"
    });

    $routeProvider.otherwise({ redirectTo: "/Login" });
})
    .controller('LoginCtrl', ['$scope', 'serviceRest', 'localStorageService', 'authService', function ($scope, serviceRest, localStorageService, authService) {
        $scope.error = function (data) {
            $scope.toastr.error(data.Message, 'Error');
        }
        $scope.isValid = true;
        $scope.login = function () {
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error("Los campos en rojos son requeridos", 'error');
                return;
            }
            var _data = {
                "Login": $scope.loginData.Login,
                "Password": $scope.loginData.password
            }
            $scope.Rest.Post($scope.Settings.Uri, 'Auth2/Login', _data,
                function (response) {
                    // TODO:falta validar si no viene algun error para que lo procese.
                    localStorageService.set('authorizationBussinesData', { Token: response.data.access_Token, UserName: response.data.Login, Session: response.data.Session, Profile: response.data.Profile, UpdatedId: response.data.UpdatedId, Section: response.data.Section });
                    document.location.href = "../Pages/index.html";
                }, $scope.error);
        };
    }]);