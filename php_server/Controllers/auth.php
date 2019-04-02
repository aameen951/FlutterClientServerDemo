<?php

define_str('USR_ERR_AUTH_INCORRECT_EMAIL_PASSWORD');
define_str('USR_ERR_AUTH_EMAIL_USED');
define_str('ERR_AUTH_UNAUTHORIZED');
define_str('ERR_AUTH_BAD_AUTH_HEADER');


router_register(POST, 'auth/register', [], function($ctx){
  $email = $ctx->get('email');
  $password = $ctx->get('password');

  if(mdl_user_get_by_email($email))
  {
    return JsonFormError(USR_ERR_AUTH_EMAIL_USED);
  }

  $id = mdl_user_create($email, $password);
  
  return JsonOk(['user_id'=>$id]);
});

router_register(GET, 'auth/user-status', ['require_auth'=>true], function($ctx){
  $user_id = $ctx->session['user'];

  $user = mdl_user_get($user_id);

  return JsonOk([
    'email'=>$user['email'],
  ]);
});

router_register(POST, 'auth/login', [], function($ctx){
  $email = $ctx->get('email');
  $password = $ctx->get('password');

  $user = mdl_user_get_by_email($email);
  if(!$user)return JsonFormError(USR_ERR_AUTH_INCORRECT_EMAIL_PASSWORD);

  if(!mdl_user_verify_password($user, $password))
  {
    return JsonFormError(USR_ERR_AUTH_INCORRECT_EMAIL_PASSWORD);
  }

  $token = mdl_session_create($user);

  return JsonOk(['token'=>$token]);
});

router_register(POST, 'auth/logout', ['require_auth'=>true], function($ctx){
  
  mdl_session_delete($ctx->session['token']);

  return JsonOk();
});

function auth_request_handler(RequestCtx $ctx, $opt)
{
  $opt = array_merge(['require_auth'=>false], $opt);
  
  $ctx->session = null;
  $auth_header = $ctx->get_header('Authorization');
  if($auth_header)
  {
    $matches = [];
    if(preg_match('/^[Bb]earer\s+(.*?)\s*$/', $auth_header, $matches) === 1)
    {
      $token = $matches[1];
      $ctx->session = mdl_session_lookup($token);
    }
    else
    {
      json_error(400, ERR_AUTH_BAD_AUTH_HEADER);
    }
  }
  if($opt['require_auth'] && !$ctx->session)
  {
    json_error(401, ERR_AUTH_UNAUTHORIZED);
  }
}
