//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require ./lib/jquery-migrate
//= require jquery.mobile.custom.min
//= require best_in_place
//= require best_in_place.purr
//= require ./lib/underscore
//= require ./lib/underscore.string
//= require ./lib/underscore.inflections
//= require lib/jsuri
//= require ./lib/backbone
//= require ./lib/backbone.routerfilter
//= require ./lib/jquery.cookie
//= require ./lib/jquery-scrollto
//= require ./lib/pnotify
//= require ./lib/store
//= require ./lib/lightbox
//= require ./lib/bootstrap-tooltip

//= require_tree ./services
//= require app

//= require_tree ./initializers

//= require models/base/model.module
//= require_tree ./models/base
//= require_tree ./models/filters
//= require_tree ./models/team_editor
//= require_tree ./models

//= require collections/base/collection.module
//= require_tree ./collections/team_editor
//= require collections/departments.module
//= require collections/department-jobs.module
//= require collections/memberships-contracts.module
//= require collections/changes-observer.module

//= require backbone_views/base/view.module
//= require_tree ./backbone_views/base
//= require_tree ./backbone_views/

//= require_tree ./views/base
//= require_tree ./views/shared
//= require_tree ./views

//= require routers
//= require jade/runtime
//= require_tree ./templates/