// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap/dist/js/bootstrap.min
//= require jquery_ujs
//= require AdminLTE/plugins/slimScroll/jquery.slimscroll.min
//= require AdminLTE/dist/js/app.min
//= require lodash/dist/lodash.min
//= require angular
//= require angular-animate
//= require angular-ui-router
//= require angular-websocket
//= require angular-actioncable
//= require angular-modal-service/dst/angular-modal-service
//= require_self
//= require_tree ./controllers
//= require_tree ./services

var app = angular.module('GChat', ['ngActionCable', 'ui.router', 'angularModalService']);
app.basePath = $('meta[name="base"]').attr('content');
app
  .config(function ($stateProvider, $urlRouterProvider) {
    $stateProvider
      .state('welcome', {
        url: '/welcome',
        views: {
          'main': {
            templateUrl: 'templates/welcome.html'
          }
        }
      })
      .state('room', {
        url: '/{room_id: int}',
        views: {
          'main': {
            templateUrl: 'templates/room.html',
            controller: 'RoomController'
          }
        }
      })
      .state('room.edit', {
        url: '/edit',
        views: {
          'main@': {
            templateUrl: 'templates/roomedit.html',
            controller: 'RoomInfoController'
          }
        }
      });
    $urlRouterProvider.otherwise('/welcome');
  });
