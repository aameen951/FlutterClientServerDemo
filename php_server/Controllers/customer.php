<?php

router_register(POST, 'customer/create', [], function($ctx){
  $name = $ctx->get('name');
  $mobile = $ctx->get('mobile');

  return JsonOk([
    'id'=>"".rand(),
    'name'=>$name,
    'mobile'=>$mobile,
  ]);
});

router_register(GET, 'customers', [], function($ctx){
  return JsonOk([
    ['id'=>"".rand(),'name'=>"A",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"B",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"C",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"D",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"E",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"F",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"G",'mobile'=>"0123"],
    ['id'=>"".rand(),'name'=>"H",'mobile'=>"0123"],
  ]);
});
