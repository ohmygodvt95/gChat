app.controller('ContactController', function ($scope, Contact, $timeout, $rootScope) {
  /**
   * Init controller
   */

  function init() {
    Contact.index(0).then(function (data) {
      $scope.myContacts = data;
    });
    Contact.request(0).then(function (data) {
      $rootScope.requests = data;
    });
  }

  function showMessage(string) {
    $scope.message = string;
    $timeout(function () {
      $scope.message = null;
    }, 3000);
  }

  $scope.search = function () {
    $scope.previewSearchItem = null;
    if($scope.query.length > 0){
      Contact.search(0, $scope.query).then(function (data) {
        $scope.searchResult = data;
      });
    }
  };

  $scope.previewContact = function (item, view) {
    if(view === 'my_contact'){
      $scope.previewMyContactItem = item;
    }
    else if(view === 'search'){
      $scope.previewSearchItem = item;
    }
    else if(view === 'request'){
      $scope.previewRequestItem = item;
    }
  };

  $scope.addContact = function (item) {
    Contact.create(item).then(function (data) {
      showMessage(data.message);
      $scope.previewSearchItem = null;
      _.remove($scope.searchResult.data, function (user) {
        return user.id === item.id;
      })
    });
  };

  $scope.destroy = function (item) {
    Contact.destroy(item).then(function (data) {
      showMessage(data.message);
      $scope.previewMyContactItem = null;
      Contact.index(0).then(function (data) {
        $scope.myContacts = data;
      });
    });
  };

  $scope.accept = function (item) {
    Contact.accept(item).then(function (data) {
      showMessage(data.message);
      $scope.previewRequestItem = null;
      Contact.request(0).then(function (data) {
        $rootScope.requests = data;
      });
      Contact.index(0).then(function (data) {
        $scope.myContacts = data;
      });
    });
  };

  $scope.page = function (page, action) {
    if(action === 'search' && page !== null){
      Contact.search(page, $scope.query).then(function (data) {
        $scope.searchResult = data;
      });
    }
    else if(action === 'my_contact' && page !== null){
      Contact.index(page).then(function (data) {
        $scope.myContacts = data;
      });
    }
    else if(action === 'request' && page !== null){
      Contact.request(page).then(function (data) {
        $rootScope.requests = data;
      });
    }
  };
  // init
  init();
});
