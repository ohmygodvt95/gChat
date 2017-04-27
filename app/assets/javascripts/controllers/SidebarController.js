app.controller('SidebarController', function ($scope, $rootScope, Room) {

  function init() {
    Room.index().then(function (data) {
      $rootScope.rooms = data.data;
    });
  }
  
  init();
});
