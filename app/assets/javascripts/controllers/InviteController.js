app.controller('InviteController', function ($scope, Room, $stateParams, Invite, toastr) {
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

  $scope.invite = function () {
    Invite.create($scope.room, $scope.email).then(function (response) {
      if(response.status === 404){
        toastr.error(response.data.message);
      }
      else if(response.status === 200){
        toastr.success(response.data.message);
        $scope.email = '';
      }
    });
  };
  //init
  init();
});
