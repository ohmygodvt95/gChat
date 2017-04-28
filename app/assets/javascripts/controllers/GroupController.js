app.controller('GroupController', function ($scope, Room, close) {
  /**
   * Init controller
   */
  function init() {
    $scope.room = {
      name: '',
      description: '',
      room_type: 'group'
    }
  }

  $scope.create = function () {
    Room.create($scope.room).then(function (response) {
      $scope.message = response.data.message;
      $scope.room = {
        name: '',
        description: '',
        room_type: 'group'
      }
    });
  };
  // init
  init();
});
