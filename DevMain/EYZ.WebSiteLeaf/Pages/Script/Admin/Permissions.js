'use strict';

angular.module('App.Admin.Permissions', ['ngRoute', 'angular-loading-bar', 'authService', 'breaDcrumb', 'serviceRest'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Permissions", {
            controller: "PermissionsCtrl",
            templateUrl: "Partial/Admin/Permissions.html"
        });
        $routeProvider.when("/Permissions/:key/:Id", {
            controller: "PermissionsCtrl",
            templateUrl: "Partial/Admin/Permissions.html"
        });

        $routeProvider.when("/Permissions/:key/:Id/:Id2", {
            controller: "PermissionsCtrl",
            templateUrl: "Partial/Admin/Permissions.html"
        });
    }])
    .controller('PermissionsCtrl', ['$scope', 'serviceRest', 'breaDcrumb', 'authService', '$routeParams', function ($scope, serviceRest, breaDcrumb, authService, $routeParams) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.viewprofile = false;
        $scope.viewusers = false;
        //Manejador de Errores
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'error'); }
        $scope.Id = 0;
        $scope.key = 0;
        $scope.parents = [];
        //listar la grilla
        $scope.List = function () {
            $scope.promise = $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/AssignCheckPermissions',
                function (response) {
                    $scope.parents = response.data;
                    $scope.parentItems = response.orfans;
                }, $scope.error).$promise;
        };
        //Detalle de la pagina
        $scope.Get = function () {
            $scope.Id = $routeParams.Id;
            $scope.GetProfileAssign();
            if ($scope.Id != undefined) {
                $scope.viewprofile = true;
                $scope.viewusers = false;
                $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/CheckProfilePermissions/' + $routeParams.key + '?value=' + $routeParams.Id,
                    function (response) {
                        $scope.items = response.data;
                        $scope.item = response.item;
                        $scope.parentId = $scope.item.ParentId;
                    }, $scope.error);
            }
        };
        //Listado de Usuarios Por Perfil
        $scope.GetUsers = function () {
            $scope.GetUsersAssign();
            $scope.key = $routeParams.key;
            if ($routeParams.Id2 != undefined) {
                $scope.viewprofile = false;
                $scope.viewusers = true;
                $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/CheckUsersPermissions/' + $routeParams.key + '?value=' + $routeParams.Id + '&Id2=' + $routeParams.Id2,
                    function (response) {
                        $scope.Usersitems = response.data;
                        $scope.item = response.item;
                    }, $scope.error);
            }
        };
        //Guardar los permisos del perfil
        $scope.Save = function (id) {
            $.each($scope.items, function (index, item) {
                item.ParentId = id;
                $scope.Rest.Post($scope.Settings.Uri, 'Permissions2/CheckPermissionsApply', item,
                    function () {
                        $scope.toastr.success('Success Save', 'Success');
                        $scope.Get();
                    }, $scope.error
                );
            });
        };
        //Guardar los permisos del Usuario
        $scope.SaveUsers = function () {
            $.each($scope.Usersitems, function (index, item) {
                $scope.Rest.Post($scope.Settings.Uri, 'Permissions2/CheckPermissionsApplyUsers', item,
                    function () {
                        $scope.toastr.success('Success Save', 'Success');
                        $scope.GetUsers();
                    }, $scope.error
                );
            });
        };
        //Cargar los perfiles que se pueden asignar
        $scope.GetProfileAssign = function () {
            if ($scope.Id != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Common2/Get?type=PROFILE_ACCESS&id=0',
                    function (response) {
                        $scope.assignsProfile = response.data;
                    }, $scope.error);
            }
        };
        //Cargar los usuarios que se pueden asignar
        $scope.GetUsersAssign = function () {
            if ($routeParams.Id2 != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Common2/Get?type=USERS_ACCESS&parameter=' + $routeParams.Id2 + '&id=' + $routeParams.Id,
                    function (response) {
                        $scope.assignsUsers = response.data;
                    }, $scope.error);
            }
        };
        //Asignacion de perfil
        $scope.AssingnProfile = function () {
            $scope.Id = $routeParams.Id;
            if ($scope.Id != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/CheckPermissionsApplyProfile/' + $routeParams.key + '?value=' + $routeParams.Id + '&id2=' + $scope.ProfileId,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $scope.Get();
                    }, $scope.error);
            }
        };
        //Asignacion de usuario
        $scope.AssingnUsers = function () {
            $scope.Id = $routeParams.Id;
            if ($routeParams.Id2 != undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/CheckPermissionsApplyUser/' + $routeParams.key + '?value=' + $routeParams.Id + '&id2=2' + $routeParams.Id2 + '&userId=' + $scope.UserId,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $scope.GetUsers();
                    }, $scope.error);
            }
        };
        //Listado de Usuarios Por Perfil
        $scope.RemoveUser = function (id) {
            $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/RemoveUsersPermissions/' + id,
                function (response) {
                    $scope.toastr.warning('Item Remove success', 'Warning');
                    $scope.GetUsers();
                }, $scope.error);
        };
        //Listado de Usuarios Por Perfil
        $scope.RemoveProfile = function (id) {
            $scope.Rest.Get($scope.Settings.Uri, 'Permissions2/RemoveProfilesPermissions/' + id,
                function (response) {
                    $scope.ngNotify.set("Usuario eliminado con exito", 'warn');
                    $scope.Get();
                }, $scope.error);
        };
        //ejecuacion de los metodos.
        $scope.Get();
        $scope.GetUsers();
        $scope.List();
    }]);