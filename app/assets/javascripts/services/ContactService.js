app.service('Contact', function ($http, $q, $state) {

  this.index = function (page) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'contacts?page=' + page)
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };

  this.create = function (item) {
    var deferred = $q.defer();
    var promise = $http.post(app.basePath + 'contacts',
      {contact: {user_receiver_id: item.id}})
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };

  this.request = function (page) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'contacts?act=new_request&page=' + page)
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };

  this.accept = function (item) {
    var deferred = $q.defer();
    var promise = $http.patch(app.basePath + 'contacts/' + item.id)
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };

  this.search = function (page, query) {
    var deferred = $q.defer();
    var promise = $http.get(app.basePath + 'contacts?query=' + query + '&page=' + page)
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };

  this.destroy = function (item) {
    var deferred = $q.defer();
    var promise = $http.delete(app.basePath + 'contacts/' + item.id)
      .then(function (response) {
        deferred.resolve(response.data);
      });
    return deferred.promise;
  };
});
