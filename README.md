puqiz
=====

#API spec
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
