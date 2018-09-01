var directives = angular.module('App.directive-manager', []);
var App = angular.module('App', ['ngRoute', 'ngSanitize', 'ui.select', 'ngMaterial', 'toastr', 'ngMask', 'ui.utils.masks','diff',
    'angularModalService',
    'angular-loading-bar',
    'confirm-click',
    'ngNotify',
    'cgNotify',
    'angular-growl',
    'LocalStorageModule',
    'serviceRest',
    'authService',
    'authInterceptorService',
    'serviceLocalized',
    'App.NotificationClient',
    'App.Unauthorized',
    'App.SettingServices',
    'App.directive-manager',
    'App.ProfileUser',
    'App.Admin.Menus',
    'App.Admin.Profiles',
    'App.Admin.Users',
    'App.Admin.Customers',
    'App.Admin.MessagesLog',
    'App.Admin.Parameters',
    'App.Admin.Permissions',
    'App.Admin.Inbox',
    'App.Admin.Conditions',
    'App.Admin.Products',
    'App.Admin.QuantityMT',
    'App.Admin.StowageFactor',
    'App.Admin.Ports',
    'App.Admin.Terminals',
    'App.Admin.DistanceBetweenPorts',
    'App.Admin.PropertyVessel',
    'App.Admin.Clauses',
    'App.Admin.Contracts',
    'App.Common.Home',
    'App.Common.Cities',
    'App.Common.Countries',
    'App.Common.Liquidation',
    'App.Common.RegisterContract',
    'App.Customer.InboxCustomer',
    'App.Customer.Step',
    'App.Vessel.InboxVessel',
    'App.Vessel.Vessel'
]);

App.config(function ($httpProvider, $routeProvider, cfpLoadingBarProvider, $locationProvider) {
    $httpProvider.interceptors.push('authInterceptorService');
    //$routeProvider.otherwise({ redirectTo: '/Home' });

    /* hljsServiceProvider.setOptions({
         // replace tab with 2 spaces
         tabReplace: '  '
     });*/
    //cfpLoadingBarProvider.includeBar = false;
    //cfpLoadingBarProvider.parentSelector = '#loading-bar-container';
    $routeProvider.otherwise({ redirectTo: "/Home" });
    $locationProvider.html5Mode(false);
})
    .run(['authService', '$rootScope', 'serviceRest', 'serviceLocalized', 'ngNotify', 'growl', 'notify', '$http', function (authService, $rootScope, serviceRest, serviceLocalized, ngNotify, growl, notify, $http) {
        authService.fillAuthData();
        authService.settingApiServiceBase();
        $rootScope.Rest = serviceRest;
        $rootScope.Settings = authService.ApiSettings;
        // $rootScope.notificationManager = new NotificationManager($rootScope);

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
            duration: 10000,
            type: 'info',
            sticky: true,
            button: true,
            html: false
        });
        notify.config({
            position: 'right',
            duration: 10000,
            maximumOpen: 1
        });
        $rootScope.ngNotify = ngNotify;
        $rootScope.notify = notify;
        $rootScope.notifygrowl = growl;
        $rootScope.toastr = toastr;
        // Initialize($rootScope, $http);
    }]);
function Initialize($rootScope, $http) {
    $http.get('../app-config.json').success(function (data) {
        $rootScope.powerbi = data
    }).error(function (err) {
        console.log("Ocurring an error loading configuration: " + data);
    })
}
//var serviceBase = 'http://localhost/Arquitectura.Api/Api';
//var serviceBase = 'http://arquitecturaapi-website.azurewebsites.net/Api';
App.constant('ngAuthSettings', 'authService', function (authService) {
    //apiServiceBaseUri: authService.ApiSettings.Uri
    //clientId: 'ngAuthApp'
});