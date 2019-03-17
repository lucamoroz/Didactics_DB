<?php
    include 'env.php';

    //show errors (disable in production)
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    function printCorsiLaurea() {
        //database connection
        $db = pg_connect($GLOBALS['connection_string']);
        if(!$db) {
            echo "Error : Unable to open database\n";
            return;
        } 

        $sql = "SELECT * FROM corso_laurea";
        $ret = pg_query($db, $sql);
        if(!$ret) echo pg_last_error($db);

        //start print
        echo '<ul>';
        while($row = pg_fetch_assoc($ret)) {
            echo '<li>';
            echo 'Codice corso: '. $row['codice'] . ' ';
            echo 'Scuola: '. $row['scuola'] . ' ';
            echo 'Ordinamento: '. $row['ordinamento'] . ' ';
            echo 'CFU: '. $row['cfu'] . ' ';
            echo 'Tipologia di corso: '. $row['tipo'] . ' ';
            echo '</li>';
        }
        echo '</ul>';
        pg_close($db);
    }
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Database corsi di laurea</title>
</head>

<body>
<h1> Elenco corsi di laurea </h1>

<?php printCorsiLaurea() ?>

</body>

</html>
