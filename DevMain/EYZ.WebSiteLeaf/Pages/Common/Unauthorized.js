'use strict';

angular.module('App.Unauthorized', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Unauthorized", {
            controller: "UnauthorizedCtrl",
            templateUrl: "Partial/Common/Unauthorized.html"
        });
    }])
    .controller('UnauthorizedCtrl', ['$scope', 'authService', 'localStorageService', function ($scope, authService, localStorageService) {
        //manejo de validaciones
        $scope.isValid = true;
        //manejo de errores.
        $scope.error = function (data) { $scope.toastr.error(data.ExceptionMessage, 'Error'); }
        $scope.RefreshToken = function () {
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('input field Requerid', 'Error');
                return;
            }
            var data = {
                Login: $scope.Login
            }
            $scope.Rest.Post($scope.Settings.Uri, 'Auth2/RefreshToken', data,
                function (response) {
                    localStorageService.remove('authorizationBussinesData');
                    localStorageService.set('authorizationBussinesData', { Token: response.result.access_Token, UserName: response.result.UserName, Session: response.result.Session, Profile: response.result.Profile, userLogonID: response.result.UpdatedId });
                    $scope.toastr.success('Reset Token', 'Success');
                }, $scope.error);
        };
    }]);