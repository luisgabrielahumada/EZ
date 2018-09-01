'use strict';

angular.module('App.Common.Countries', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Countries", {
            controller: "CountriesCrtl",
            templateUrl: "Partial/Common/Countries.html"
        });
        $routeProvider.when("/Countries/:Id", {
            controller: "CountrieCtrl",
            templateUrl: "Partial/Common/Countriesdtl.html"
        });
    }])
    .controller('CountriesCrtl', ['$scope', 'serviceRest', 'breaDcrumb', function ($scope, serviceRest, breaDcrumb) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;

        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.items = [];

        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }
        $scope.List = function (pageIndex) {
            $scope.pagination.pageIndex = pageIndex;
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Countries2/Get?PageIndex=' + $scope.pagination.pageIndex + '&PageSize=' + $scope.pagination.pageSize + '&id=0', function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
            }, $scope.error).$promise;
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Countries2/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.warning('Item Remove success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Delete = function (id) {
            $scope.Rest.Delete($scope.Settings.Uri, 'Countries2/Delete/' + id, null, function (response) {
                $scope.toastr.info('Item Delete success', 'Information!');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.List($scope.pagination.pageIndex);
    }]);

App.controller('CountrieCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService) {
    breaDcrumb.breadcrumb();
    $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
    $scope.isValid = true;
    //Manejador de Errores
    $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
    //Detalle de la pagina
    $scope.Get = function () {
        if ($routeParams.Id != 0) {
            $scope.Rest.Get($scope.Settings.Uri, 'Countries2/Get/' + $routeParams.Id, function (response) {
                $scope.item = response.data;
            }, $scope.error);
        }
    };

    //insertar o actualizar registro
    $scope.Save = function () {
        if ($scope.myForm.$error.required) {
            $scope.isValid = false;
            $scope.toastr.error('input field Requerid', 'Error');
            return;
        }
        if ($routeParams.Id == 0) {
            $scope.Rest.Post($scope.Settings.Uri, 'Countries2/Post', $scope.item,
                function (response) {
                    $scope.toastr.success('Success Save', 'Success');
                    $location.path("/Countries");
                }, $scope.error);
        }
        if ($routeParams.Id != 0) {
            $scope.Rest.Put($scope.Settings.Uri, 'Countries2/Put/' + $routeParams.Id, $scope.item,
                function (response) {
                    $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Name), 'Success');
                    $location.path("/Countries");
                }, $scope.error);
        }
    };
    $scope.Get();
}]);