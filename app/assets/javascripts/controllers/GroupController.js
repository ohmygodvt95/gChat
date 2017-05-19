app.controller('GroupController', function ($scope, Room, toastr) {
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
      toastr.success(response.data.message);
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
