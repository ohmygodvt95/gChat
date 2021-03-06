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
  
  this.show = function (room_id) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'rooms/' + room_id)
      .then(function (response) {
        deferred.resolve(response);
      }, function(response){
        deferred.resolve(response);
      });
    return deferred.promise;
  };

  this.update = function (room) {
    var deferred = $q.defer();
    var promise = $http.patch(app.basePath + 'rooms/' + room.id, {room: room})
      .then(function (response) {
        deferred.resolve(response);
      }, function(response){
        deferred.resolve(response);
      });
    return deferred.promise;
  };

  this.leave = function (room) {
    var deferred = $q.defer();
    var promise = $http.delete(app.basePath + 'rooms/' + room.id + '/leave')
      .then(function (response) {
        deferred.resolve(response);
      }, function(response){
        deferred.resolve(response);
      });
    return deferred.promise;
  };
});
