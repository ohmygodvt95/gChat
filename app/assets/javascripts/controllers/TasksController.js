app.controller('TasksController', function ($scope, close, Task, toastr) {
  $scope.close = close;
  /**
   * Init controller
   */
  function init() {
    Task.total().then(function (res) {
      $scope.tasksForMe = res.data.data;
    });

    Task.completed().then(function (res) {
      $scope.completed = res.data.data;
    });

  }

  // init
  init();

  $scope.done = function (task) {
    Task.done(task).then(function (res) {
      toastr.success(res.data.message);
      _.remove($scope.tasksForMe, {id: task.id})
    });
  };

  $scope.delete = function (task) {
    Task.delete(task).then(function (res) {
      toastr.success(res.data.message);
      _.remove($scope.tasksForMe, {id: task.id})
    });
  };
});
