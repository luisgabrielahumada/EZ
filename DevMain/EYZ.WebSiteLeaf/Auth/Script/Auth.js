'use strict';
var Auth = angular.module('Auth', ['ngRoute','toastr',
    'ngAnimate',
    'angular-loading-bar',
    'LocalStorageModule',
    'serviceRest',
    'authService',
    'ngNotify',
    'authInterceptorService',
    'Auth.directive-manager',
    'Auth.Login'
]);
var directives = angular.module('Auth.directive-manager', []);

Auth.run(['$rootScope', 'serviceRest', 'authService', 'ngNotify', 'toastr', function ($rootScope, serviceRest, authService, ngNotify, toastr) {
    authService.settingApiServiceBase();
    $rootScope.Rest = serviceRest;
    $rootScope.Settings = authService.ApiSettings;
    // $rootScope.notificationManager = new NotificationManager($rootScope);
    $rootScope.ngNotify = ngNotify;
    toastr.options = {
        "closeButton": true,
        "debug": false,
        "newestOnTop": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "preventDuplicates": true,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    };
    ngNotify.config({
        theme: 'pure',
        position: 'bottom',
        duration: 3000,
        type: 'info',
        sticky: true,
        button: true,
        html: false
    });

    $rootScope.toastr = toastr;
}]);

//var serviceBase = 'http://localhost/Arquitectura.Api/Api';
//var serviceBase = 'http://arquitecturaapi-website.azurewebsites.net/Api';
Auth.constant('ngAuthSettings', 'authService', function (authService) {
    // apiServiceBaseUri: authService.ApiSettings.Uri
    //clientId: 'ngAuthApp'
});