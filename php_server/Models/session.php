<?php

function _mdl_session_hash_token($token)
{
  return hash('sha512', base64_decode($token), false);
}
function mdl_session_create($user)
{
  $token = base64_encode(random_bytes(64));
  $data = [
    'token'=>_mdl_session_hash_token($token),
    'user'=>$user['id'],
  ];
  db_insert('sessions', $data);
  return $token;
}
function mdl_session_lookup($token)
{
  $hashed_token = _mdl_session_hash_token($token);
  $sessions = db_select('sessions', "`token` = '".db_esc($hashed_token)."'");
  if(count($sessions) === 0)return null;
  $session = $sessions[0];
  $user = mdl_user_get($session['user']);
  return [
    'token'=>$hashed_token,
    'user'=>$user['id'],
  ];
}
function mdl_session_delete($token)
{
  db_delete('sessions', "`token` = '".db_esc($token)."'");
}
