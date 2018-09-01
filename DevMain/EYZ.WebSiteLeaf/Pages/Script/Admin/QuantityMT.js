angular.module('App.Admin.QuantityMT', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/QuantityMT", {
            controller: "QuantitysMTCtrl",
            templateUrl: "Partial/Admin/QuantitysMT.html"
        });
        $routeProvider.when("/QuantityMT/:Id", {
            controller: "QuantityMTCtrl",
            templateUrl: "Partial/Admin/QuantityMT.html"
        });
    }])
    .controller('QuantitysMTCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
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
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Quantity/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize + '&id=0', function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Quantity/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Quantity/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }])

    .controller('QuantityMTCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.Id = $routeParams.Id;
        $scope.isValid = true;
        $scope.byAssigned = [];
        $scope.byAssignedNow = [];
        $scope.byAssigned = [];
        $scope.assignedNow = [];
        //Manejador de Errores
        $scope.error = function (data) { toastr.error(data.Message, 'Error'); }

        //Detalle de la pagina
        $scope.Get = function () {
            if ($routeParams.Id != 0) {
                $scope.Rest.Get($scope.Settings.Uri, 'Quantity/Get/' + $routeParams.Id, function (response) {
                    $scope.item = response.data;
                }, $scope.error);
            }
        };

        $scope.GetProducts = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Quantity/QuantityProductAssigned/' + $routeParams.Id, function (response) {
                $scope.byAssigned = response.byAssigned;
                $scope.assigned = response.Assigned;
            }, $scope.error);
        };

        //insertar o actualizar registro
        $scope.Save = function (Id) {
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('input field Requerid', 'Error');
                return;
            }
            if (Id == undefined) {
                $scope.item.product = $scope.assigned;
                $scope.Rest.Post($scope.Settings.Uri, 'Quantity/Post', $scope.item,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $location.path("/QuantityMT");
                    }, $scope.error);
            }
            if (Id != undefined) {
                $scope.item.product = $scope.assigned;
                $scope.Rest.Put($scope.Settings.Uri, 'Quantity/Put/' + Id, $scope.item,
                    function (response) {
                        $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Name), 'Success');
                        $location.path("/QuantityMT");
                    }, $scope.error);
            }
        };
        $scope.GetProducts();
        $scope.Get();

        $scope.SelectOne = function (k) {
            if (k === 1) {
                angular.forEach($scope.byAssigned, function (value, key) {
                    if (value.id == $scope.byAssignedNow) {
                        $scope.assigned.push({ id: value.id, name: value.name });
                        $scope.byAssigned.splice(key, 1);
                    }
                });
            } else {
                angular.forEach($scope.assigned, function (value, key) {
                    if (value.id == $scope.assignedNow) {
                        $scope.byAssigned.push({ id: value.id, name: value.name });
                        $scope.assigned.splice(key, 1);
                    }
                });
            }
        };
        $scope.SelectAll = function (k) {
            if (k === 1) {
                angular.forEach($scope.byAssigned, function (value, key) {
                    $scope.assigned.push({ id: value.id, name: value.name });
                });
                $scope.byAssigned = [];
                $scope.byAssigned = angular.copy($scope.assigned);
                $scope.assigned = [];
            } else {
                angular.forEach($scope.assigned, function (value, key) {
                    $scope.byAssigned.push({ id: value.id, name: value.name });
                });
                $scope.assigned = [];
                $scope.assigned = angular.copy($scope.byAssigned);
                $scope.byAssigned = [];
            }
        };
    }]);