'use strict';
angular.module('breaDcrumb', [])
.factory('breaDcrumb', ['$http', '$q', 'localStorageService', function ($http, $q, localStorageService) {
    var breadcrumbServiceFactory = {};
    //breadcrumb
    var _page = {
        pageCurrent: ""
    };

    var _breadcrumb = function () {
        var authData = localStorageService.get('authorizationBussinesData');
        var page = localStorageService.get('pageAction' + authData.Session);
        if (page) {
            _page.pageCurrent = page.pageaction;
        }
    };


    breadcrumbServiceFactory.breadcrumb = _breadcrumb;
    breadcrumbServiceFactory.pages = _page;
    return breadcrumbServiceFactory;
}]);