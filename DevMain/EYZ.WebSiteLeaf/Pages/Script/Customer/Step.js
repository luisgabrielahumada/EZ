angular.module('App.Customer.Step', ['ngRoute', 'angular-loading-bar', 'ngAnimate', 'authService', 'breaDcrumb', 'serviceRest', 'angularModalService'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when("/Step", {
            controller: "StepCtrl",
            templateUrl: "Partial/Customer/Step.html"
        });
        $routeProvider.when("/StepBack/:Id/:return", {
            controller: "StepCtrl",
            templateUrl: "Partial/Customer/Step.html"
        });
        $routeProvider.when("/Step/:Id", {
            controller: "Step1Ctrl",
            templateUrl: "Partial/Customer/Step1.html"
        });
        $routeProvider.when("/Finish", {
            controller: "FinishCtrl",
            templateUrl: "Partial/Customer/Finish.html"
        });
    }])

    .controller('StepCtrl', ['$scope', 'serviceRest', 'breaDcrumb', 'serviceLocalized', 'authService', '$location', '$routeParams', function ($scope, serviceRest, breaDcrumb, serviceLocalized, authService, $location, $routeParams, ModalService, $element) {
        $scope.searchProduct = "";
        $scope.searchPortLoad = "";
        $scope.searchPortDischarge = "";
        breaDcrumb.breadcrumb();
        $scope.conditionId = 1;
        $scope.toleranceId = {
            id: 1
        };
        //$scope.terms = {
        //    Value: 0
        //};
        $scope.measuer = "";
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.isValid = true;
        $scope.itemsStowageFactor = [];
        $scope.itemsQuantity = [];
        $scope.itemloadTerminal = [];
        $scope.itemsDischargeTerminal = [];
        $scope.itemsTolerance = [];
        $scope.itemsTerms = [];
        angular.element(document).ready(init);
        $scope.Id = $routeParams === undefined ? 0 : $routeParams.Id;
        $scope.error = function (data) {
            $scope.toastr.error(data.Message, 'Error');
        }
        angular.element('input').on('keydown', function (ev) {
            ev.stopPropagation();
        });

        function init() {
            $(".datepicker").datepicker(
                {
                    dateFormat: "yy-MM-dd",
                    gotoCurrent: true,
                    changeMonth: true,
                    changeYear: true
                }
            );
        }

        $scope.GetDefaultStartDate = function (date) {
            $scope.startLaycan = date.format("yyyy-mmmm-dd");
        };

        $scope.GetDefaultEndDate = function (date, day) {
            if (day > 0)
                date.setDate(date.getDate() + parseInt(day));
            $scope.endLaycan = date.format("yyyy-mmmm-dd");
        };

        $scope.GetValidateTermianl = function () {
            if ($scope.loadTerminalId === undefined || $scope.dischargeTerminalId === undefined) return;
            if ($scope.loadTerminalId.id === $scope.dischargeTerminalId.id) {
                $scope.toastr.error("Terminal Loading is equal Terminal Discharge", 'Error');
                return
            }
        }

        $scope.GetDefaultStartDate(new Date());

        $scope.GetDefaultEndDate(new Date(), 5);

        $scope.GetSelectedStowageFactors = function () {
            $scope.isStowageFactor = false;
            if ($scope.stowageFactorId.id === "9999999")
                $scope.isStowageFactor = true;
        };

        $scope.GetSelectedQuantity = function () {
            $scope.isQuantity = false;
            if ($scope.quantityId.id === "9999999")
                $scope.isQuantity = true;
        };

        $scope.GetLoadingRate = function () {
            if ($scope.productId !== undefined && $scope.productId !== 0) {
                $scope.GetValidateTermianl();
                $scope.loadingRate = $scope.loadTerminalId.loadingRate;
                $scope.ConditionsLoading = ($scope.row == undefined ? $scope.loadTerminalId.conditionName : $scope.row.LoadingConditionName);
                $scope.LoadingConditionId = ($scope.row == undefined ? $scope.loadTerminalId.conditionId : $scope.row.LoadingConditionId);
            }
        };

        $scope.GetUnLoadingRate = function () {
            if ($scope.productId !== undefined && $scope.productId !== 0) {
                $scope.GetValidateTermianl();
                $scope.unLoadingRate = $scope.dischargeTerminalId.loadingRate;

                $scope.ConditionsUnLoading = ($scope.row == undefined ? $scope.dischargeTerminalId.conditionName : $scope.row.UnLoadingConditionName);
                $scope.unLoadingConditionId = ($scope.row == undefined ? $scope.dischargeTerminalId.conditionId : $scope.row.UnLoadingConditionId);
            }
        };

        $scope.GetProducts = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Product/Get?PageIndex=1&PageSize=99999&isActive=1',
                function (response) {
                    $scope.itemsProduct = response.data.items;
                }, $scope.error);
        };

        $scope.GetSelectedProducts = function () {
            $scope.GetQuantity();
            $scope.GetStowageFactor();
            $scope.GetLoadPort();
            $scope.GetDischargeTerminal();
        };

        $scope.GetStowageFactor = function () {
            if ($scope.productId !== undefined && $scope.productId !== 0) {
                $scope.itemsStowageFactor = [];
                var IsNA = false;
                $scope.Rest.Get($scope.Settings.Uri, 'StowageFactor/Get?PageIndex=1&PageSize=99999&id=' + $scope.productId.id,
                    function (response) {
                        angular.forEach(response.data.items, function (value, key) {
                            if (value.name === "N/A") {
                                IsNA = true;
                            }
                            $scope.itemsStowageFactor.push({ id: value.id, name: value.name + ' ' + value.measure });
                        });
                        if ($scope.itemsStowageFactor.length > 0 && !IsNA)
                            $scope.itemsStowageFactor.push({ id: '9999999', name: 'Different Factor' });
                        if ($scope.itemsStowageFactor.length === 0)
                            $scope.isStowageFactor = false;
                    }, $scope.error);

                var item = $scope.itemsProduct.filter(i => i.id === parseInt($scope.productId.id))[0];
                $scope.measure = item.measure;
            }
        };

        $scope.GetQuantity = function () {
            if ($scope.productId !== undefined && $scope.productId !== 0) {
                $scope.itemsQuantity = [];
                $scope.Rest.Get($scope.Settings.Uri, 'Quantity/Get?PageIndex=1&PageSize=99999&id=' + $scope.productId.id,
                    function (response) {
                        angular.forEach(response.data.items, function (value, key) {
                            $scope.itemsQuantity.push({ id: value.id, name: value.name + ' ' + value.measure });
                        });
                        if ($scope.itemsQuantity.length > 0)
                            $scope.itemsQuantity.push({ id: '9999999', name: 'Different Quantity' });
                        if ($scope.itemsQuantity.length === 0)
                            $scope.isQuantity = false;
                    }, $scope.error);

                var item = $scope.itemsProduct.filter(i => i.id === parseInt($scope.productId.id))[0];
                $scope.measureQuantity = item.measureQuantity;
            }
        };

        $scope.GetLoadTerminal = function () {
            if ($scope.productId !== undefined && $scope.productId !== 0 && $scope.loadPortId !== undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Terminal/Get?PageIndex=1&PageSize=99999&PortId=' + $scope.loadPortId.id + '&id=' + $scope.productId.id,
                    function (response) {
                        $scope.itemsLoadTerminal = response.data.items;
                        if ($scope.itemsLoadTerminal.length === 0)
                            $scope.toastr.error("This product is not supported by the terminal", 'Error');
                    }, $scope.error);
            }
        };

        $scope.GetDischargeTerminal = function () {
            if ($scope.productId !== undefined && $scope.productId !== 0 && $scope.loadPortId !== undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Terminal/Get?PageIndex=1&PageSize=99999&PortId=' + $scope.dischargePortId.id + '&id=' + $scope.productId.id,
                    function (response) {
                        $scope.itemsDischargeTerminal = response.data.items;
                        if ($scope.itemsDischargeTerminal.length === 0)
                            $scope.toastr.error("This product is not supported by the terminal", 'Error');
                    }, $scope.error);
            }
        };

        $scope.GetTerms = function () {
            $scope.itemsTerms = [];
            $scope.Rest.Get($scope.Settings.Uri, 'Common2/GetTerms',
                function (response) {
                    angular.forEach(response.data, function (value, key) {
                        $scope.itemsTerms.push({ Value: value.Value, Key: value.Key });
                    });
                }, $scope.error);
        };

        $scope.GetLoadingCondition = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Condition/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.loadingCondition = response.data.items;
                    $scope.ConditionsLoading = $scope.loadingCondition[0].name;
                    $scope.LoadingConditionId = $scope.loadingCondition[0].id;
                }, $scope.error);
        };

        $scope.GetUnLoadingCondition = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Condition/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    $scope.unLoadingCondition = response.data.items;
                    $scope.ConditionsUnLoading = $scope.unLoadingCondition[0].name;
                    $scope.unLoadingConditionId = $scope.unLoadingCondition[0].id;
                }, $scope.error);
        };

        $scope.GetLoadPort = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Port/Get?PageIndex=1&PageSize=99999&isActive=-1',
                function (response) {
                    $scope.itemsPort = response.data.items;
                }, $scope.error);
            $scope.itemloadTerminal = [];
            $scope.GetLoadTerminal();
            $scope.loadingRate = "";
        };

        $scope.GetDischargePort = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Port/Get?PageIndex=1&PageSize=99999&isActive=-1',
                function (response) {
                    $scope.itemsPort = response.data.items;
                }, $scope.error);
            $scope.itemsDischargeTerminal = [];
            $scope.GetDischargeTerminal();
            $scope.unLoadingRate = "";
        };

        $scope.GetTolerance = function () {
            $scope.itemsTolerance = [];
            $scope.Rest.Get($scope.Settings.Uri, 'Tolerance/Get?PageIndex=1&PageSize=99999',
                function (response) {
                    angular.forEach(response.data.items, function (value, key) {
                        $scope.itemsTolerance.push({ id: value.id, name: value.name });
                    });
                }, $scope.error);
        };

        $scope.ConditionsLoading = "Conditions";
        $scope.GetSelectedLoadingCondition = function (data) {
            $scope.ConditionsLoading = data.name;
            $scope.LoadingConditionId = data.id;
        };

        $scope.ConditionsUnLoading = "Conditions";
        $scope.GetSelectedUnLoadingCondition = function (data) {
            $scope.ConditionsUnLoading = data.name;
            $scope.unLoadingConditionId = data.id;
        };

        $scope.Get = function () {
            if ($scope.Id !== 0 && $scope.Id !== undefined) {
                $scope.Rest.Get($scope.Settings.Uri, 'Request/Get/' + $scope.Id, function (response) {
                    $scope.row = response.data;
                    $scope.productId = {
                        id: $scope.row.ProductId
                    };
                    $scope.stowageFactorId = {
                        id: $scope.row.StowageFactorId
                    };
                    $scope.quantityId = {
                        id: $scope.row.QuantityId
                    };
                    $scope.toleranceId = {
                        id: $scope.row.ToleranceId
                    };
                    //$scope.terms = {
                    //    Value: $scope.row.Terms
                    //};
                    $scope.loadPortId = {
                        id: $scope.row.LoadPortId
                    };
                    $scope.loadTerminalId = {
                        id: $scope.row.LoadTerminalId,
                        loadingRate: $scope.row.UnLoadingRate
                    };
                    $scope.dischargePortId = {
                        id: $scope.row.DischargePortId
                    };
                    $scope.dischargeTerminalId = {
                        id: $scope.row.DischargeTerminalId,
                        unLoadingRate: $scope.row.UnLoadingRate
                    };
                    $scope.stowageFactor = $scope.row.StowageFactor;
                    $scope.quantity = $scope.row.Quantity;
                    $scope.conditionId = $scope.row.ConditionId;
                    $scope.unLoadingRate = $scope.row.UnLoadingRate;
                    $scope.loadingRate = $scope.row.LoadingRate;
                    $scope.startLaycan = $scope.row.StartLaycan;
                    $scope.endLaycan = $scope.row.EndLaycan;
                    $scope.GetDefaultStartDate(new Date($scope.startLaycan));
                    $scope.GetDefaultEndDate(new Date($scope.endLaycan), 0);
                    $scope.isStowageFactor = $scope.stowageFactorId.id === '9999999'
                    $scope.isQuantity = $scope.quantityId.id === '9999999'
                    $scope.GetTolerance();
                }, $scope.error);
            }
        };

        $scope.GetProducts();
        $scope.GetLoadPort();
        $scope.GetDischargePort();
        $scope.GetTerms();
        $scope.GetTolerance();
        $scope.GetLoadingCondition();
        $scope.GetUnLoadingCondition();
        $scope.Get();

        $scope.Request = function () {
            $("#startLaycan").prop('required', true);
            $("#endLaycan").prop('required', true);
            if ($("#startLaycan").val() === '') {
                $scope.isValid = false;
                $scope.toastr.error('Start Laycan is Requerid', 'Error');
                return;
            }
            if ($("#endLaycan").val() === '') {
                $scope.isValid = false;
                $scope.toastr.error('End Laycan is Requerid', 'Error');
                return;
            }
            if ($("#startLaycan").val() !== '' && $("#endLaycan").val() !== '') {
                $scope.startLaycan = $("#startLaycan").val();
                $scope.endLaycan = $("#endLaycan").val();
                $("#startLaycan").prop('required', false);
                $("#endLaycan").prop('required', false);
            }
            if ($scope.myForm.$error.required) {
                $scope.isValid = false;
                $scope.toastr.error('Field with red is required', 'Error');
                return;
            }
            if (($scope.stowageFactor === 0 || $scope.stowageFactor === undefined) && $scope.stowageFactorId.id === '9999999') {
                $scope.isValid = false;
                $scope.toastr.error('Stowage Factor is required', 'Error');
                return;
            }
            if (($scope.quantity === 0 || $scope.quantity === undefined) && $scope.quantityId.id === '9999999') {
                $scope.isValid = false;
                $scope.toastr.error('Quantity is required', 'Error');
                return;
            }
            if ($scope.loadingRate === 0) {
                $scope.isValid = false;
                $scope.toastr.error('Loading Rate is required', 'Error');
                return;
            }

            if ($scope.unLoadingRate === 0) {
                $scope.isValid = false;
                $scope.toastr.error('Unloading Rate is required', 'Error');
                return;
            }

            $scope.data = {
                token: $scope.Id === 0 || $scope.Id === undefined ? null : $scope.Id,
                productId: $scope.productId.id,
                stowageFactorId: $scope.stowageFactorId.id,
                stowageFactor: $scope.stowageFactor,
                quantityId: $scope.quantityId.id,
                quantity: $scope.quantity,
                toleranceId: $scope.toleranceId.id,
                terms: $scope.terms.Value,
                loadingConditionId: $scope.LoadingConditionId,
                unLoadingConditionId: $scope.unLoadingConditionId,
                loadPortId: $scope.loadPortId.id,
                loadTerminalId: $scope.loadTerminalId.id,
                loadingRate: $scope.loadingRate,
                dischargePortId: $scope.dischargePortId.id,
                dischargeTerminalId: $scope.dischargeTerminalId.id,
                unLoadingRate: $scope.unLoadingRate,
                startLaycan: $scope.startLaycan,
                endLaycan: $scope.endLaycan
            };
            $scope.Rest.Post($scope.Settings.Uri, 'Request/Step1', $scope.data,
                function (response) {
                    $location.path("/Step/" + response.id);
                }, $scope.error);
        };
    }]);

