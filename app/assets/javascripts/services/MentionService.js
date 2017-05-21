app.service('Mention', function ($http, $q) {
  this.update = function (mention) {
    var deferred = $q.defer();
    var promise = $http.patch(app.basePath + 'rooms/' + mention.room_id
      + '/messages/' + mention.message_id + '/mentions/' + mention.id, {mention: {is_read: true}})
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
