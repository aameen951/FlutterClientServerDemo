<?php

function mdl_customer_get($customer_id)
{
  $customer = db_select('customers', "`id` = '".db_esc($customer_id)."'");
  if(count($customer))return $customer[0];
  return null;
}
function mdl_customer_get_all()
{
  $customers = db_select('customers');
  return $customers;
}

function mdl_customer_create($name, $mobile)
{
  $id = db_insert('customers', [
    'name'=>$name, 
    'mobile'=>$mobile,
  ]);
  return $id;
}
