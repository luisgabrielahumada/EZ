// TODO should scope this to Angular instead of polluting global namespace

/*

 This class maintains a list of notifications on the scope, and cleans up notifications
 as they are processed by the directive.  It is important to note the "notifications"
 model added to scope here... this is called out by name in HTML and from the accompanying
 directive.  Changing the name will break notification functionality.

 R.Christian

 */
var NotificationManager = function (scope) {
    // notification queue
    scope.notifications = [];  // WARN:  Don't change this variable name, it's coupled to scope and outside of this function.

    // remove processed notifications
    this.sweepNotifications = function () {
        for (var i = 0; i < scope.notifications.length; i++) {
            if (scope.notifications[i].processed == true) {
                scope.notifications = scope.notifications.splice(i, 1);
                scope.notifications = [];
                i = i + 1;
                continue;
            }
        }
    }

    // add notification to model
    this.notify = function (type, text, closeWith, textCancel) {
        debugger;
        //debugger;
        // convenient place to say "while we're
        // here, clear all processed notifications
        // from the model
        this.sweepNotifications();
        // push notifications onto scope to be observed by directive
        scope.notifications.push({ "type": type, "text": text });
        var availableType = {
            'error': '<div class="alert alert-danger alert-dismissible"> <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div class="noty_message "><span class="noty_text"></span></div> </div>',
            'success': '<div class="alert alert-success alert-dismissible"> <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div class="noty_message "><span class="noty_text"></span></div> </div>',
            'info': '<div class="alert alert-info alert-dismissible"> <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div class="noty_message "><span class="noty_text"></span></div> </div>',
            'warning': '<div class="alert alert-warning alert-dismissible"> <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div class="noty_message "><span class="noty_text"></span></div></div>',
        }
        var _closeWith = closeWith == null ? 'click' : closeWith;
        var _textCancel = textCancel == null ? 'Cerrar' : textCancel;
        var _buttons = _closeWith == 'button' ? [
						{
						    addClass: 'md-raised md-primary md-button', text: _textCancel, onClick: function ($noty) {
						        $noty.close();
						    }
						}
        ] : false;
        var opts = {
            layout: 'right',
            theme: 'someOtherTheme',
            dismissQueue: true, // If you want to use queue feature set this true
            template: availableType[type],
            animation: {
                open: { height: 'toggle' },
                close: { height: 'toggle' },
                easing: 'swing',
                speed: 500 // opening & closing animation speed
            },
            timeout: 3000, // delay for closing event. Set false for sticky notifications
            force: false, // adds notification to the beginning of queue when set to true
            modal: false,
            maxVisible: 1, // you can set max visible notification for dismissQueue true option
            closeWith: [_closeWith], // ['click', 'button', 'hover']
            callback: {
                onShow: function () { },
                afterShow: function () { },
                onClose: function () { },
                afterClose: function () { }
            },
            buttons: _buttons
        };


        var index = scope.$index;
        if (index == undefined) index = 0;
        var notification = scope.notifications[index];
        var text = null;
        var type = null;
        if (notification != null) {
            text = notification['text'];
            type = notification['type'];

            opts.text = text;
            opts.type = type;
            opts.processed = true;

            // errors persist on screen longer
            if (type == 'error') {
                opts.layout = 'bottomLeft';
            }

            notification['processed'] = true;
        }

        noty(opts);
        scope.notifications = [];
    }

}