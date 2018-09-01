'use strict';

angular.module('App.Common.RegisterContract', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/RegisterContract/:Id/:Token", {
            controller: "RegisterContractCtrl",
            templateUrl: "Partial/Common/RegisterContract.html"
        });
    }])

    .controller('RegisterContractCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', '$rootScope', 'ModalService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, $rootScope, ModalService) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        $scope.rows = [];
        $scope.history = [];
        $scope.hasNegotiation = false;
        $scope.tab = 1;
        $scope.setTab = function (newTab) {
            $scope.tab = newTab;
        };

        $scope.isSet = function (tabNum) {
            return $scope.tab === tabNum;
        };
        $scope.GetHeader = function (Id, VeselId) {
            $scope.Rest.Get($scope.Settings.Uri, 'Request/Get/' + Id + '?VesselId=' + VeselId, function (response) {
                $scope.request = response.data;
            }, $scope.error);
        };
        $scope.GetClauses = function () {
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Clauses/Get?pageIndex=1&pageSize=99999&isActive=1&ContractToken=' + $routeParams.Id, function (response) {
                $scope.rows = [];
                angular.forEach(response.data.items, function (item, key) {
                    $scope.rows.push({ id: item.id, observation: item.name, status: true, edit: true, isModify: !item.isModify });
                });
            }, $scope.error).$promise;
        };

        $scope.Contracts = function () {
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Contract/Get?pageIndex=1&pageSize=99999&isActive=1', function (response) {
                $scope.contracts = response.data.items;
            }, $scope.error).$promise;
        };

        $scope.GetNegotiation = function () {
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Negotiation/Get/' + $routeParams.Id, function (response) {
                if (response.negotiation.clauses !== undefined) {
                    $scope.negotiation = response.negotiation;
                    $scope.rows = [];
                    angular.forEach(response.negotiation.clauses, function (item, key) {
                        console.log(item.id);
                        console.log(item.observation);
                        console.log(item.oldobservation);
                        $scope.rows.push({ id: item.id, observation: item.observation, oldobservation: item.oldobservation, status: item.status, edit: true, isModify: item.isModify });
                    });
                    if ($scope.rows.length > 0) {
                        $scope.hasNegotiation = true;
                    }
                }
            }, $scope.error).$promise;
        };


        $scope.GetHistoryNegotiation = function () {
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Negotiation/History/' + $routeParams.Id, function (response) {
                if (response.negotiation.history !== undefined) {
                    $scope.history = [];
                    angular.forEach(response.negotiation.history, function (item, key) {
                        $scope.history.push({ observation: item.observation, oldobservation: item.oldobservation});
                    });
                }
            }, $scope.error).$promise;
        };

        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Inbox/ItemsLiquidationForServices/' + $routeParams.Id, function (response) {
                $scope.items = response.data;
                $scope.row = $scope.items[0];
                $('.modal-backdrop').remove();
                $scope.Rest.Get($scope.Settings.Uri, 'Vessel/GetToken/' + $routeParams.Token, function (response) {
                    $scope.vessel = response.data;
                    $scope.GetHeader($scope.row.TokenParent, response.data.Id);
                }, $scope.error);
            }, $scope.error);
        };
        var item = 1;
        $scope.AddContitions = function () {
            item = $scope.rows.length === 0 ? item : $scope.rows.length + 1;
            $scope.rows.push({ id: item, observation: $scope.observation, status: true, edit: true, isModify: false });
            $scope.observation = "";
        };

        $scope.Delete = function (id) {
            if ($scope.rows.length === 1) {
                $scope.rows = [];
            } else {
                $scope.rows.splice(id, 1);
            }
        };
        $scope.Contracts();
        $scope.Get();
        $scope.GetNegotiation();
        $scope.GetHistoryNegotiation();


        $scope.Continue = function () {
            var data = {
                ServiceLiquidationToken: $routeParams.Id,
                Status: "INPROCESS",
                Clauses: $scope.rows,
                Id: 0
            };

            $scope.Rest.Post($scope.Settings.Uri, 'Negotiation/Continue', data, function (response) {
                $scope.toastr.info('Negotiation in process.... on this request', 'Info');
                $scope.hasNegotiation = true;
                $scope.GetNegotiation();
            }, $scope.error);
        };
    }]);