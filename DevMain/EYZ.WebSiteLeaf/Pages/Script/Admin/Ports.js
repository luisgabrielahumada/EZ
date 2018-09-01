'use strict';

angular.module('App.Admin.Ports', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Ports", {
            controller: "PortsCtrl",
            templateUrl: "Partial/Admin/Ports.html"
        });
        $routeProvider.when("/Ports/:Id", {
            controller: "PortCtrl",
            templateUrl: "Partial/Admin/Port.html"
        });
    }])
    .controller('PortsCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        //Manejador de Errores
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.items = [];
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }
        //listar la grilla
        $scope.List = function (pageIndex) {
            $scope.pagination.pageIndex = pageIndex;
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Port/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize, function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Port/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Port/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }])

    .controller('PortCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.Id = $routeParams.Id;
        $scope.isValid = true;
        //Manejador de Errores
        $scope.error = function (data) { toastr.error(data.Message, 'Error'); }

        //Detalle de la pagina
        $scope.Get = function () {
            if ($routeParams.Id != 0) {
                $scope.Rest.Get($scope.Settings.Uri, 'Port/Get/' + $routeParams.Id, function (response) {
                    $scope.item = response.data;
                    $scope.City();
                }, $scope.error);
            }
        };

        $scope.Country = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Countries2/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.Countryitems = response.data.items;
                }, $scope.error);
        };

        $scope.City = function () {
            if ($scope.item != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Cities2/Get?PageIndex=1&PageSize=99999&id=' + $scope.item.countryId,
                    function (response) {
                        $scope.Cityitems = response.data.items;
                    }, $scope.error);
            }
        };

        //insertar o actualizar registro
        $scope.Save = function (Id) {
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('input field Requerid', 'Error');
                return;
            }
            if (Id == undefined) {
                $scope.Rest.Post($scope.Settings.Uri, 'Port/Post', $scope.item,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $location.path("/Ports");
                    }, $scope.error);
            }
            if (Id != undefined) {
                $scope.Rest.Put($scope.Settings.Uri, 'Port/Put/' + Id, $scope.item,
                    function (response) {
                        $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Name), 'Success');
                        $location.path("/Ports");
                    }, $scope.error);
            }
        };
        $scope.Get();
        $scope.Country();
        $scope.City();
    }]);