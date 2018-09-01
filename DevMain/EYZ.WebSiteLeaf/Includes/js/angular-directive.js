directives.directive('noty', function ($timeout) {
    return {
        restrict: 'A',
        link: function (scope, element, attr) {
            var $body = $('body .main-panel .panel-heading');
            var $notiny = $('<div class="notiny" />').appendTo($body);
        }
    }
});
directives.directive('ngConfirmMessage', [function () {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            debugger;
            element.on('click', function (e) {
                var message = attrs.ngConfirmMessage || "Are you sure ?";
                if (!confirm(message)) {
                    e.stopImmediatePropagation();
                }
            });
        }
    }
}]);

//directives.directive('fileModel', ['$parse', function ($parse) {
//    return {
//        restrict: 'A',
//        link: function (scope, element, attrs) {
//            var model = $parse(attrs.fileModel);
//            var modelSetter = model.assign;

//            element.bind('change', function () {
//                scope.$apply(function () {
//                    modelSetter(scope, element[0].files[0]);
//                });
//            });
//        }
//    };
//}]);
directives.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;

            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);
directives.directive("strToTime", function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attrs, ngModelController) {
            ngModelController.$parsers.push(function (data) {
                if (!data)
                    return "";
                return ("0" + data.getHours().toString()).slice(-2) + ":" + ("0" + data.getMinutes().toString()).slice(-2);
            });

            ngModelController.$formatters.push(function (data) {
                if (!data) {
                    return null;
                }
                var d = new Date(1970, 1, 1);
                var splitted = data.split(":");
                d.setHours(splitted[0]);
                d.setMinutes(splitted[1]);
                return d;
            });
        }
    };
});
//numeric-only ng-pattern="/^\d{7,10}$/"
directives.directive('numericOnly', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attrs, modelCtrl) {
            modelCtrl.$parsers.push(function (inputValue) {
                var transformedInput = inputValue ? inputValue.replace(/[^\d]/g, '') : null;

                if (transformedInput != inputValue) {
                    modelCtrl.$setViewValue(transformedInput);
                    modelCtrl.$render();
                }

                return transformedInput;
            });
        }
    };
});
// this is the angular way to stop even propagation
directives.directive('stopEvent', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attr) {
            element.bind(attr.stopEvent, function (e) {
                e.stopPropagation();
            });
        }
    }
});

// Here is where the magic works
//date='dd-MM-yyyy'
directives.directive('date', function (dateFilter) {
    return {
        require: 'ngModel',
        link: function (scope, elm, attrs, ctrl) {
            var dateFormat = attrs['date'] || 'yy-MM-dd';

            ctrl.$formatters.unshift(function (modelValue) {
                return dateFilter(modelValue, dateFormat);
            });
        }
    };
});
directives.directive('jqdatepicker', function () {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function (scope, element, attrs, ngModelCtrl) {
            $(element).datepicker({
                dateFormat: 'yy-mm-dd',

                onSelect: function (date) {
                    var ngModelName = this.attributes['ng-model'].value;

                    // if value for the specified ngModel is a property of
                    // another object on the scope
                    if (ngModelName.indexOf(".") != -1) {
                        var objAttributes = ngModelName.split(".");
                        var lastAttribute = objAttributes.pop();
                        var partialObjString = objAttributes.join(".");
                        var partialObj = eval("scope." + partialObjString);

                        partialObj[lastAttribute] = date;
                    }
                    // if value for the specified ngModel is directly on the scope
                    else {
                        scope[ngModelName] = date;
                    }
                    scope.$apply();
                }
            });
        }
    };
});

directives.directive('jqdatepicker2', function () {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function (scope, element, attrs, ngModelCtrl) {
            element.datepicker({
                dateFormat: 'dd/mm/yy',
                onSelect: function (date) {
                    var ar = date.split("/");
                    date = new Date(ar[2] + "-" + ar[1] + "-" + ar[0]);
                    ngModelCtrl.$setViewValue(date.getTime());
                    //    scope.course.launchDate = date;
                    scope.$apply();
                }
            });
        }
    };
});

directives.directive('datepicker', function () {
    return {
        restrict: 'A',
        require: 'ngModel',
        link: function (scope, element, attrs, ngModelCtrl) {
            $(element).datepicker({
                dateFormat: 'dd-mm-yy',
                onSelect: function (date) {
                    scope.appoitmentScheduleDate = date;
                    scope.$apply();
                }
            });
        }
    };
})
//directives.directive('loading', function () {
//    return {
//        restrict: 'E',
//        replace: true,
//        template: '<div class="loading"><img src="http://www.nasa.gov/multimedia/videogallery/ajax-loader.gif" width="20" height="20" />LOADING...</div>',
//        link: function (scope, element, attr) {
//            scope.$watch('loading', function (val) {
//                if (val)
//                    scope.loadingStatus = 'true';
//                else
//                    scope.loadingStatus = 'false';
//            });
//        }
//    }
//});