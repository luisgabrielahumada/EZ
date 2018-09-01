'use strict';

angular.module('App.Admin.Clauses', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Clauses", {
            controller: "ClausesCtrl",
            templateUrl: "Partial/Admin/Clauses.html"
        });
        $routeProvider.when("/Clauses/:Id", {
            controller: "ClauseCtrl",
            templateUrl: "Partial/Admin/Clause.html"
        });
    }])
    .controller('ClausesCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
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
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Clauses/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize+'&isActive=-1', function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Clauses/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Clauses/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }])

    .controller('ClauseCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.Id = $routeParams.Id;
        $scope.isValid = true;
        //Manejador de Errores
        $scope.error = function (data) { toastr.error(data.Message, 'Error'); }

        //Detalle de la pagina
        $scope.Get = function () {
            if ($routeParams.Id != 0) {
                $scope.Rest.Get($scope.Settings.Uri, 'Clauses/Get/' + $routeParams.Id, function (response) {
                    $scope.item = response.data;
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
                $scope.Rest.Post($scope.Settings.Uri, 'Clauses/Post', $scope.item,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $location.path("/Clauses");
                    }, $scope.error);
            }
            if (Id != undefined) {
                $scope.Rest.Put($scope.Settings.Uri, 'Clauses/Put/' + Id, $scope.item,
                    function (response) {
                        $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Name), 'Success');
                        $location.path("/Clauses");
                    }, $scope.error);
            }
        };
        $scope.Get();
    }]);