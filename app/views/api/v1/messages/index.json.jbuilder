json.total @messages.count
json.per_page Settings.msg_limit
if @messages.count > 0
  json.from @messages.last.id
else
  json.from 0
end
json.data @messages.as_json include: :user
