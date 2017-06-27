app.controller('HeaderController', function ($scope, ModalService, $rootScope,
  ActionCableChannel, Contact, Room, $interval, Task, $timeout) {

  $rootScope.current_user = $('#current_user').val();

  function update_new_request_contact() {
    Contact.request(0).then(function (data) {
      $rootScope.requests = data
    });
  }
  function update_list_contacts() {
    Room.index().then(function (data) {
      $rootScope.rooms = data.data;
    });
  }

  function update_tasks() {
    Task.total().then(function (res) {
      $scope.tasks = res.data.data;
    });
  }
  
  $scope.openContactModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/contacts.html',
      controller: 'ContactController',
      backdrop: 'static',
      keyboard: false
    }).then(function (modal) {
      modal.element.modal();
      modal.element.on('hidden.bs.modal', function () {
        $('.modal').remove();
        $('.modal-backdrop').remove();
      });
    });
  };

  $scope.openGroupModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/group.html',
      controller: 'GroupController'
    }).then(function (modal) {
      modal.element.modal();
      modal.close.then(function(result) {
        $('.modal').remove();
        $('.modal-backdrop').remove();
        update_list_contacts();
      });
    });
  };

  $scope.openTaskManagerModal = function () {
    ModalService.showModal({
      templateUrl: 'templates/tasksmanager.html',
      controller: 'TasksController'
    }).then(function (modal) {
      modal.element.modal();
      modal.element.on('hidden.bs.modal', function () {
        $('.modal').remove();
        $('.modal-backdrop').remove();
      });
    });
  };

  var consumer = new ActionCableChannel('NotifyChannel');

  var callback = function (response) {
    if(response.notify.type === 'new_request_contact'){
      update_new_request_contact();
    }
    else if(response.notify.type === 'update_list_rooms'){
      update_list_contacts();
    }
    else if(response.notify.type === 'reply_message'){
      update_list_contacts();
    }
    else if(response.notify.type === 'mention_user'){
      update_list_contacts();
    }
    else if(response.notify.type === 'new_task'){
      console.log(response.notify);
      update_tasks();
      update_list_contacts();
    }
    else if(response.notify.type === 'delete_task'){
      update_tasks();
      update_list_contacts();
    }
  };

  consumer.subscribe(callback).then(function () {
    $scope.$on("$destroy", function () {
      consumer.unsubscribe().then(function () {
      });
    });
  });

  function init(){
    update_new_request_contact();
    update_tasks();
  }

  init();
});
