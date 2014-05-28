puqiz
=====

#API spec
##User create
  Endpoint: **host/users**
  
  Must have params: [name] + [provider]<twitter|facebook> + [uuid]
  
  Return:
  ```
    {
      status: success | failed
      data:
      {id, name, provider, token}
    }
  ```

##User authenticate
  Must have params: [uid] <user id, got at first time request>, [token] <user token>
##Question list
  Endpoint: **host/api/questions**

  Must have params: [uid] + [token] + [tag_id]

  Option params: [offset]

  Returns:
  ```
    {
      status: success | failed
      data:
        Questions{id, level, tag_id, time, content + Answers : [{id, content, result}..]}
    }
  ```

##Tag list
  Endpoint: **host/api/tags**

  Must have params: [uid] + [token]

  Returns:
  ```
    {
      status: success | failed
      data:
        Tags {id, content}
    }
  ```

##Question view render
  Endpoint: GET *host/api/questions*

  Must have params [id] <question id> + [uid] + [token]

  ```
    host/point/question/:id&uid=xxx&token=yyy
  ```

  Return: Rendered html page

##Make question
  Endpoint: POST *host/api/questions*

  Must have params [id] [uid] + [token]

  Another: post params as below:
  
  ```
  "question"=>
    { "content"=>"sadadsad", 
      "tag_id"=>"1", 
      "time"=>"5", 
      "url"=>"http://www.google.com", 
      "level"=>"1", 
      "answers_attributes"=>
        { "0"=>{"content"=>"sadasd"}, 
          "1"=>{"content"=>"sadad", "flag"=>"1"}, 
          "2"=>{"content"=>"sadsadasd"}, 
          "3"=>{"content"=>"dasdad"}}}

  //note that flag of answers can be nothing or 0
  ```
  
##Analytic
  Endpoint: POST *host/api/analytic/ranking*
  
  Must have params [id] [uid] [tag_id]
  
  Option params [offset] [limit]
  
  ```
  [{"id"=>1188, "name"=>"user_1181", "provider"=>"twitter"},
 {"id"=>2919, "name"=>"user_2912", "provider"=>"twitter"},
 {"id"=>5147, "name"=>"user_5140", "provider"=>"twitter"},
 {"id"=>9719, "name"=>"user_9712", "provider"=>"twitter"}]
  ```
