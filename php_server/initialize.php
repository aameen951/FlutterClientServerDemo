<?php

require_once "config.php";

// NOTE(ameen): Helpers
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
function define_str($str)
{
  define($str, $str);
}

// NOTE(ameen): HTTP Request/Response code
function _json_output($code, $type, $body)
{
  http_response_code($code);
  header("Content-Type: application/json");
  echo json_encode(['type'=>$type, 'body'=>$body]);
  die;
}
function bad_request($code, $error_name, $error_message)
{
  _json_output($code, 'bad_request', [
    'name'=>$error_name,
    'message'=>$error_message,
  ]);
}
function fatal_error($error_name, $error_message)
{
  _json_output(500, 'server_error', [
    'name'=>$error_name,
    'message'=>$error_message,
  ]);
}
function custom_response($code, $type, $data = null)
{
  _json_output($code, $type, $data);
}

class JsonRes
{
  public $type;
  public $data;
  public function __construct($type, $data)
  {
    $this->type = $type;
    $this->data = $data;
  }
}
function JsonOk($data = null)
{
  return new JsonRes('ok', $data);
}
function JsonFormError(string $error_name, $error_params=null)
{
  return new JsonRes('form_error', ['name'=>$error_name, 'params'=>$error_params]);
}
class RequestCtx
{
  private $data;
  private $headers;
  public function __construct($headers)
  {
    $this->data = null;
    $this->headers = $headers;
  }
  public function set_data($data){
    $this->data = $data;
  }
  public function get($name)
  {
    if(!array_key_exists($name, $this->data))return null;
    return $this->data[$name];
  }
  public function has_header($name)
  {
    $name = strtolower($name);
    return isset($this->headers[$name]);
  }
  public function get_header($name)
  {
    if(!$this->has_header($name))return null;
    return $this->headers[strtolower($name)];
  }
}

// NOTE(ameen): Database code
$connection = @mysqli_connect(null, DB_USERNAME, DB_PASSWORD);
$error_msg = @mysqli_connect_error(); 
if($error_msg !== null)
{
  $error_num = @mysqli_connect_errno(); 
  fatal_error("DB_CONNECTION_ERROR", "Cannot connect to the database: (Code:$error_num) $error_msg");
}
$charset = 'utf8';
if(!mysqli_set_charset($connection, $charset))
{
  fatal_error("DB_CONNECTION_ERROR", "Cannot set the character set of the connection to '$charset'");
}
$time_zone = '+00:00';
if(mysqli_query($connection, "SET @@session.time_zone = \"$time_zone\";") !== true)
{
  fatal_error("DB_CONNECTION_ERROR", "Cannot set the time zone of the connection to '$time_zone'");
}
$db_name = DB_DATABASE_NAME;
if(!mysqli_select_db($connection, $db_name))
{
  fatal_error("DB_CONNECTION_ERROR", "Database '$db_name' doesn't exist");
}


function db_query($sql)
{
  global $connection;
  $c = $connection;

  $res = mysqli_query($c, $sql);

  $data = null;
  if($res === true) /* nothing to do */;
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
    fatal_error("DB_QUERY_ERROR", "Query failed: $sql");
  }
  else
  {
    fatal_error("DB_QUERY_ERROR", "Query returned unknown value: ".var_export($res, true));
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


// NOTE(ameen): Router code
define('GET', 'GET');
define('POST', 'POST');
define('PUT', 'PUT');
define('PATCH', 'PATCH');
define('DELETE', 'DELETE');

$router_table = [
  GET=>[],
  POST=>[],
  PUT=>[],
  PATCH=>[],
  DELETE=>[],
];
$router_request_handlers = [];
function router_register($method, $route, $opt, $func)
{
  global $router_table;
  $router_table[$method][$route] = ['cb'=>$func, 'opt'=>$opt];
}
function router_register_request_handler($handler_cb)
{
  global $router_request_handlers;
  $router_request_handlers[] = $handler_cb;
}
function router_dispatch()
{
  global $router_table;
  global $router_request_handlers;

  $method = strtoupper($_SERVER['REQUEST_METHOD']);
  $route = trim($_SERVER['REQUEST_URI'], '/');
  if(stripos($route."/", URL_PREFIX."/") === 0)
  {
    $route = trim(substr($route, strlen(URL_PREFIX)), '/');
  }

  if(!isset($router_table[$method]))
  {
    bad_request(405, "HTTP_METHOD_NOT_ALLOWED", "Method [$method] is not allowed");
  }
  
  $request_headers = [];
  foreach(apache_request_headers() as $header_name => $header_value)
  {
    $request_headers[strtolower($header_name)] = $header_value;
  }

  $ctx = new RequestCtx($request_headers);

  $request_data = file_get_contents('php://input');
  if($ctx->get_header('Content-Type') !== 'application/json')
  {
    bad_request(400, "UNSUPPORTED_REQUEST_FORMAT", "Request body must have JSON format");
  }
  if(trim($request_data))
  {
    $request_data = json_decode($request_data, true);
    if(json_last_error() !== JSON_ERROR_NONE)
    {
      bad_request(400, "BAD_REQUEST_FORMAT", "Request body is not a valid JSON format");
    }
  }

  $ctx->set_data($request_data);

  if(isset($router_table[$method][$route]))
  {
    $route_data = $router_table[$method][$route];

    foreach($router_request_handlers as $handler_cb)
    {
      $handler_cb($ctx, $route_data['opt']);
    }
  
    $result_obj = $route_data['cb']($ctx);
    if(!($result_obj instanceof JsonRes))
    {
      fatal_error("BAD_RETURN_VALUE_FROM_CONTROLLER", "Controller [$method:$route] didn't return the result using JsonOk/JsonFormError/...");
    }

    custom_response(200, $result_obj->type, $result_obj->data);
  }
  else
  {
    bad_request(404, "HTTP_NOT_FOUND", "Route [$method:$route] was not found");
  }
}
