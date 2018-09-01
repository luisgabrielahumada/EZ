'use strict';

angular.module('App.Common.Liquidation', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Liquidation/:Id", {
            controller: "LiquidationdetailCtrl",
            templateUrl: "Partial/Common/Liquidation.html"
        });

        $routeProvider.when("/Liquidation/:Id/:VesselId", {
            controller: "LiquidationdetailCtrl",
            templateUrl: "Partial/Common/Liquidation.html"
        });
    }])

    .controller('LiquidationdetailCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', '$rootScope', 'ModalService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, $rootScope, ModalService) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        $scope.isNewPriceMT = false;
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }

        $scope.columns = [];

        $scope.GetHeader = function (Id, VeselId) {
            $scope.Rest.Get($scope.Settings.Uri, 'Request/Get/' + Id + '?VesselId=' + VeselId, function (response) {
                $scope.request = response.data;
                var index = 1;
                var title = "";
                if ($scope.request.IsCurrentPort === true) {
                    title = "Ballast to Loadport <br/>" + $scope.request.CurrentPortName + " to " + $scope.request.LoadPortName;
                    $scope.columns.push({ title: title, index: index++ });
                }
                if ($scope.request.HourCanalPanama !== 0) {
                    title = "Canal Panama";
                    $scope.columns.push({ title: title, index: index++ });
                }

                title = "Ballast to Loadport <br/>" + $scope.request.LoadPortName;
                $scope.columns.push({ title: title, index: index++ });

                title = "Navigation to Disport <br/>" + $scope.request.LoadPortName + " to " + $scope.request.DischargePortName;
                $scope.columns.push({ title: title, index: index++ });
                if ($scope.request.HourCanalPanamaDischarge !== 0) {
                    title = "Canal Panama";
                    $scope.columns.push({ title: title, index: index++ });
                }
                title = "Unloading at <br/>" + $scope.request.DischargePortName;
                $scope.columns.push({ title: title, index: index++ });
            }, $scope.error);
        };

        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Inbox/ItemsLiquidationForServices/' + $routeParams.Id, function (response) {
                $scope.items = response.data;
                $scope.row = $scope.items[0];
                var VesselId = ($routeParams === undefined ? 0 : $routeParams.VesselId);
                $scope.GetHeader($scope.row.TokenParent, VesselId);
            }, $scope.error);
        };

        $scope.Back = function () {
            $location.path("/InboxVessel");
        };

        $scope.ChangeStatus = function (status) {
            var data = {};
            if (status === 'ACCEPTUNDER') {
                if ($scope.newPriceMT === undefined) {
                    $scope.toastr.error('this new value of condition not is valid', 'Error');
                    return;
                }
                if ($scope.newPriceMT <= 0) {
                    $scope.toastr.error('this new value of condition not is valid', 'Error');
                    return;
                }
                if ($scope.newPriceMT === $scope.row.PriceMT) {
                    $scope.toastr.error('Please enter a different value for Freight Indacation', 'Error');
                    return;
                }
                data = {
                    status: status,
                    priceMT: $scope.newPriceMT
                };
            }
            if (status === 'ACCEPT') {
                data = {
                    status: status,
                    priceMT: $scope.row.PriceMT
                };
            }
            $scope.GetChangeStatus(data);
        };

        $scope.ChangeNewPriceMT = function () {
            $scope.isNewPriceMT = true;
            $scope.newPriceMT = $scope.row.PriceMT;
        };
        $scope.Get();

        $scope.GetVessel = function (id) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/SingleVesseldtl.html",
                controller: "Vessel2Ctrl",
                inputs: {
                    VesselId2: id
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                });
            });
        };

        $scope.GetChangeStatus = function (data) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/ChangeStatusRequest.html",
                controller: "ChangeStatusCtrl",
                inputs: {
                    data: data,
                    id: $routeParams.Id
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                    location.reload();
                });
            });
        };

        $scope.ReCalculate = function (id) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/ReCalculate.html",
                controller: "ReCalculateCtrl",
                inputs: {
                    id: $routeParams.Id
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                    location.reload();
                });
            });
        };
    }])
    .controller('Vessel2Ctrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'VesselId2', 'ModalService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, VesselId2, ModalService) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/Get/' + VesselId2, function (response) {
                $scope.row = response.data;
                $scope.Rest.Get($scope.Settings.Uri, 'Vessel/PropertyToVessel/' + $scope.row.Token, function (response) {
                    $scope.items = response.data;
                }, $scope.error);
            }, $scope.error);
        };
        $scope.Get();
    }])
    .controller('ChangeStatusCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'data', 'id', 'ModalService', 'close', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, data, id, ModalService, close) {
        $scope.datainfo = data;
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.ApplyChangeStatus = function () {
            $scope.Rest.Post($scope.Settings.Uri, 'Inbox/ChangeStatus/' + id, data, function (response) {
                close(response, 500);

            }, $scope.error);
        };
    }])
    .controller('ReCalculateCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'id', 'ModalService', 'close', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService,  id, ModalService, close) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.isValid = true;
        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Request/VariableLiquidation/' + id, function (response) {
                $scope.row = response.data;
            }, $scope.error);
        };
        $scope.Get();
        $scope.ReCalculate = function () {
            //if ($scope.myForm.$error.required) {
            //    $scope.isValid = false;
            //    $scope.toastr.error('input field Requerid', 'Error');
            //    return;
            //}
            $scope.Rest.Post($scope.Settings.Uri, 'Request/UpdateVariableLiquidation/' + id, $scope.row, function (response) {
                close(response, 500);
            }, $scope.error);
        };
    }]);