app.controller('RoomController', function ($scope, Room, $stateParams, ActionCableChannel, Message,
  $timeout, $state, toastr, $sce, ModalService, $rootScope, Reply, Mention, UserRoom, Task) {
  $scope.inputText = '';
  $scope.room_id = $stateParams.room_id;
  $scope.canLoadMessages = true;
  $scope.data = {
    messages: [],
    from: 0
  };
  $scope.emoticons = [
    "😃", "🐻", "🍔", "⚽", "🌇", "💡", "🔣", "🎌", "💌",
    "😀", "😁", "😂", "😃", "😄", "😅", "😆", "😉", "😊", "😋",
    "😎", "😍", "😘", "😗", "😙", "😚", "😐", "😑", "😶", "😏",
    "😣", "😥", "😮", "😯", "😪", "😫", "😴"];
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
    });

    $('#emoticon').popover({
      html : true,
      content: function() {
        var content = $(this).attr("data-popover-content");
        return $(content).children(".popover-body").html();
      },
      title: function() {
        var title = $(this).attr("data-popover-content");
        return $(title).children(".popover-heading").html();
      }
    });

    $(document).on('click', '.icon', function () {
      $scope.inputText += $(this).text();
    });
  }

  /**
   * Get room info
   */
  function getRoomInfo() {
    Room.show($scope.room_id).then(function (response) {
      $scope.room = response.data.data;
      getMyTasks();
      loadMoreMessages($scope.data.from, scrollBox);
    });
  }

  function getMyTasks() {
    Task.index($scope.room).then(function(res){
      $scope.my_tasks = res.data.data;
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
      $scope.data.messages.push(response.notify.message);
      $scope.data.messages = _.sortBy($scope.data.messages, ['id']);
      scrollBox();
      Message.show($scope.room, response.notify.message).then(function (res) {
        $scope.data.messages[_.findIndex($scope.data.messages, {id: res.data.data.id})] = res.data.data;
      });
    }
    else if (response.notify.type === 'update_room_info') {
      getRoomInfo();
    }
    else if (response.notify.type === 'destroy_message') {
      _.remove($scope.data.messages, {id: response.notify.message.id})
    }
    else if (response.notify.type === 'new_task') {
      getMyTasks();
    }
  };

  function newMessage() {
    $scope.inputText = $.trim($scope.inputText);
    if($scope.inputText.length > 0){
      Message.create($scope.room, {raw_content: $scope.inputText})
        .then(function (data) {
          $scope.inputText = '';
        });
    }
  }

  consumer.subscribe(callback).then(function () {

    init();

    $('textarea').keydown(function (event) {
      if (event.keyCode === 13) {
        event.preventDefault();
        newMessage();
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

  $scope.delete = function (message) {
    Message.destroy($scope.room, message).then(function (response) {
      if (response.status === 200){
        toastr.success(response.data.message);
      }
      else {
        toastr.error(response.data.message);
      }
    });
  };

  $scope.send = function () {
    newMessage();
  };

  $scope.newLine = function () {
    $scope.inputText += '\n';
    $('textarea').focus();
  };

  function update_is_read(id) {
    $scope.data.messages[_.findIndex($scope.data.messages, {id: id})].replies = [];
    $scope.data.messages[_.findIndex($scope.data.messages, {id: id})].mentions = [];
  }
  $scope.isRead = function (message) {
    if(message.replies.length + message.mentions.length > 0){
      message.replies.map(function (reply) {
        Reply.update(reply).then(function (response) {
          update_is_read(reply.message_id);
        });
      });
      message.mentions.map(function (mention) {
        Mention.update(mention).then(function (response) {
          update_is_read(mention.message_id);
        });
      });
    }
  };

  $scope.updateUserRoom = function () {
    UserRoom.update($scope.room);
  };

  $scope.addTask = function () {
    ModalService.showModal({
      templateUrl: 'templates/newtask.html',
      controller: 'NewTaskController',
      inputs: {
        room: $scope.room
      }
    }).then(function (modal) {
      modal.element.modal();
      modal.close.then(function(result) {
        $('.modal').remove();
        $('.modal-backdrop').remove();
      });
    });
  };
  
  $scope.finishedTask = function (task) {
    Task.done(task).then(function (res) {
      _.remove($scope.my_tasks, {id: task.id})
    });
  };
});
