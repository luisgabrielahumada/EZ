directives.directive('paging2', function () {


    /**
     * The regex expression to use for any replace methods
     * Feel free to tweak / fork values for your application
     */
    var regex = /\{page\}/g;


    /**
     * The angular return value required for the directive
     * Feel free to tweak / fork values for your application
     */
    return {

        // Restrict to elements and attributes
        restrict: 'EA',

        // Assign the angular link function
        link: fieldLink,

        // Assign the angular directive template HTML
        templateUrl: "../includes/js/templates/paging2/paging2.html",

        // Assign the angular scope attribute formatting
        scope: {
            page: '=',
            pageSize: '=',
            total: '=',
            totalsPages: '=',
            pagingAction: '&',
            pagingBlur: '&'
        }

    };
    /**
     * Link the directive to enable our scope watch values
     *
     * @param {object} scope - Angular link scope
     * @param {object} el - Angular link element
     * @param {object} attrs - Angular link attribute
     */
    function fieldLink(scope, element, attrs) {

        scope.$watchCollection('[page,pageSize,totalsPages,total,disabled]', function () {
            build(scope, element, attrs);
        });

    }

    function build(scope, element, attrs) {
        scope.totalPages = [];
        //scope.pagingAction({ page: scope.page });
        //scope.pagingBlur({ pageSize: scope.pageSize 
        var pages = Math.ceil(scope.total / parseInt(scope.pageSize));
        scope.totalsPages = pages;
        scope.totalPages = LoadPages(scope.totalsPages);
        element.bind("change", function () {
            scope.$apply(function () {
                //var pages = Math.ceil(scope.total / parseInt(scope.pageSize));
                //scope.totalsPages = pages;
                //scope.totalPages = LoadPages(scope.totalsPages);
                scope.pagingAction({ page: scope.pageIndex });
            });
        });
    }

    function LoadPages(totalPage) {
        var totalPages = [];
        for (var i = 1; i <= totalPage; i++) {
            totalPages.push({ index: i });
        }
        return totalPages;
    };

});