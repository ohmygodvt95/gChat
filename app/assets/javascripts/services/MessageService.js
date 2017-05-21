app.service('Message', function ($http, $q, $state) {
  this.index = function (room, from) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'rooms/' + room.id
      + '/messages?from=' + from).then(function (response) {
      deferred.resolve(response.data);
    });
    return deferred.promise;
  };

  this.show = function (room, message) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'rooms/' + room.id
      + '/messages/' + message.id).then(function (response) {
        console.log(response);
      deferred.resolve(response);
    });
    return deferred.promise;
  };

  this.create = function (room, message) {
    var deferred = $q.defer();
    var promise = $http.post(app.basePath + 'rooms/' + room.id
      + '/messages', {message: message})
      .then(function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };

  this.destroy = function (room, message) {
    var deferred = $q.defer();
    var promise = $http.delete(app.basePath + 'rooms/' + room.id
      + '/messages/' + message.id)
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
