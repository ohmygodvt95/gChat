app.controller('HeaderController', function ($scope, ModalService) {

  $scope.openContactModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/contacts.html',
      controller: 'ContactController',
      backdrop: 'static',
      keyboard: false
    }).then(function(modal) {
      modal.element.modal();
      modal.element.on('hidden.bs.modal', function() {
        $('.modal').remove();
        $('.modal-backdrop').remove();
      });
    });
  };

  $scope.openGroupModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/group.html',
      controller: 'GroupController'
    }).then(function(modal) {
      modal.element.modal();
      modal.element.on('hidden.bs.modal', function() {
        $('.modal').remove();
        $('.modal-backdrop').remove();
      });
    });
  };

});