App.controller('Step1Ctrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'ModalService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, ModalService) {
    breaDcrumb.breadcrumb();
    $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
    $scope.isValid = true;
    $scope.Id = 0;
    $scope.isSelected = false;
    $scope.titleSearch = "Freight Ideas";
    //Manejador de Errores
    $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); };

    //Detalle de la pagina
    $scope.Get = function () {
        $scope.Id = $routeParams.Id;
        if ($routeParams.Id !== 0) {
            $scope.Rest.Get($scope.Settings.Uri, 'Request/Get/' + $routeParams.Id, function (response) {
                $scope.item = response.data;
            }, $scope.error);
        }
    };

    $scope.Step2 = function (s, c) {
        var data = {
            Status: s === undefined ? 'PENDING' : s,
            Continue: c === undefined ? 0 : c
        };
        $scope.Rest.Post($scope.Settings.Uri, 'Request/Step2/' + $routeParams.Id, data,
            function (response) {
                $scope.items = response.data;
            }, $scope.error);
    };

    $scope.ChangeStatusRequest = function () {
        var data = {
            Status: 'REQUEST'
        };
        $scope.Rest.Post($scope.Settings.Uri, 'Request/ChangeStatusRequest/' + $routeParams.Id, data,
            function (response) {
                $scope.toastr.info("The request has been sent,notification", 'Information!');
                $location.path("/Step");
            }, $scope.error);
    };

    $scope.NewSearch = function () {
        $scope.token.item = [];
        $location.path("/Step");
    };

    $scope.Back = function () {
        $scope.token.item = [];
        $scope.Rest.Post($scope.Settings.Uri, 'Request/Continue?token=' + $routeParams.Id, $scope.token.item,
            function (response) {
                $scope.Step2();
            }, $scope.error);
        $location.path("/StepBack/" + $routeParams.Id + '/1');
    };

    $scope.Back2 = function () {
        $scope.token.item = [];
        if ($scope.items.filter(item => item.Status === 'REQUEST').length > 0) {
            angular.forEach($scope.items.filter(item => item.Status === 'REQUEST'), function (data, key) {
                $scope.token.item.push(data.Token);
            });
        }
        $scope.isSelected = false;
        $scope.Rest.Post($scope.Settings.Uri, 'Request/Continue?token=' + $routeParams.Id, $scope.token.item,
            function (response) {
                $scope.Step2('REQUEST', 1);
            }, $scope.error);
    };

    $scope.Continue = function () {
        $scope.titleSearch = "Request Proposal For Freight Indication";

        if ($scope.token.item.length === 0) {
            $scope.toastr.error("Selected Vessel", 'Selected');
            return
        }
        $scope.Rest.Post($scope.Settings.Uri, 'Request/Continue?token=' + $routeParams.Id, $scope.token.item,
            function (response) {
                $scope.isSelected = true;
                $scope.Step2('REQUEST', 1);
            }, $scope.error);
    };

    $scope.token = { "item": [] };

    $scope.Check = function (data) {
        var arraySelected = $scope.token.item;
        return arraySelected.indexOf(data.Token) > -1;
    }

    $scope.UnCheck = function (data) {
        var arraySelected = $scope.token.item;
        var index = arraySelected.indexOf(data.Token);
        if (index > -1) {
            arraySelected.splice(index, 1);
        } else {
            $scope.token.item.push(data.Token);
        }
    }
    $scope.GoDetailVessel = function (data) {
        ModalService.showModal({
            templateUrl: "Partial/Modal/PropertyVessel.html",
            controller: "PropertyVesselCtrl",
            inputs: {
                Id: data
            }
        }).then(function (modal) {
            modal.element.modal();
            modal.close.then(function (result) {
            });
        });
    };

    $scope.Get();
    $scope.Step2();
}])
    .controller('PropertyVesselCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', 'Id', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService, Id) {
        $scope.error = function (data) { $scope.toastr.error(data.Message, 'Error'); }
        //Datos para paginacion
        $scope.Get = function () {
            $scope.Rest.Get($scope.Settings.Uri, 'Vessel/PropertyToVessel/' + Id, function (response) {
                $scope.items = response.data;
            }, $scope.error);
        };

        $scope.Get();
    }])

    .controller('FinishCtrl', ['$scope', 'serviceRest', 'breaDcrumb', '$routeParams', '$location', 'authService', function ($scope, serviceRest, breaDcrumb, $routeParams, $location, authService) {
        breaDcrumb.breadcrumb();
        $scope.pageCurrent = breaDcrumb.pages.pageCurrent;
        $scope.isValid = true;
        //Manejador de Errores
        $scope.error = function (data) {
            $scope.toastr.error(data.ExceptionMessage, 'Error');
        }
    }]);