if @room
  json.data @room.as_json user: current_user
end
