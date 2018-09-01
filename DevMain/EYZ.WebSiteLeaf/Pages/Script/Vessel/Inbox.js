'use strict';

angular.module('App.Vessel.InboxVessel', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/InboxVessel", {
            controller: "InboxVesselCtrl",
            templateUrl: "Partial/Vessel/Inbox.html"
        });
    }])

    .controller('InboxVesselCtrl', ['$scope', 'serviceRest', '$route', 'authService', 'ModalService', '$rootScope', function ($scope, serviceRest, $route, authService, ModalService, $rootScope) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        $scope.isExpanded = false;
        $scope.status = 'REQUEST';
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10,
            totalPages: 1
        };
        $rootScope.$on("CallParentMethod", function () {
            $scope.List($scope.pagination.pageIndex);
        });
        $scope.Last = function (t) {
            var page = t - 1;
            if (page > 0)
                $scope.List(page);
        };

        $scope.Next = function (t) {
            $scope.pagination.pageIndex = t;
            if ($scope.pagination.pageIndex < $scope.pagination.totalPages)
                $scope.pagination.pageIndex = t + 1;
            $scope.List($scope.pagination.pageIndex);
        };
        $scope.GetStatus = function (t) {
            $scope.status = t;
            $scope.List($scope.pagination.pageIndex);
        };
        $scope.List = function (pageIndex) {
            if (pageIndex != undefined)
                $scope.pagination.pageIndex = pageIndex;
            $scope.data = {
                productId: $scope.productId == undefined ? 0 : $scope.productId,
                stowageFactorId: $scope.stowageFactorId == undefined ? 0 : $scope.stowageFactorId,
                quantityId: $scope.quantityId == undefined ? 0 : $scope.quantityId,
                conditionId: $scope.conditionId == undefined ? 0 : $scope.conditionId,
                loadPortId: $scope.loadPortId == undefined ? 0 : $scope.loadPortId,
                loadTerminalId: $scope.loadTerminalId == undefined ? 0 : $scope.loadTerminalId,
                dischargePortId: $scope.dischargePortId == undefined ? 0 : $scope.dischargePortId,
                dischargeTerminalId: $scope.dischargeTerminalId == undefined ? 0 : $scope.dischargeTerminalId,
                startLaycan: $scope.startLaycan == undefined ? null : $scope.startLaycan,
                endLaycan: $scope.endLaycan == undefined ? null : $scope.endLaycan,
                status: $scope.status
            };
            $scope.Rest.Post($scope.Settings.Uri, 'Inbox/InboxVessel?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize, $scope.data, function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPages = response.data.totalPages;
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }])