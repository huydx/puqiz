user_num = 10000
max_accumulate_point = 100000

(1..user_num).each do |idx|
  begin
    provider_rand = rand(2)
    tag_id = rand(Tag.count)+1
    u = User.create(
      name: "user_#{idx}",
      provider: provider_rand == 0 ? "facebook" : "twitter",
      uuid: SecureRandom.hex(10)
    )
    deg = Degree.find_by_user_id_and_tag_id(u.id, tag_id)
    deg.accumulate_point = rand(max_accumulate_point)
    deg.save
    raise Exception, u.errors.messages unless u.errors.empty?
    raise Exception, deg.errors.messages unless deg.errors.empty?
  rescue Exception=>e
    p e.inspect
  end

end
