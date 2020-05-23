-define(API_ERROR(Code, Descr), #{error => #{code => Code, description => Descr}}).

-define(ERROR_UNKNOW_ERROR_CODE, 2).
-define(ERROR_UNKNOW_ERROR_DESCR, <<"Unknown error :(">>).

-define(ERROR_INVALID_REQUEST_CODE, 3).
-define(ERROR_INVALID_REQUEST_DESCR, <<"Invalid request">>).

-define(ERROR_NOT_AUTHORIZED_CODE, 4).
-define(ERROR_NOT_AUTHORIZED_DESCR, <<"Not authorized">>).

-define(ERROR_INTERNAL_DB_ERROR_CODE, 5).
-define(ERROR_INTERNAL_DB_ERROR_DESCR, <<"Internal db error">>).

-define(ERROR_CANNOT_CREATE_USER_SESSION_CODE, 24).
-define(ERROR_CANNOT_CREATE_USER_SESSION_DESCR, <<"Can't loggin. Internal error">>).

-define(ERROR_CANNOT_REGISTER_CODE, 1001).
-define(ERROR_CANNOT_REGISTER_DESCR, <<"Can't register user">>).

-define(ERROR_USER_NOT_FOUND_CODE, 1002).
-define(ERROR_USER_NOT_FOUND_DESCR, <<"User not found">>).

-define(ERROR_WRONG_LOGIN_PASSWORD_CODE, 1003).
-define(ERROR_WRONG_LOGIN_PASSWORD_DESCR, <<"Wrong login or password">>).

-define(ERROR_CANNOT_CHANGE_SAME_PASSWORD_CODE, 1004).
-define(ERROR_CANNOT_CHANGE_SAME_PASSWORD_DESCR, <<"Can't change password.">>).

-define(ERROR_INVALID_OLD_PASSWORD_CODE, 1005).
-define(ERROR_INVALID_OLD_PASSWORD_DESCR, <<"Invalid old password.">>).
