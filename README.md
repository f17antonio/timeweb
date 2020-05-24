timeweb
=====

Test task from the timeweb company


Rest API
-

- **POST /api/user/register - User registration**

> Request:
> ```sh
> {
>	"login": <string>,
>	"password": <string>,
>	"user_name": <string>
> }
> ```
	
> Success Response:
> ```sh
> {
>   "user_id": <integer>
> }
> ```
	
> Error Response:
> ```sh
> {
>	"error": {
>	   "code": <integer>,
>	   "description" <string>
>	 }
> }
> ```

> Example:
> ```sh
> curl -X POST -i http://localhost:8040/api/user/register -H "Content-Type: application/json" \
> -d '{"login":"user1","password":"foo", "username":"Mark"}'
>
> HTTP/1.1 200 OK
> content-length: 13
> content-type: application/json
> date: Sun, 24 May 2020 15:49:05 GMT
> server: Cowboy
>
> {"user_id":1}
> ```


- **POST /api/user/signin - User authentication**
> Request:
> ```sh
> {
>	"login": <string>,
>	"password": <string>
> }
> ```
	
> Success Response:
> ```sh
> {
>   "user": {
>     "user_name": <string>,
>     "user_id": <integer>,
>	  "login": <string>
>   },
>	"token": <string> - Token for Basic Auth!
> }
> ```
	
> Error Response:
> ```sh
> {
>	"error": {
>	   "code": <integer>
>	   "description" <string>
>	 }
> }
> ```

> Example:
> ```sh
> curl -X POST -i http://localhost:8040/api/user/signin -H "Content-Type: application/json" \
> -d '{"login":"user1","password":"foo"}'
>
> HTTP/1.1 200 OK
> content-length: 104
> content-type: application/json
> date: Sun, 24 May 2020 15:59:33 GMT
> server: Cowboy
>
> {"token":"f62c3527-f923-4185-8682-9373c43987ff","user":{"login":"user1","user_id":1,"user_name":"Mark"}}
> ```


- **POST /api/user/change_password - Change user password**

  **NOTE**: Basic auth requared: ```<login>:<token>```
  
> Request:
> ```sh
> {
>	"old_password": <string>,
>	"new_password": <string>
> }
> ```
	
> Success Response:
> ```sh
> {
>   "result": "changed"
> }
> ```
	
> Error Response:
> ```sh
> {
>	"error": {
>	   "code": <integer>,
>	   "description" <string>
>	 }
> }
> ```  
	
> Example:
> ```sh
> curl -X POST -i  http://localhost:8040/api/user/change_password -H "Content-Type: application/json" \
> -u "user1:f62c3527-f923-4185-8682-9373c43987ff" -d '{"old_password":"foo","new_password":"bar"}'
>
> HTTP/1.1 200 OK
> content-length: 20
> content-type: application/json
> date: Sun, 24 May 2020 16:12:56 GMT
> server: Cowboy
> 
> {"result":"changed"}
> ```


- **GET /api/users/list - List of all users**

  **NOTE**: Basic auth requared: ```<login>:<token>```
	
> Success Response:
> ```sh
> {
>   "users": [
>     {
>     "user_name": <string>,
>     "user_id": <integer>,
>	  "login": <string>
>     },
>    ....
>	]
> }
> ```
	
> Error Response:
> ```sh
> {
>	"error": {
>	   "code": <integer>
>	   "description" <string>
>	 }
> }
> ```  
	
> Example:
> ```sh
> curl -X GET -i  http://localhost:8040/api/users/list -H "Content-Type: application/json" \ 
> -u "user1:f62c3527-f923-4185-8682-9373c43987ff"
>
> HTTP/1.1 200 OK
> content-length: 60
> content-type: application/json
> date: Sun, 24 May 2020 16:19:32 GMT
> server: Cowboy
>
> {"users":[{"login":"user1","user_id":1,"user_name":"Mark"}]}

Before started:
-
Please change mysql connection and cowboy port settings in config/sys.config file

Mysql username and password should be mysql SuperUser name and mysql SuperUser password respectively.

Start application:
-
```sh
$ make start
```	

Stop application:
-
```sh
$ make stop
```	
Сomponent requirements:
-
 - Erlang/OTP >= 20.2
 - Mysql server >= 5.7
