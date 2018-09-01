'use strict';
App.controller('MenuCrtl', ['$http', '$scope', 'serviceRest', 'SignalrService', 'authService', 'localStorageService', 'Setting', '$rootScope', function ($http, $scope, serviceRest, SignalrService, authService, localStorageService, Setting, $rootScope) {
    $scope.error = function (data) { $scope.toastr.error(data.ExceptionMessage, 'Error'); }
    var settingUri = {
        Uri: ""
    };
    $scope.countMessages = 0;
    $scope.countNotification = 0;
    $scope.itemMessages = [];
    $scope.itemNotification = [];
    var _data = localStorageService.get('authorizationBussinesData');
    var _toUserId = _data.UpdatedId;
    $scope.childmethod = function () {
        $rootScope.$emit("CallParentMethod", {});
    };
    SignalrService.initialize($scope, function (data) {
        switch (data.Code) {
            case "Messages":
                if (_toUserId === data.ToUserID) {
                    $scope.childmethod();
                    $scope.toastr.info(data.ExceptionMessage, 'info');
                    $scope.countMessages += 1;
                    $scope.itemMessages.reverse();
                    $scope.itemMessages.push({
                        id: data.Id,
                        code:data.Code,
                        message: data.ExceptionMessage,
                        date: data.Date,
                        status: data.Status
                    });
                    $scope.itemMessages.reverse();
                    localStorageService.set('notificationServerMessagesData' + _toUserId, JSON.stringify($scope.itemNotification));
                }
                break;
            case "Notifications":
                if (_toUserId === data.ToUserID) {
                    $scope.childmethod();
                    $scope.toastr.info(data.Message, 'info!');
                    $scope.ListNotifications();
                    $scope.countNotification += 1;
                    $scope.itemNotification.push({
                        id: data.Id,
                        key: data.Key,
                        code: data.Code,
                        message: data.ExceptionMessage,
                        date: data.Date,
                        status: data.Status,
                        result: JSON.parse(data.Data)
                    });
                    localStorageService.set('notificationServerNotificationData' + _toUserId, JSON.stringify($scope.itemNotification));
                }
                break;
            case "Other":
                $scope.childmethod();
                if (_toUserId === data.ToUserID) {
                    //$scope.toastr.info("Nueva Notificacion", 'info!');
                    $scope.ListNotifications();
                    $scope.countNotification += 1;
                    $scope.itemNotification.push({
                        id: data.Id,
                        key: data.Key,
                        code: data.Code,
                        message: data.Message,
                        date: data.Date,
                        status: data.Status,
                        result: JSON.parse(data.Data)
                    });
                    localStorageService.set('notificationServerNotificationData' + _toUserId, JSON.stringify($scope.itemNotification));
                }
                break;
        }
    }, Setting.getNotificationsHubUri());

    $scope.ListNotifications = function () {
        $scope.itemNotification = localStorageService.get('notificationServerNotificationData' + _toUserId) || [];
    };
    $scope.initNotifications = function () {
        $scope.countNotification = 0;
    };
    $scope.clearNotifications = function () {
        $scope.itemNotification = [];
        localStorageService.remove('notificationServerNotificationData' + _toUserId);
        $scope.toastr.success("Clear all notifications! Ok", 'Success!');
    };

    $scope.clearMessages = function () {
        $scope.itemMessages = [];
        $scope.countMessages = 0;
        localStorageService.remove('notificationServerMessagesData' + _toUserId);
        $scope.toastr.success("Clear all Messages! Ok", 'Success!');
    };
    $scope.Menu = function () {
        $http.get('../Settings.json').then(
            function (response) {
                var appSettings = response.data.Settings;
                if (appSettings.appSettings.active === 'LOCAL') {
                    settingUri.Uri = appSettings.appUriLocal.value;
                }
                if (appSettings.appSettings.active === 'REMOTE') {
                    settingUri.Uri = appSettings.appUriRemote.value;
                }
                $scope.Rest.Get(settingUri.Uri, 'Menus2/MenuOptionSession',
                    function (response) {
                        $scope.menus = response.data;
                    }, $scope.error);

                console.log($scope.menus);
            }
        );
        $scope.authentication = authService.authentication;
    };

    $scope.Menu();

    $scope.ListNotifications();

    $scope.logOut = function () {
        var authData = localStorageService.get('authorizationBussinesData');
        if (authData) {
            $scope.Rest.Post($scope.Settings.Uri, 'Auth2/SignOut/', authData.Session,
                function (response) {
                }, $scope.error);
        }
        authService.logOut();
        $scope.authentication = authService.authentication;
        document.location.href = "../Auth/index.html";
    }

    $scope.IsTrace = function (value) {
        if (value) {
            localStorageService.set('auditSystemBussinesData', { isTrace: value });
        }
        if (!value) {
            localStorageService.remove('auditSystemBussinesData');
        }
    };
}]);