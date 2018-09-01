'use strict';

angular.module('App.Admin.Menus', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Menus", {
            controller: "MenusCtrl",
            templateUrl: "Partial/Admin/Menus.html"
        });

        $routeProvider.when("/Menus/:Id", {
            controller: "MenuCtrl",
            templateUrl: "Partial/Admin/Menudtl.html"
        });
    }])
    .controller('MenusCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb) {
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
        $scope.selectedPageIndex = 1;
        //listar la grilla
        $scope.List = function (pageIndex) {
            $scope.pagination.pageIndex = pageIndex;
            $scope.Rest.Get($scope.Settings.Uri, 'Menus2/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize, function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
                $scope.pagination.pageSize = response.data.pageSize;
            }, $scope.error);
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Menus2/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Menus2/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }]);

App.controller('MenuCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
    breaDcrumb.breadcrumb();
    $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
    $scope.isValid = true;
    //Manejador de Errores
    $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }

    //Detalle de la pagina
    $scope.Get = function () {
        if ($routeParams.Id != 0) {
            $scope.Rest.Get($scope.Settings.Uri, 'Menus2/Get/' + $routeParams.Id, function (response) {
                $scope.item = response.data
            }, $scope.error);
        }
    };

    //insertar o actualizar registro
    $scope.Save = function (Id) {
        if ($scope.myForm.$error.required) {
            $scope.isValid = false;
            $scope.toastr.error('Field is Requerid', 'Error');
            return;
        }
        if (Id == undefined) {
            $scope.Rest.Post($scope.Settings.Uri, 'Menus2/Post', $scope.item,
                function (response) {
                    $scope.toastr.success('Success Save', 'Success');
                    $location.path("/Menus");
                }, $scope.error);
        }
        if (Id != undefined) {
            $scope.Rest.Post($scope.Settings.Uri, 'Menus2/Put/' + Id, $scope.item,
                function (response) {
                    $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Menu), 'Success');
                    $location.path("/Menus");
                }, $scope.error);
        }
    };

    $scope.MenusParent = function () {
        $scope.Rest.Get($scope.Settings.Uri, 'Menus2/Get?pageIndex=1&pageSize=100',
            function (response) {
                $scope.itemsParent = response.data.items;
            }, $scope.error);
    };
    $scope.MenusParent();
    $scope.Get();
}]);