question_num = 500

(1..question_num).each do |idx|
  begin
    level = (idx % Question::LEVELNUM) + 1
    time = Question::TIMERANGE[rand(Question::TIMERANGE.length)]

    q = Question.new(
          content: "##Test Question Num #{idx}",
          tag_id: Tag.find_by_content("Python").id,
          level: level,
          time: time,
          url: 'http://www.google.com'
    )

    ans = Answer.create(content: "Right", flag: 1)
    raise Exception, ans.errors.messages unless ans.errors.empty?
    q.answers << ans

    (1..3).each do |idx2|
      ans = Answer.create(content: "Wrong", flag: 0)
      raise Exception, ans.errors.messages unless ans.errors.empty?
      q.answers << ans
    end
    q.answers.shuffle!
    q.save
    raise Exception, q.errors.messages unless q.errors.empty?
  rescue Exception => e
    p e.inspect
  end
end
