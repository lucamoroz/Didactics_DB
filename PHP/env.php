<?php
    $host        = "host = localhost";
    $port        = "port = 5432";
    $dbname      = "dbname = postgres";
    $credentials = "user = postgres password=...";
    $GLOBALS['connection_string'] = "$host $port $dbname $credentials connect_timeout=5";
?>
