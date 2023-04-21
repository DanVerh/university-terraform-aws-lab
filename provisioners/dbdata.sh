aws dynamodb put-item --table-name authors --item \ 
'{"id": {"S": "1"}, "firstName": {"S": "John"}, "lastName": {"S": "Johnson"}}' \
'{"id": {"S": "2"}, "firstName": {"S": "Jack"}, "lastName": {"S": "Jackson"}}' \
'{"id": {"S": "2"}, "firstName": {"S": "Carl"}, "lastName": {"S": "Carlson"}}' 