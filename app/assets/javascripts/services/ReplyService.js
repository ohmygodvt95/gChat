app.service('Reply', function ($http, $q) {
  this.update = function (reply) {
    var deferred = $q.defer();
    var promise = $http.patch(app.basePath + 'rooms/' + reply.room_id
      + '/messages/' + reply.message_id + '/replies/' + reply.id, {reply: {is_read: true}})
      .then(function (response) {
        deferred.resolve(response);
      }, function (response) {
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
