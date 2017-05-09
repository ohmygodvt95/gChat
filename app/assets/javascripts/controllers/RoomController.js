app.controller('RoomController', function ($scope, Room, $stateParams, ActionCableChannel, Message) {
  $scope.room_id = $stateParams.room_id;
  $scope.messages = [];
  /**
   * Init controller
   */
  function getRoomInfo() {
    Room.show($scope.room_id).then(function (response) {
      $scope.room = response.data.data;
    });
  }

  function init() {
    getRoomInfo();
  }

  var consumer = new ActionCableChannel('RoomChannel', {room_id: $scope.room_id});

  var callback = function (response) {
    if (response.notify.type === 'new_message') {
      $scope.inputText = '';
      $scope.messages.push(response.notify.message);
      $('#messages').animate({
        scrollTop: 9999999
      }, 500);
    }
  };

  consumer.subscribe(callback).then(function () {

    init();

    $('textarea').keydown(function (event) {
      if (event.keyCode === 13) {
        event.preventDefault();
        Message.create($scope.room, {raw_content: $scope.inputText})
          .then(function (data) {
            console.log(data);
          });
      }
    });

    $scope.$on("$destroy", function () {
      consumer.unsubscribe().then(function () {
      });
    });
  });
});
