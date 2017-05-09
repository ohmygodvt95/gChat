if @msg
  json.message
else
  json.message @message.as_json include: :user
end
