'use strict';

angular.module('App.Vessel.Vessel', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService', 'ngMaterial'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Vessel", {
            controller: "VesselsCtrl",
            templateUrl: "Partial/Vessel/Vessel.html"
        });

        $routeProvider.when("/Vessel/:Id", {
            controller: "VesselCtrl",
            templateUrl: "Partial/Vessel/Vesseldtl.html"
        });
    }])
    .controller('VesselsCtrl', ['$scope', 'serviceRest', 'breaDcrumb', 'ModalService', '$mdDialog', function ($scope, serviceRest, breaDcrumb, ModalService, $mdDialog) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        //Manejador de Errores
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        $scope.isValid = true;
        $scope.items = [];
        //Datos para paginacion
        $scope.pagination = {
            pageIndex: 1,
            pageSize: 10
        }
        angular.element('input').on('keydown', function (ev) {
            ev.stopPropagation();
        });
        $scope.selectedPageIndex = 1;
        //listar la grilla
        $scope.List = function (pageIndex) {
            $scope.pagination.pageIndex = pageIndex;
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/Get?pageIndex=' + $scope.pagination.pageIndex + '&pageSize=' + $scope.pagination.pageSize, function (response) {
                $scope.items = response.data.items;
                $scope.pagination.totalPage = response.data.totalPages;
                $scope.pagination.totalItemCount = response.data.totalItemCount;
                $scope.pagination.pageSize = response.data.pageSize;
            }, $scope.error);
        };

        $scope.GetVessel = function (id) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/SingleVesseldtl.html",
                controller: "Vessel2Ctrl",
                inputs: {
                    VesselId2: id
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                });
            });
        };

        $scope.Remove = function (id, status) {
            $scope.Rest.Patch($scope.Settings.Uri, 'Vessel/Remove/' + id + '?value=' + status, function (response) {
                $scope.toastr.warning('Change status success', 'Warning');
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.Change = function (id) {
            angular.forEach($scope.items.filter(item => item.Token === id), function (data, key) {
                $scope.dailyHare = data.RateLoading;
            });
            var item = {
                Token: id,
                RateLoading: $scope.dailyHare
            };
            $scope.Rest.Post($scope.Settings.Uri, 'Vessel/VesselChange/' + id, item, function (response) {
                $scope.ReCalculateAllTypeRequest(id);
                $scope.List($scope.pagination.pageIndex);
            }, $scope.error);
        };

        $scope.ReCalculateAllTypeRequest = function (id) {
            ModalService.showModal({
                templateUrl: "Partial/Modal/ReCalculateAllTypeRequest.html",
                controller: "ReCalculateAllTypeRequestCtrl",
                inputs: {
                    id: id
                }
            }).then(function (modal) {
                modal.element.modal();
                modal.close.then(function (result) {
                    location.reload();
                });
            });
        };

        $scope.AddAvailable = function (ev) {
            var parentEl = angular.element(document.body);
            $mdDialog.show({
                controller: DialogController,
                templateUrl: 'Partial/Modal/AvailableVessel.html',
                parent: parentEl,
                targetEvent: ev,
                clickOutsideToClose: true,
                fullscreen: true,
                locals: {
                    Id: ev,
                    Url: $scope.Settings.Uri
                }
            }).then(function (modal) {
                $scope.toastr.info('Update Next Opening Save', 'Information');
                $scope.List($scope.pagination.pageIndex);
            });
        };

        function DialogController($scope, $mdDialog, Id, serviceRest, Url, toastr) {
            $scope.searchCurrentPort = "";
            //Manejador de Errores
            $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };

            $scope.hide = function () {
                $mdDialog.hide();
            };

            $scope.Cancel = function () {
                $mdDialog.cancel();
            };

            $scope.Close = function (answer) {
                $mdDialog.hide(answer);
            };

            $scope.isValid = true;

            angular.element(document).ready(init);
            function init() {
                $(".datepicker").datepicker(
                    {
                        dateFormat: "yy-MM-dd",
                        firstDay: 1,
                        gotoCurrent: true,
                        showButtonPanel: true,
                        changeMonth: true,
                        changeYear: true,
                        minDate: 0
                    }
                );
            }

            //Datos para paginacion
            $scope.Vessel = {
                Token: Id
            };

            $scope.GetPort = function () {
                serviceRest.Get(Url, 'Port/Get?PageIndex=1&PageSize=99999',
                    function (response) {
                        $scope.itemsPort = response.data.items;
                    }, $scope.error);
            };

            $scope.GetAvailableOpenVessels = function () {
                serviceRest.Get(Url, 'Vessel/AvailableOpenVessels/' + Id,
                    function (response) {
                        $scope.row = response.data;
                        if ($scope.row !== null && $scope.row !== undefined) {
                            $scope.CurrentTerminalId = {
                                id: $scope.row.CurrentTerminalId
                            };
                            $scope.CurrentPortId = {
                                id: $scope.row.CurrentPortId
                            };

                            $scope.NextOpeningPort = $scope.row.NextOpeningPort;
                        }
                    }, $scope.error);
            };

            $scope.GetTerminal = function () {
                if ($scope.CurrentPortId !== undefined && $scope.CurrentPortId !== null) {
                    serviceRest.Get(Url, 'Terminal/Get?PageIndex=1&PageSize=99999&PortId=' + $scope.CurrentPortId.id + '&id=0',
                        function (response) {
                            $scope.itemsTerminal = response.data.items;
                        }, $scope.error);
                }
            };

            $scope.SaveAvailable = function () {
                $("#NextOpeningPort").prop('required', true);

                if ($("#NextOpeningPort").val() === '') {
                    $scope.isValid = false;
                    $scope.toastr.error('Start Next Opening Port is Requerid', 'Error');
                    return;
                }
                if ($("#NextOpeningPort").val() !== '') {
                    $scope.NextOpeningPort = $("#NextOpeningPort").val();
                    $("#NextOpeningPort").prop('required', false);
                }
                if ($scope.myForm.$error.required) {
                    $scope.isValid = false;
                    $scope.toastr.error('Field is Requerid', 'Error');
                    return;
                }

                $scope.data = {
                    NextOpeningPort: new Date($scope.NextOpeningPort),
                    CurrentPortId: $scope.CurrentPortId.id,
                    CurrentTerminalId: $scope.CurrentTerminalId.id,
                    Token: $scope.Vessel.Token
                };
                serviceRest.Post(Url, 'Vessel/AddAvailableOpenVessels', $scope.data,
                    function (response) {
                        $scope.Close();
                    }, $scope.error);
            };

            $scope.GetPort();
            $scope.GetTerminal();
            $scope.GetAvailableOpenVessels();
        }

        $scope.List($scope.pagination.pageIndex);
    }])

    .controller('VesselCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', function ($scope, serviceRest, breaDcrumb, $routeParams, $location) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.isValid = true;
        //Manejador de Errores
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        $scope.byAssigned = [];
        $scope.byAssignedNow = [];
        $scope.byAssigned = [];
        $scope.assignedNow = [];

        $scope.GetProducts = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/VesselProductAssigned/' + $routeParams.Id, function (response) {
                $scope.byAssigned = response.byAssigned;
                $scope.assigned = response.Assigned;
            }, $scope.error);
        };

        $scope.tab = 1;

        $scope.setTab = function (newTab) {
            $scope.tab = newTab;
        };

        $scope.isSet = function (tabNum) {
            return $scope.tab === tabNum;
        };

        //Detalle de la pagina
        $scope.Get = function () {
            if ($routeParams.Id !== 0) {
                $scope.Rest.Get($scope.Settings.Uri, 'Vessel/GetToken/' + $routeParams.Id, function (response) {
                    $scope.item = response.data;
                    $scope.City();
                    $scope.Propertys();
                }, $scope.error);
            }
        };

        $scope.Type = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Type/Get?PageIndex=1&PageSize=100',
                function (response) {
                    $scope.Typeitems = response.data.items;
                }, $scope.error);
        };

        $scope.Propertys = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/PropertyToVessel/' + $routeParams.Id,
                function (response) {
                    $scope.propertys = response.data;
                }, $scope.error);
        };

        $scope.City = function () {
            if ($scope.item !== undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Cities2/Get?PageIndex=1&PageSize=99999&id=' + $scope.item.countryId,
                    function (response) {
                        $scope.Cityitems = response.data.items;
                    }, $scope.error);
            }
        };

        $scope.Country = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Countries2/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.Countryitems = response.data.items;
                }, $scope.error);
        };

        //insertar o actualizar registro
        $scope.Save = function (Id) {
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('input field Requerid', 'Error');
                return;
            }
            if (Id === undefined) {
                $scope.item.products = $scope.assigned;
                $scope.item.propertys = $scope.propertys;
                $scope.Rest.Post($scope.Settings.Uri, 'Vessel/Post', $scope.item,
                    function (response) {
                        $scope.toastr.success('Success Save', 'Success');
                        $location.path("/Vessel");
                    }, $scope.error);
            }
            if (Id !== undefined) {
                $scope.item.products = $scope.assigned;
                $scope.item.propertys = $scope.propertys;
                $scope.Rest.Put($scope.Settings.Uri, 'Vessel/Put/' + Id, $scope.item,
                    function (response) {
                        $scope.toastr.success(String.format("Record {0} Update Success", $scope.item.Menu), 'Success');
                        $location.path("/Vessel");
                    }, $scope.error);
            }
        };

        $scope.SelectOne = function (k) {
            if (k === 1) {
                angular.forEach($scope.byAssigned, function (value, key) {
                    if (value.id === $scope.byAssignedNow) {
                        $scope.assigned.push({ id: value.id, name: value.name });
                        $scope.byAssigned.splice(key, 1);
                    }
                });
            } else {
                angular.forEach($scope.assigned, function (value, key) {
                    if (value.id === $scope.assignedNow) {
                        $scope.byAssigned.push({ id: value.id, name: value.name });
                        $scope.assigned.splice(key, 1);
                    }
                });
            }
        };
        $scope.SelectAll = function (k) {
            if (k === 1) {
                angular.forEach($scope.byAssigned, function (value, key) {
                    $scope.assigned.push({ id: value.id, name: value.name });
                });
                $scope.byAssigned = [];
                $scope.byAssigned = angular.copy($scope.assigned);
                $scope.assigned = [];
            } else {
                angular.forEach($scope.assigned, function (value, key) {
                    $scope.byAssigned.push({ id: value.id, name: value.name });
                });
                $scope.assigned = [];
                $scope.assigned = angular.copy($scope.byAssigned);
                $scope.byAssigned = [];
            }
        };
        $scope.GetProducts();
        $scope.Type();
        $scope.Get();
        $scope.City();
        $scope.Propertys();
        $scope.Country();
    }])

    .controller('Vessel2Ctrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'VesselId2', 'ModalService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, VesselId2, ModalService) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/Get/' + VesselId2, function (response) {
                $scope.row = response.data;
                $scope.Rest.Get($scope.Settings.Uri, 'Vessel/PropertyToVessel/' + $scope.row.Token, function (response) {
                    $scope.items = response.data;
                }, $scope.error);
            }, $scope.error);
        };
        $scope.Get();
    }])
    .controller('ReCalculateAllTypeRequestCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'id', 'ModalService','close', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, id, ModalService, close) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };
        $scope.Update = function () {
            //TODO construir los metodos y el procedimiento que haga esta operacion
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/UpdateRequestForThisVessel/' + id, function (response) {
               close(response, 500);
            }, $scope.error);
        };
    }]);