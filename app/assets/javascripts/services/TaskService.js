app.service('Task', function ($http, $q) {
  this.index = function (room) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'rooms/' + room.id
      + '/tasks')
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };

  this.create = function (room, task) {
    var deferred = $q.defer();
    var promise = $http.post(app.basePath + 'rooms/' + room.id
      + '/tasks', {task: task})
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };

  this.total = function () {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'tasks' )
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };

  this.done = function (task) {
    var deferred = $q.defer();
    var promise = $http.patch(app.basePath + 'rooms/' + task.room_id
      + '/tasks/' + task.id)
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
