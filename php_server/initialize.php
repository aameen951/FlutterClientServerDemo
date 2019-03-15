<?php

// ****************************************
// NOTE(ameen): START OF USER CONFIGURATION

define('URL_PREFIX', "fcsd");

define('DB_USERNAME', "phpuser");
define('DB_PASSWORD', "phppassword");
define('DB_DATABASE_NAME', "fcsd");

// NOTE(ameen):   END OF USER CONFIGURATION
// ****************************************

// NOTE(ameen): HTTP Request code

define('METHOD', strtoupper($_SERVER['REQUEST_METHOD']));
$route = trim($_SERVER['REQUEST_URI'], '/');
if(stripos($route."/", URL_PREFIX."/") === 0)$route = trim(substr($route, strlen(URL_PREFIX)), '/');

define('ROUTE', $route);

function _json_output($code, $status, $body)
{
  http_response_code($code);
  header("Content-Type: application/json");
  echo json_encode(['status'=>$status, 'body'=>$body]);
  die;
}
function json_error($code, $error_name, $error_message = null, $details=null)
{
  $error = ['name'=>$error_name];
  if($error_message)$error['message'] = $error_message;
  if($details)$error['details'] = $details;
  _json_output($code, 'error', $error);
}

$orig_request_headers = apache_request_headers();
$request_headers = [];
foreach($orig_request_headers as $header_name => $header_value)
{
  $request_headers[strtolower($header_name)] = $header_value;
}
function has_header($name)
{
  global $request_headers;
  $name = strtolower($name);
  return isset($request_headers[$name]);
}
function get_header($name, $default = null)
{
  global $request_headers;
  if(has_header($name))return $request_headers[strtolower($name)];
  return $default;
}
$request_data = file_get_contents('php://input');
if(get_header('Content-Type') !== 'application/json')
{
  json_error(400, "UNSUPPORTED_REQUEST_FORMAT", "Request payload must have JSON format");
}
$request_data = json_decode($request_data, true);
if(json_last_error() !== JSON_ERROR_NONE)
{
  json_error(400, "BAD_REQUEST_FORMAT", "Request payload is not a valid JSON format");
}

function get_request_data()
{
  global $request_data;
  return $request_data;
}

define('GET', 'GET');
define('POST', 'POST');
define('PUT', 'PUT');
define('PATCH', 'PATCH');
define('DELETE', 'DELETE');
if(METHOD !== GET && METHOD !== POST && METHOD !== PUT && METHOD !== DELETE && METHOD !== PATCH)
{
  json_error(400, "HTTP_BAD_METHOD");
}

class ApiRes
{
  public $is_ok;
  public $data;
  public function __construct($is_ok, $data)
  {
    $this->is_ok = $is_ok;
    $this->data = $data;
  }
}
function api_ok($data = null)
{
  return new ApiRes(true, $data);
}
function api_err($data)
{
  return new ApiRes(false, $data);
}

// NOTE(ameen): Database code
$connection = @mysqli_connect(null, DB_USERNAME, DB_PASSWORD);
$error_msg = @mysqli_connect_error(); 
if($error_msg !== null)
{
  $error_num = @mysqli_connect_errno(); 
  json_error(500, "DB_CONNECTION_ERROR", "Cannot connect to the database: (Code:$error_num) $error_msg");
}
$charset = 'utf8';
if(!mysqli_set_charset($connection, $charset))
{
  json_error(500, "DB_CONNECTION_ERROR", "Cannot set the character set of the connection to '$charset'");
}
$time_zone = '+00:00';
if(mysqli_query($connection, "SET @@session.time_zone = \"$time_zone\";") !== true)
{
  json_error(500, "DB_CONNECTION_ERROR", "Cannot set the time zone of the connection to '$time_zone'");
}
$db_name = DB_DATABASE_NAME;
if(!mysqli_select_db($connection, $db_name))
{
  json_error(500, "DB_CONNECTION_ERROR", "Database '$db_name' doesn't exist");
}


function db_query($sql)
{
  global $connection;
  $c = $connection;

  $res = mysqli_query($c, $sql);

  $data = null;
  if($res === true) ;// nothing to do
  elseif($res instanceof mysqli_result)
  {
    $data = [];
    while($row = mysqli_fetch_assoc($res))
    {
      $data[] = $row;
    }         
    mysqli_free_result($res);   
  }
  elseif($res === FALSE)
  {
    json_error(500, "DB_QUERY_ERROR", "Query failed: $sql");
  }
  else
  {
    json_error(500, "DB_QUERY_ERROR", "Query returned unknown value: ".var_export($res, true));
  }
  return $data;
}
function db_esc($text)
{
  global $connection;
  return mysqli_real_escape_string($connection, $text);
}
function db_insert($table, $data)
{
  $cols = [];
  $values = [];
  foreach($data as $col => $val)
  {
    $cols[] = "`$col`";
    $values[] = '"'.db_esc($val).'"';
  }
  $cols = implode(', ', $cols);
  $values = implode(', ', $values);
  $q = "INSERT INTO `$table` ($cols) VALUES ($values);";
  db_query($q);
  global $connection;
  return mysqli_insert_id($connection);
}
function db_select($table, $where)
{
  $q = "SELECT * FROM `$table`";
  if($where) $q .= " WHERE $where";
  $q .= ";";
  $result = db_query($q);
  return $result;
}
function db_delete($table, $where)
{
  $q = "DELETE FROM `$table` WHERE $where;";
  db_query($q);
}

define('PATH_SEP', PHP_OS === 'WINNT' ? '\\' : '/');
function path_join($a, ...$b)
{
  $result = $a;
  foreach($b as $node)
  {
    $result = rtrim($result, '\\/') . PATH_SEP . ltrim($node, '\\/');
  }
  return $result;
}
function require_once_dir($dir)
{
  $dir_files = glob(path_join($dir, '*.php'));
  foreach($dir_files as $file)
  {
    require_once $file;
  }
}

// NOTE(ameen): Router code
$route_table = [
  GET=>[],
  POST=>[],
  PUT=>[],
  PATCH=>[],
  DELETE=>[],
];
function router_register($method, $route, $func)
{
  global $route_table;
  $route_table[$method][$route] = $func;
}
function router_dispatch()
{
  global $route_table;
  $method = METHOD;
  $route = ROUTE;
  if(isset($route_table[$method][$route]))
  {
    $data = get_request_data();
    $result_obj = $route_table[$method][$route]($data);
    if(!($result_obj instanceof ApiRes))
    {
      json_error(500, "BAD_RETURN_VALUE_FROM_CONTROLLER", "Controller '$method:$route' didn't return the result using api_ok/api_err");
    }
    if($result_obj->is_ok)
    {
      _json_output(200, 'ok', $result_obj->data);
    }
    else
    {
      _json_output(200, 'api_error', $result_obj->data);
    }
  }
  else
  {
    json_error(404, "HTTP_NOT_FOUND");
  }
}
