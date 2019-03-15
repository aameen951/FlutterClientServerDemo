<?php

function mdl_session_create($user)
{
  $token = random_bytes(64);
  $data = [
    'token'=>hash('sha512', $token, false),
    'user'=>$user['id'],
  ];
  db_insert('sessions', $data);
  return base64_encode($token);
}
function mdl_session_lookup($token)
{

}
function mdl_session_delete($token)
{
  db_delete('sessions', "`token` = '".db_esc($token)."'");
}
