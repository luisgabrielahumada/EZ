'use strict';

angular.module('App.Admin.Users', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Users", {
            controller: "UsersCtrl",
            templateUrl: "Partial/Admin/Users.html"
        });
        $routeProvider.when("/Users/:Id", {
            controller: "UserCtrl",
            templateUrl: "Partial/Admin/Userdtl.html"
        });
    }])
    .controller('UsersCtrl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb, $log) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        //Manejador de Errores
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.items = [];
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }
        //listar la grilla
        $scope.List = function (pageIndex) {
            $scope.pagination.pageIndex = pageIndex;
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Users2/Get?PageIndex=' + $scope.pagination.pageIndex + '&PageSize=' + $scope.pagination.pageSize, function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Users2/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.success('Item Remove success', 'Success');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Users2/Delete/' + id, null, function (response) {
                $scope.toastr.warning('Item Delete success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }]);

App.controller('UserCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService) {
    breaDcrumb.breadcrumb();
    $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
    $scope.isValid = true;
    $scope.Id = $routeParams.Id;
    //Manejador de Errores
    $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }

    //Detalle de la pagina
    $scope.Get = function () {
        if ($routeParams.Id != 0) {
            $scope.Rest.Get($scope.Settings.Uri, 'Users2/Get/' + $routeParams.Id, function (response) {
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
            $scope.Rest.Post($scope.Settings.Uri, 'Users2/Post', $scope.item,
                function (response) {
                    $scope.toastr.success('Success Save', 'Success');
                    $location.path("/Users");
                }, $scope.error);
        }
        if (Id != undefined) {
            $scope.Rest.Post($scope.Settings.Uri, 'Users2/Put/' + Id, $scope.item,
                function (response) {
                    $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.UserName), 'Success');
                    $location.path("/Users");
                }, $scope.error);
        }
    };

    $scope.Profiles = function () {
        $scope.Rest.Get($scope.Settings.Uri, 'Profiles2/Get?PageIndex=1&PageSize=100',
            function (response) {
                $scope.items = response.data.items;
            }, $scope.error);
    };

    $scope.Get();
    $scope.Profiles();
}]);