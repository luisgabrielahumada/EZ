require.config({
   // baseUrl: "libs",
    paths: {
        angular: 'libs/angular/angular',
        /*angularroute: '../angular/angular-route',
        angularstorage: '../angular-plugin/angular-local-storage',
        authComplete: '../angular-plugin/authComplete',
        loading: '../angular-plugin/loading-bar'*/
    }
});
require(['App'], function (App) {
    App.init();
});