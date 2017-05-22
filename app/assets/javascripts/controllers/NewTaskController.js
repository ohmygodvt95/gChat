app.controller('NewTaskController', function ($scope, Room, close, room, Task, toastr) {
  $scope.list = [];
  $scope.close = close;
  /**
   * Init controller
   */
  function init() {
    $scope.room = room;
  }

  // init
  init();
  
  $scope.create = function () {
    var task = {
      content: $scope.content,
      due_date: $scope.due_date,
      list: $scope.list
    };
    Task.create($scope.room, task).then(function (response) {
      toastr.success(response.data.message);
    });
  };
});
