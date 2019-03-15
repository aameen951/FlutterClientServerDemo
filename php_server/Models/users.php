<?php

function mdl_user_get_by_email($email)
{
  $users = db_select('users', "`email` = '".db_esc($email)."'");
  if(count($users))return $users[0];
  return null;
}

function mdl_user_create($email, $password)
{
  $hashed_password = password_hash($password, PASSWORD_DEFAULT);
  $id = db_insert('users', [
    'email'=>$email, 
    'password'=>$hashed_password,
  ]);
  return $id;
}
function mdl_user_verify_password($user, $password)
{
  return !password_verify($password, $user['password']);
}
