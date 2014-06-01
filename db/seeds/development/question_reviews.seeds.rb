question_num = 100
(1..question_num).each do |idx|
  tag_id = rand(Tag.count)+1
  begin
    level = (idx % Question::LEVELNUM) + 1
    time = rand(Question::TIMERANGE.end) + 1

    q = QuestionReview.new(
          content: "##Test Question Num #{idx}",
          tag_id: tag_id,
          level: level,
          time: time,
          url: 'http://www.google.com'
    )

    ans = AnswerReview.create(content: "Right", flag: 1)
    raise Exception, ans.errors.messages unless ans.errors.empty?
    q.answer_reviews << ans

    (1..3).each do |idx2|
      ans = AnswerReview.create(content: "Wrong", flag: 0)
      raise Exception, ans.errors.messages unless ans.errors.empty?
      q.answer_reviews << ans
    end
    q.answer_reviews.shuffle!
    q.save
    raise Exception, q.errors.messages unless q.errors.empty?
  rescue Exception => e
    p e.inspect
  end
end
