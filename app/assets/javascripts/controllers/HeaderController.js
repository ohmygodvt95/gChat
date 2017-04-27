app.controller('HeaderController', function ($scope, ModalService) {

  $scope.openContactModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/contacts.html',
      controller: 'ContactController'
    }).then(function(modal) {
      modal.element.modal();
      modal.close.then(function(result) {
      });
    });
  };

  $scope.openGroupModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/group.html',
      controller: 'GroupController'
    }).then(function(modal) {
      modal.element.modal();
      modal.close.then(function(result) {
      });
    });
  };

});
