app.service('Room', function ($http, $q) {
  this.index = function (page) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'rooms')
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };

  this.create = function (room) {
    var deferred = $q.defer();
    var promise = $http.post(app.basePath + 'rooms', {room: room})
      .then(function (response) {
        deferred.resolve(response);
      }, function(response){
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
