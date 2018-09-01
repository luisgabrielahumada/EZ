'use strict';

angular.module('App.Common.Home', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Home", {
            controller: "HomeCtrl",
            templateUrl: "Partial/Common/Home.html"
        });
    }])

    .controller('HomeCtrl', ['$scope', 'serviceRest', '$route', 'authService', function ($scope, serviceRest, $route, authService) {
        $scope.error = function (data) { $scope.ngNotify.set(data.Message, 'error'); }
        $scope.items = [{
            label: "",
            value: 0
        }];
    }]);