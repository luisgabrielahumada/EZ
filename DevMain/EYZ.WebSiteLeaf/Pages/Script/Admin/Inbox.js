'use strict';

angular.module('App.Admin.Inbox', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Inbox", {
            controller: "InboxCtrl",
            templateUrl: "Partial/Admin/Inbox.html"
        });
    }])

    .controller('InboxCtrl', ['$scope', 'serviceRest', '$route', 'authService', 'ModalService', function ($scope, serviceRest, $route, authService, ModalService) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.isExpanded = false;
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }

        $scope.GetDetail = function (key, i, data) {
            if ($scope.index === i) {
                $scope.index = -1;
            } else {
                $scope.key = key;
                $scope.index = i;
            }
            $scope.request = data;
            $scope.Rest.Get($scope.Settings.Uri, 'Inbox/ServiceLiquidationsForRquest?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize + '&token=' + key, function (response) {
                $scope.detail = response.data.items;
            }, $scope.error);
        };

        $scope.GetLiquidation = function (k) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/Liquidation.html",
                controller: "LiquidationCtrl",
                inputs: {
                    Id: k,
                    key: $scope.key,
                    request: $scope.request
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                    $scope.List($scope.pagination.pageIndex);
                });
            });
        };
        $scope.GetProducts = function () {7
            $scope.Rest.Get($scope.Settings.Uri, 'Product/Get?PageIndex=1&PageSize=99999&isActive=1',
                function (response) {
                    $scope.itemsProduct = response.data.items;
                }, $scope.error);
            $scope.GetQuantity();
            $scope.GetStowageFactor();
        };

        $scope.GetStowageFactor = function () {
            if ($scope.productId != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'StowageFactor/Get?PageIndex=1&PageSize=99999&id=' + $scope.productId,
                    function (response) {
                        $scope.itemsStowageFactor = response.data.items;
                    }, $scope.error);
            }
        };

        $scope.GetQuantity = function () {
            if ($scope.productId != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Quantity/Get?PageIndex=1&PageSize=99999&id=' + $scope.productId,
                    function (response) {
                        $scope.itemsQuantity = response.data.items;
                    }, $scope.error);
            }
        };
        $scope.GetLoadTerminal = function () {
            if ($scope.productId != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Terminal/Get?PageIndex=1&PageSize=99999&PortId=' + $scope.loadPortId + '&id=' + $scope.productId,
                    function (response) {
                        $scope.itemsLoadTerminal = response.data.items;
                    }, $scope.error);
            }
        };

        $scope.GetDischargeTerminal = function () {
            if ($scope.productId != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Terminal/Get?PageIndex=1&PageSize=99999&PortId=' + $scope.dischargePortId + '&id=' + $scope.productId,
                    function (response) {
                        $scope.itemsDischargeTerminal = response.data.items;
                    }, $scope.error);
            }
        };

        $scope.GetCondition = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Condition/Get?PageIndex=1&PageSize=99999&',
                function (response) {
                    $scope.itemsCondition = response.data.items;
                }, $scope.error);
        };

        $scope.GetLoadPort = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Port/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.itemsPort = response.data.items;
                }, $scope.error);
            $scope.GetLoadTerminal();
        };

        $scope.GetDischargePort = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Port/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.itemsPort = response.data.items;
                }, $scope.error);
            $scope.GetDischargeTerminal();
        };

        $scope.List = function (pageIndex) {
            if (pageIndex != undefined)
                $scope.pagination.pageIndex = pageIndex;
            $scope.data = {
                productId: $scope.productId,
                stowageFactorId: $scope.stowageFactorId,
                quantityId: $scope.quantityId,
                conditionId: $scope.conditionId,
                loadPortId: $scope.loadPortId,
                loadTerminalId: $scope.loadTerminalId,
                dischargePortId: $scope.dischargePortId,
                dischargeTerminalId: $scope.dischargeTerminalId,
                startLaycan: $scope.startLaycan,
                endLaycan: $scope.endLaycan
            };
            $scope.Rest.Post($scope.Settings.Uri, 'Inbox/RequesForServices?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize, $scope.data, function (response) {
                $scope.items = response.data.items;
                // $scope.configGrid.api.setRowData($scope.items);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
        $scope.GetProducts();
        $scope.GetLoadPort();
        $scope.GetDischargePort();
        $scope.GetCondition();
    }])

    .controller('LiquidationCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'Id', 'key', 'request', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, Id, key, request) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.isNewPriceMT = false;
        $scope.request = request;
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }
        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Inbox/ItemsLiquidationForServices/' + Id, function (response) {
                $scope.items = response.data;
            }, $scope.error);
        };

        $scope.ChangeStatus = function (status) {
            var data = {
                status: status,
                priceMT: $scope.newPriceMT
            }
            $scope.Rest.Post($scope.Settings.Uri, 'Inbox/ChangeStatus/' + key, data, function (response) {
                $scope.toastr.info('Change Status success', 'Information!');
            }, $scope.error);
        };

        $scope.ChangeNewPriceMT = function () {
            $scope.isNewPriceMT = true;
        };
        $scope.Get();
    }]);