'use strict';
angular.module('App.SettingServices', [])
    .service('Setting', function () {
        return {
            getNotificationsHubUri: function () {
                // return "https://apieyz.azurewebsites.net//notificationhub";
                return "http://localhost/EYZ.WebAPI/notificationhub";
            }
        };
    });