creditsnum = 1000
questionnum_max = 1000

(1..creditsnum).each do |idx|
  begin
    provider_rand = rand(2)
    u = Credit.create(
      username: "user_#{idx}",
      provider: provider_rand == 0 ? "facebook" : "twitter",
      email: "user_#{idx}@gmail.com",
      question_number: rand(1000)
    )
  rescue Exception=>e
    p e.inspect
  end

end
