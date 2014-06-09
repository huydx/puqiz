puqiz
=====

#API spec
##User create
  Endpoint: POST **host/users**
  
  Must have params: [name] + [provider]<twitter|facebook> + [uuid]

  Option params: [avatar]
  
  Return:
  ```
    {
      status: true | false
      data:
      {id, name, provider, token}
    }
  ```

##User authenticate
  Must have params: [uid] <user id, got at first time request>, [token] <user token>
##Question list
  Endpoint: GET **host/api/questions**

  Must have params: [uid] + [token] + [tag_id]

  Option params: [offset]

  Returns:
  ```
    {
      status: true | false
      data:
        Questions{id, level, tag_id, time, content + Answers : [{id, content, result}..]}
    }
  ```
  
##Question recently update
  Endpoint: GET **host/api/questions/check_update**
  
  Must have params: [uid] + [token] + [tag_id] + [date]
  
  Returns:
  ```
  {
    status: true | false
    data: 
      is_update: true | false
  }
  
  ```

##Tag list
  Endpoint: GET **host/api/tags**

  Must have params: [uid] + [token] + [date]

  Returns:
  ```
    {
      status: true | false
      data: [
        Tags {id, content, full_image_path}
      ]
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
  Endpoint: GET *host/api/analytic/ranking*
  
  Must have params [id] [uid] [tag_id]
  
  Option params [offset] [limit]
  
  ```
  [{"id"=>1188, "name"=>"user_1181", "provider"=>"twitter", "avatar"=> "xxx", "accumulate_point" => 1234},
 {"id"=>2919, "name"=>"user_2912", "provider"=>"twitter", "avatar"=> "xxx", "accumulate_point" => 1234},
 {"id"=>5147, "name"=>"user_5140", "provider"=>"twitter", "avatar"=> "xxx", "accumulate_point" => 1234},
 {"id"=>9719, "name"=>"user_9712", "provider"=>"twitter", "avatar"=> "xxx", "accumulate_point" => 1234}]
  ```
