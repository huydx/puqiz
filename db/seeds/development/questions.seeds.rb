question_num = 10

(1..question_num).each do |idx|
  begin
    level = rand(Question::LEVELNUM) + 1
    time = Question::TIMERANGE[rand(Question::TIMERANGE.length)]

    q = Question.new(
          content: "Test Question Num #{idx}",
          tag_id: Tag.find_by_content("Python").id,
          level: level,
          time: time,
          url: 'http://www.google.com'
    )

    (1..3).each do |idx2|
      flag = rand(2)
      ans = Answer.create(content: "Test Ans #{idx2}", flag: flag)
      raise Exception, ans.errors.messages unless ans.errors.empty?
      q.answers << ans
    end
    q.save
    raise Exception, q.errors.messages unless q.errors.empty?
  rescue Exception => e
    p e.inspect
  end
end
