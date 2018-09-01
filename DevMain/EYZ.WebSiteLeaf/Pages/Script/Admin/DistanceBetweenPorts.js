'use strict';

angular.module('App.Admin.DistanceBetweenPorts', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/DistanceBetweenPorts", {
            controller: "DistanceBetweenPortsCtrl",
            templateUrl: "Partial/Admin/DistanceBetweenPorts.html"
        });
    }])
    .controller('DistanceBetweenPortsCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        //Manejador de Errores
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.items = [];
        //listar la grilla
        $scope.List = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Port/GetDistanceBetweenPorts', function (response) {
                $scope.items = response.data;
            }, $scope.error);
        };

        $scope.Save = function () {
            $scope.Rest.Post($scope.Settings.Uri, 'Port/DistanceBetweenPorts/', $scope.items, function (response) {
                $scope.toastr.success('Update Distance Between Ports', 'Success');
            }, $scope.error);
        };

        $scope.List();
    }]);