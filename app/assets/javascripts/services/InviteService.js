app.service('Invite', function ($http, $q) {
  this.create = function (room, email) {
    var deferred = $q.defer();
    var promise = $http.post(app.basePath + 'rooms/' + room.id
      + '/invite', {invite: {email: email}})
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
