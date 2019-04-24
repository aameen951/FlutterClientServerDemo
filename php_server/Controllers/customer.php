<?php

router_register(POST, 'customer/create', [], function($ctx){
  $name = $ctx->get('name');
  $mobile = $ctx->get('mobile');

  $customer_id = mdl_customer_create($name, $mobile);

  return JsonOk(mdl_customer_get($customer_id));
});

router_register(GET, 'customers', [], function($ctx){

  $customers = mdl_customer_get_all();
  
  return JsonOk($customers);
});
