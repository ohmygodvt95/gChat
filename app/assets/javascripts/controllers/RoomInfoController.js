app.controller('RoomInfoController', function ($scope, Room, $stateParams, toastr) {
  $scope.room_id = $stateParams.room_id;
  /**
   * Init controller
   */
  function init() {
    getRoomInfo();
  }

  /**
   * Get room info
   */
  function getRoomInfo() {
    Room.show($scope.room_id).then(function (response) {
      $scope.room = response.data.data;
    });
  }

  $scope.update = function () {
    Room.update($scope.room).then(function (response) {
      $scope.room = response.data.data;
      toastr.success(response.data.message);
    });
  };

  //init
  init();
});
