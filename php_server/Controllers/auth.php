<?php

define('ERR_AUTH_INCORRECT_EMAIL_PASSWORD', 'ERR_AUTH_INCORRECT_EMAIL_PASSWORD');
define('ERR_AUTH_EMAIL_USED', 'ERR_AUTH_EMAIL_USED');

router_register(POST, 'auth/register', function($data){
  $email = $data['email'];
  $password = $data['password'];

  if(mdl_user_get_by_email($email))
  {
    return api_err(ERR_AUTH_EMAIL_USED);
  }

  $id = mdl_user_create($email, $password);
  
  return api_ok(['user_id'=>$id]);
});

router_register(POST, 'auth/login', function($data){
  $email = $data['email'];
  $password = $data['password'];

  $user = mdl_user_get_by_email($email);
  if(!$user)return api_err(ERR_AUTH_INCORRECT_EMAIL_PASSWORD);

  if(!mdl_user_verify_password($user, $password))
  {
    return api_err(ERR_AUTH_INCORRECT_EMAIL_PASSWORD);
  }

  $token = mdl_session_create($user);

  return api_ok($token);
});

router_register(POST, 'auth/logout', function($data){
  $token = $data['email'];

  mdl_session_delete($token);

  return api_ok();
});
