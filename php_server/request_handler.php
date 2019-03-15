<?php

require_once "initialize.php";

require_once_dir('Models');
require_once_dir('Controllers');


router_register_request_handler('auth_request_handler');

router_dispatch();
