if @users
  json.total_pages @users.total_pages
  json.current_page @users.current_page
  json.next_page @users.next_page
  json.prev_page @users.prev_page
  json.total_count @users.total_count
else
  @users = []
  @relationship.each do |r|
    @users.push r.user_request
  end
  json.total_pages @relationship.total_pages
  json.current_page @relationship.current_page
  json.next_page @relationship.next_page
  json.prev_page @relationship.prev_page
  json.total_count @relationship.total_count
end
json.data @users
