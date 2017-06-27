app.service('UserRoom', function ($http, $q) {
  this.update = function (room) {
    var deferred = $q.defer();
    var promise = $http.patch(app.basePath + 'rooms/' + room.id
      + '/user_rooms')
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
