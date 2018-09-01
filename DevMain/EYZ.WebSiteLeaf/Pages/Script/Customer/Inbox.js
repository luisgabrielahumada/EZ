'use strict';

angular.module('App.Customer.InboxCustomer', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/InboxCustomer", {
            controller: "InboxCustomerCtrl",
            templateUrl: "Partial/Customer/Inbox.html"
        });
    }])

    .controller('InboxCustomerCtrl', ['$scope', 'serviceRest', '$route', 'authService', 'ModalService', '$rootScope', function ($scope, serviceRest, $route, authService, ModalService, $rootScope) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.isExpanded = false;
        $scope.status = 'REQUEST';

        $rootScope.$on("CallParentMethod", function () {
            $scope.List($scope.pagination.pageIndex);
        });
       
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10,
            totalPages: 1
        };

        $scope.GetStatus = function (t) {
            $scope.status = t;
            $scope.List($scope.pagination.pageIndex);
        };

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
        $scope.List = function (pageIndex) {
            if (pageIndex !== undefined)
                $scope.pagination.pageIndex = pageIndex;
            $scope.data = {
                productId: $scope.productId === undefined ? 0 : $scope.productId,
                stowageFactorId: $scope.stowageFactorId === undefined ? 0 : $scope.stowageFactorId,
                quantityId: $scope.quantityId === undefined ? 0 : $scope.quantityId,
                conditionId: $scope.conditionId === undefined ? 0 : $scope.conditionId,
                loadPortId: $scope.loadPortId === undefined ? 0 : $scope.loadPortId,
                loadTerminalId: $scope.loadTerminalId === undefined ? 0 : $scope.loadTerminalId,
                dischargePortId: $scope.dischargePortId === undefined ? 0 : $scope.dischargePortId,
                dischargeTerminalId: $scope.dischargeTerminalId === undefined ? 0 : $scope.dischargeTerminalId,
                startLaycan: $scope.startLaycan === undefined ? null : $scope.startLaycan,
                endLaycan: $scope.endLaycan === undefined ? null : $scope.endLaycan,
                status: $scope.status
            };
            $scope.Rest.Post($scope.Settings.Uri, 'Inbox/InboxCustomer?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize, $scope.data, function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPages = response.data.totalPages;
            }, $scope.error);
        };

        $scope.GetServiceLiquidation = function (data) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/ServicesLiquidationdtl.html",
                controller: "ServicesLiquidationCtrl",
                inputs: {
                    Id: data
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                    $scope.List($scope.pagination.pageIndex);
                });
            });
        };

        $scope.List($scope.pagination.pageIndex);
    }])
    .controller('ServicesLiquidationCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'Id', 'ModalService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, Id, ModalService) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        };
        $scope.Id = 0;
        $scope.List = function (pageIndex) {
            $scope.pagination.pageIndex = pageIndex;
            $scope.Rest.Get($scope.Settings.Uri, 'Inbox/ServiceLiquidationsForRquest?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize + '&token=' + Id, function (response) {
                $scope.items = response.data.items;
                $scope.Id = $scope.items[0].Id;
            }, $scope.error);
        };

        $scope.GoDetailVessel = function (data) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/PropertyVessel.html",
                controller: "PropertyVesselCtrl",
                inputs: {
                    Id: data
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                });
            });
        };

        $scope.GoConfirmation = function (data, id) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/ConfirmationProcess.html",
                controller: "ConfirmationProcessCtrl",
                inputs: {
                    data: data,
                    Id: id
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                });
            });
        };

        $scope.List($scope.pagination.pageIndex);
    }])
    .controller('PropertyVesselCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'Id', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, Id) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        //Datos para paginacion
        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Inbox/GetVessel/' + Id, function (response) {
                $scope.row = response.data.items;
            }, $scope.error);
        };

        $scope.Get();
    }])
    .controller('ConfirmationProcessCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'data', 'Id', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, data, Id) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.data = data;
        $scope.Id = Id;

        $scope.goConfirmation = function () {
            $location.path("/RegisterContract/" + $scope.data.Token + "/" + $scope.data.VesselToken);
        };
    }]);