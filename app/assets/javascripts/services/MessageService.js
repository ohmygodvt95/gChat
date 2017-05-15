app.service('Message', function ($http, $q, $state) {

  this.index = function (room, page) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'rooms/' + room.id
      + '/messages?page=' + page).then(function (response) {
      deferred.resolve(response.data);
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
});
