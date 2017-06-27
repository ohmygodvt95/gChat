app.controller('MentionController', function ($scope, Room, close, room_id) {
  $scope.list = [];
  $scope.close = close;
  /**
   * Init controller
   */
  function init() {
    Room.show(room_id).then(function (response) {
      $scope.room = response.data.data;
    });
  }

  // init
  init();

  $scope.mention = function () {
    close($scope.list);
  };
});
