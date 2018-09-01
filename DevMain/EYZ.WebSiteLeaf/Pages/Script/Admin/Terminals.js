'use strict';

angular.module('App.Admin.Terminals', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Terminals", {
            controller: "TerminalsCtrl",
            templateUrl: "Partial/Admin/Terminals.html"
        });
        $routeProvider.when("/Terminals/:Id", {
            controller: "TerminalCtrl",
            templateUrl: "Partial/Admin/Terminal.html"
        });
    }])
    .controller('TerminalsCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
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
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Terminal/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize + '&PortId=0&id=0', function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Terminal/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Terminal/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }])

    .controller('TerminalCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.Id = $routeParams.Id;
        $scope.isValid = true;
        $scope.byAssigned = [];
        $scope.byAssignedNow = [];
        $scope.byAssigned = [];
        $scope.assignedNow = [];
        $scope.rank = [];
        //Manejador de Errores
        $scope.error = function (data) { toastr.error(data.Message, 'Error'); }
        $scope.GetProducts = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/VesselProductAssigned/' + $routeParams.Id, function (response) {
                $scope.byAssigned = response.byAssigned;
                $scope.assigned = response.Assigned;
            }, $scope.error);
        };

        $scope.tab = 1;

        $scope.setTab = function (newTab) {
            $scope.tab = newTab;
        };

        $scope.isSet = function (tabNum) {
            return $scope.tab === tabNum;
        };
        //Detalle de la pagina
        $scope.Get = function () {
            if ($routeParams.Id != 0) {
                $scope.Rest.Get($scope.Settings.Uri, 'Terminal/Get/' + $routeParams.Id, function (response) {
                    $scope.item = response.data;
                }, $scope.error);
            }
        };

        $scope.City = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Cities2/Get?PageIndex=1&PageSize=99999&Id=0',
                function (response) {
                    $scope.Cityitems = response.data.items;
                }, $scope.error);
        };

        $scope.Ports = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Port/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.ports = response.data.items;
                }, $scope.error);
        };

        $scope.Conditions = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Condition/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.Conditions = response.data.items;
                }, $scope.error);
        };

        $scope.GetTerminalByProducts = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Terminal/GetTerminalByProducts/' + ($routeParams.Id),
                function (response) {
                    $scope.products = response.data;
                }, $scope.error);
        };

        $scope.GetRankRate = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Terminal/GetRankRate/' + ($routeParams.Id),
                function (response) {
                    $scope.rank = response.data;
                }, $scope.error);
        };

        $scope.SelectValueCondition = function () {
            angular.forEach($scope.Conditions, function (item, key) {
                if (item.id == $scope.item.conditionId) {
                    $scope.item.conditionValue = item.value;
                }
            });
        };

        //insertar o actualizar registro
        $scope.Save = function (Id) {
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('input field Requerid', 'Error');
                return;
            }
            $scope.item.products = $scope.products;
            $scope.item.rank = $scope.rank;
            if (Id == undefined) {
                $scope.Rest.Post($scope.Settings.Uri, 'Terminal/Post', $scope.item,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $location.path("/Terminals");
                    }, $scope.error);
            }
            if (Id != undefined) {
                $scope.Rest.Put($scope.Settings.Uri, 'Terminal/Put/' + Id, $scope.item,
                    function (response) {
                        $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.name), 'Success');
                        $location.path("/Terminals");
                    }, $scope.error);
            }
        };
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
                angular.forEach($scope.assigned, function (value, key) {
                    $scope.byAssigned.push({ id: value.id, name: value.name });
                    $scope.assigned.splice(key, 1);
                });
            } else {
                angular.forEach($scope.byAssigned, function (value, key) {
                    $scope.assigned.push({ id: value.id, name: value.name });
                    $scope.byAssigned.splice(key, 1);
                });
            }
        };
        
        var item = 1;
        $scope.Add = function () {
            item = $scope.rank.length == 0 ? item : $scope.rank.length + 1;
            $scope.rank.push({ id: item,  Minimum: $scope.Minimum, Maximum: $scope.Maximum, Rate: $scope.Rate });
            $scope.Minimum = 0.0;
            $scope.Maximum = 0.0;
            $scope.Rate = 0.0;
        };

        $scope.Delete = function (id) {
            if ($scope.rank.length === 1) {
                $scope.rank = [];
            } else {
                $scope.rank.splice(id, 1);
            }
        };

        $scope.GetProducts();
        $scope.City();
        $scope.Ports();
        $scope.Conditions();
        $scope.GetTerminalByProducts();
        $scope.Get();
        $scope.GetRankRate();
    }]);