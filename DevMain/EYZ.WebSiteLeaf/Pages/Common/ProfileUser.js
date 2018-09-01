'use strict';

angular.module('App.ProfileUser', ['ngRoute', 'angular-loading-bar', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/ProfileUser", {
            controller: "ProfileUserCrtl",
            templateUrl: "Partial/Common/ProfileUser.html"
        });
        $routeProvider.when("/Setting", {
            controller: "ProfileUserCrtl",
            templateUrl: "Partial/Common/ProfileUser.html"
        });
        $routeProvider.when("/History", {
            controller: "ProfileUserCrtl",
            templateUrl: "Partial/Common/ProfileUser.html"
        });
    }])
App.controller('ProfileUserCrtl', ['$scope', 'serviceRest', 'breaDcrumb', 'authService', 'localStorageService', function ($scope, serviceRest, breaDcrumb, authService, localStorageService) {
    breaDcrumb.breadcrumb();
    $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
    //Manejador de errores
    $scope.error = function (data) { $scope.toastr.error(data.ExceptionMessage, 'Error'); }
    //validaciones
    $scope.isValid = true;
    $scope.selectedTab = 1;

    //Paginacion
    $scope.pagination = {
        pageIndex: 1,
        pageSize: 10
    }
    $scope.Get = function () {
        $scope.Rest.Get($scope.Settings.Uri, 'Users2/ProfilUser',
            function (response) {
                $scope.item = response.data;
            }, $scope.error);
    };

    $scope.Profiles = function () {
        $scope.Rest.Get($scope.Settings.Uri, 'Profiles2/Get?pageIndex=1&pageSize=99999999',
            function (response) {
                $scope.items = response.data.items;
            }, $scope.error);
    };

    $scope.Save = function () {
        if ($scope.myForm.$error.required) {
            $scope.isValid = false;
            $scope.toastr.error('input field Requerid', 'Error');
            return;
        }
        $scope.Rest.Post($scope.Settings.Uri, 'Users2/Post/', $scope.item,
            function (response) {
                $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Login), 'Success');
            }, $scope.error);
    };
    $scope.setTab = function (tab) {
        if (tab === 3) {
            $scope.GetTimeline();
        }
        $scope.selectedTab = tab;
    };

    $scope.ChangePassword = function () {
        if ($scope.myPasswordForm.$error.required) {
            $scope.isValid = false;
            $scope.toastr.error('input field Requerid', 'Error');
            return;
        }
        var data = {
            PasswordOld: $scope.PasswordOld,
            NewPassword: $scope.NewPassword,
            ConfirmPassword: $scope.ConfirmPassword,
            Comments: $scope.Comments,
            UserName: $scope.item.UserName
        }
        $scope.Rest.Post($scope.Settings.Uri, 'Auth2/ChangePassword', data,
            function (response) {
                $scope.toastr.success('Success Save', 'Success');
            }, $scope.error);
    };

    $scope.ClearCache = function () {
        $scope.ngNotify.set("Espere un momento puede tardar varios minutos", 'warn');
        $scope.Rest.Get($scope.Settings.Uri, 'Profiles2/ClearCache',
            function (response) {
                $scope.toastr.success('Clear Cache', 'Success');
            }, $scope.error);
    };

    $scope.ResetPassword = function () {
        $scope.Rest.Get($scope.Settings.Uri, 'Auth2/ResetPassword',
            function (response) {
                $scope.toastr.success('Reset Password', 'Success');
            }, $scope.error);
    };

    $scope.RefreshToken = function () {
        var data = {
            UserName: $scope.item.UserName
        }
        $scope.Rest.Post($scope.Settings.Uri, 'Auth2/RefreshToken', data,
            function (response) {
                $scope.item.Session = authService.authentication.Session;
                localStorageService.remove('authorizationBussinesData');
                localStorageService.set('authorizationBussinesData', { Token: response.result.access_Token, UserName: response.result.UserName, Session: response.result.Session, Profile: response.result.Profile, UpdatedId: response.result.UpdatedId });
                $scope.toastr.success('Reset Token Password', 'Success');
            }, $scope.error);
    };

    $scope.Get();
    $scope.Profiles();
}]);