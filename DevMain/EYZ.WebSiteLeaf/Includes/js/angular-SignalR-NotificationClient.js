'use strict';
angular.module("App.NotificationClient", [])
.service("SignalrService", function () {
    var proxy = null;

    this.initialize = function (scope, callback, Url) {
        var connection = $.connection(Url);
        connection.logging = true;
        connection.qs = "company=MG&user=Admin";

        connection.received(function (data) {
            if (data != null) {
                scope.$apply();
                callback(JSON.parse(data));
            }
        });

        connection.start({ jsonp: true }).done(function () {
            console.log('Conectado a Notificaciones....');
            scope.$apply();
        });
    };
})