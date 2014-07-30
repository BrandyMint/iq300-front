var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

IQ300 = {
  domLoaded: false,
  loadedScripts: [],

  loadScript: function(url, delay, callback) {
    if (callback && delay !== undefined && delay !== false) {
      setTimeout(function() {
        IQ300.loadScript(url, callback);
      }, delay);
      return;
    } else {
      callback = delay;
    }

    if (!this.domLoaded) {
      jQuery(document).ready(function() {
        IQ300.loadScript(url, callback);
      });
      return;
    }

    if (this.loadedScripts.indexOf(url) != -1) {
      callback();
      return;
    }

    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.async = true;

    script.onreadystatechange = function () {
      if (this.readyState == 'complete' || this.readyState == 'loaded') {
        IQ300.loadedScripts.push(url);
        callback();
      }
    }

    script.onload = function() {
      IQ300.loadedScripts.push(url);
      callback();
    };

    script.src = url;
    head.appendChild(script);
  }
};

IQ300.Plugin = {
  known: {},
  loaded: {},

  use: function(name, callback) {
    if (name in this.loaded) {
      // if loaded just  run callback
      callback();
    } else {
      // if loading put callback in stack
      if (this.known[name].status == 'loading') {
        this.known[name].onLoad.push(callback);
      // else just load
      } else {
        this.known[name].status = 'loading';
        fn =  __bind(function() {
          this.known[name].status = 'loaded';
          this.loaded[name] = true;

          this.known[name].onLoad.forEach(function(fn) { fn() });
          callback();
          }, this);
        IQ300.loadScript(this.known[name].path, fn)
      }
    }
  },

  register: function(name, path) {
    this.known[name] = {path: path, onLoad: []};
  }
};

jQuery(document).ready(function() {
  IQ300.domLoaded = true;
});

IQ300.Plugin.register('pusher', '//js.pusher.com/2.2/pusher.min.js');

IQ300.Plugin.register('editable', '/assets/plugins/bootstrap.editable.js');
IQ300.Plugin.register('tree',     '/assets/plugins/jquery.tree.js');
IQ300.Plugin.register('select2',  '/assets/plugins/select2.js');
IQ300.Plugin.register('select2_locale_ru',  '/assets/plugins/select2.ru.js');
IQ300.Plugin.register('moment',  '/assets/plugins/moment.js');
IQ300.Plugin.register('masked-input',  '/assets/plugins/masked_input.js');
IQ300.Plugin.register('jquery-autosize', '/assets/plugins/jquery.autosize.js');
IQ300.Plugin.register('jquery-shiftenter', '/assets/plugins/jquery.shiftenter.js');
IQ300.Plugin.register('bootstrap-datepicker', '/assets/plugins/bootstrap.datepicker.js');
IQ300.Plugin.register('bootstrap-datepicker-ru' , '/assets/plugins/bootstrap.datepicker.ru.js');
IQ300.Plugin.register('bootstrap-modal', '/assets/plugins/bootstrap.modal.js');
IQ300.Plugin.register('redactor', '/assets/plugins/redactor.js');
IQ300.Plugin.register('jquery-drag-and-drop', '/assets/plugins/jquery.drag_and_drop.js');
IQ300.Plugin.register('jquery-ui-draggable-droppable', '/assets/plugins/jquery.ui.draggable_droppable.js');
IQ300.Plugin.register('jquery-ui-touch-punch', '/assets/plugins/jquery.ui.touch-punch.js');
IQ300.Plugin.register('jquery-jcrop', '/assets/plugins/jquery.crop.js');
IQ300.Plugin.register('zebra-datepicker', '/assets/plugins/zebra.datepicker.js');
IQ300.Plugin.register('gantt', '/assets/plugins/gantt.js');
IQ300.Plugin.register('jquery-form', '/assets/plugins/jquery.form.js');
IQ300.Plugin.register('typeahead', '/assets/plugins/typeahead.js');
IQ300.Plugin.register('fullcalendar', '/assets/plugins/fullcalendar.js');
IQ300.Plugin.register('atwho', '/assets/plugins/atwho.js');
