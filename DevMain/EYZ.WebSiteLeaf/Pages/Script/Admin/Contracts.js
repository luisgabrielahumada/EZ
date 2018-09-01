'use strict';

angular.module('App.Admin.Contracts', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Contract", {
            controller: "ContractsCtrl",
            templateUrl: "Partial/Admin/Contracts.html"
        });
        $routeProvider.when("/Contract/:Id", {
            controller: "ContractCtrl",
            templateUrl: "Partial/Admin/Contract.html"
        });
    }])
    .controller('ContractsCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
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
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Contract/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize + '&isActive=-1', function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Contract/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Contract/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }])

    .controller('ContractCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.Id = $routeParams.Id;
        $scope.isValid = true;
        angular.element(document).ready(init);
        //Manejador de Errores
        $scope.error = function (data) { toastr.error(data.Message, 'Error'); }
        function init() {
            $(".datepicker").datepicker(
                {
                    dateFormat: "yy-MM-dd",
                    gotoCurrent: true,
                    changeMonth: true,
                    changeYear: true
                });
        }

        $scope.Clauses = function () {
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Clauses/Get?pageIndex=1&pageSize=99999&isActive=1&ContractToken=' + $routeParams.Id, function (response) {
                $scope.clauses = response.data.items;
            }, $scope.error).$promise;
        };
        //Detalle de la pagina
        $scope.Get = function () {
            if ($routeParams.Id != 0) {
                $scope.Rest.Get($scope.Settings.Uri, 'Contract/Get/' + $routeParams.Id, function (response) {
                    $scope.item = response.data;
                }, $scope.error);
            }
        };

        $scope.toggleSelection = function toggleSelection(item) {
            var idx = $scope.clauses.indexOf(item);
            // Is currently selected
            if (idx > -1) {
                $scope.clauses.splice(idx, 1);
                item.isSelected = !item.isSelected;
            }
            $scope.clauses.push(item);
        };
        //insertar o actualizar registro
        $scope.Save = function (Id) {
            $("#availableFrom").prop('required', true);
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('input field Requerid', 'Error');
                return;
            }
            if ($("#startLaycan").val() === '') {
                $scope.isValid = false;
                $scope.toastr.error('Start Laycan is Requerid', 'Error');
                return;
            }
            if ($("#availableFrom").val() === '') {
                $scope.isValid = false;
                $scope.toastr.error('End Available From is Requerid', 'Error');
                return;
            }

            $scope.item.availableFrom = $("#availableFrom").val();
            $("#availableFrom").prop('required', false);
            $scope.item.contractClauses = $scope.clauses;
            if (Id == undefined) {
                $scope.Rest.Post($scope.Settings.Uri, 'Contract/Post', $scope.item,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $location.path("/Contract");
                    }, $scope.error);
            }
            if (Id != undefined) {
                $scope.Rest.Put($scope.Settings.Uri, 'Contract/Put/' + Id, $scope.item,
                    function (response) {
                        $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Name), 'Success');
                        $location.path("/Contract");
                    }, $scope.error);
            }
        };
        $scope.Clauses();
        $scope.Get();
    }]);