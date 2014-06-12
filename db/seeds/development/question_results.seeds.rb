MAXLOOP = 100000

(1..MAXLOOP).each do |index|
  users = User.scoped.select(:id)
  rand_u = User.find( users.first( Random.rand( users.length )).last )
  questions = Question.scoped.select(:id)
  rand_q = Question.find( users.first( Random.rand( questions.length )).last )
  rand_result = rand(2)

  QuestionResult.create do |qr|
    qr.question_id  = rand_q.id
    qr.user_id      = rand_u.id
    qr.tag_id       = rand_q.tag_id
    qr.level        = rand_q.level
    qr.result       = rand_result == 0 ? "false" : "true"
  end
end
