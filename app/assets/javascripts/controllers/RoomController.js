app.controller('RoomController', function ($scope, Room, $stateParams, ActionCableChannel, Message,
  $timeout, $state, toastr, $sce, ModalService) {
  $scope.inputText = '';
  $scope.room_id = $stateParams.room_id;
  $scope.canLoadMessages = true;
  $scope.data = {
    messages: [],
    from: 0
  };
  /**
   * Init controller
   */
  function init() {
    getRoomInfo();
    $('#messages').on('scroll', function () {
      if ($(this).scrollTop() <= 10 && $scope.canLoadMessages) {
        $scope.focus = $('.msg').first().attr('data');
        loadMoreMessages($scope.data.from, $timeout(function () {
          scrollToMessage();
        }, 500));
      }
    });

    $(document).on('click', '.reply', function () {
      alert($(this).attr('data'));
    })
  }

  /**
   * Get room info
   */
  function getRoomInfo() {
    Room.show($scope.room_id).then(function (response) {
      $scope.room = response.data.data;
      loadMoreMessages($scope.data.from, scrollBox);
    });
  }

  /**
   * Load messages from id
   * @param from
   * @param callback
   */
  function loadMoreMessages(from, callback) {
    $scope.canLoadMessages = false;
    Message.index($scope.room, from).then(function (data) {
      $scope.data.from = data.from;
      $scope.data.messages = _.concat($scope.data.messages, data.data);
      $scope.data.messages = _.sortBy($scope.data.messages, ['id']);
      $scope.canLoadMessages = data.per_page <= data.total;
      if (_.isFunction(callback)) {
        callback();
      }
    });
  }

  /**
   * Scroll box chat
   */
  function scrollBox() {
    $('#messages').animate({
      scrollTop: 9999999
    }, 500);
  }

  /**
   * scroll to message id
   */
  function scrollToMessage() {
    $('#messages').animate({
      scrollTop: $('#msg-' + $scope.focus).position().top
    }, 500);
  }

  // Action cable
  var consumer = new ActionCableChannel('RoomChannel', {room_id: $scope.room_id});

  var callback = function (response) {
    if (response.notify.type === 'new_message') {
      $scope.inputText = '';
      $scope.data.messages.push(response.notify.message);
      $scope.data.messages = _.sortBy($scope.data.messages, ['id']);
      scrollBox();
    }
    else if (response.notify.type === 'update_room_info') {
      getRoomInfo();
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

  $scope.leave = function () {
    Room.leave($scope.room).then(function (response) {
      toastr.success(response.data.message);
      $state.go('welcome');
    }, function (response) {
      toastr.error(response.data.message);
    });
  };

  $scope.reply = function (message) {
    $scope.inputText += ('@reply:' + message.id + ' ' + message.user.username + '\n');
  };

  $scope.convert = function (string) {
    return $sce.trustAsHtml(string);
  };

  $scope.mention = function () {
    ModalService.showModal({
      templateUrl: 'templates/mention.html',
      controller: 'MentionController',
      inputs: {
        room_id: $scope.room_id
      }
    }).then(function (modal) {
      modal.element.modal();
      modal.close.then(function(result) {
        $('.modal').remove();
        $('.modal-backdrop').remove();
        if(result){
          result.map(function (user) {
            $scope.inputText += '@mention:' + user.id + ' ' + user.username + '\n';
          });
        }
      });
    });
  };
});
