<?php
    //include db connection data
    include 'env.php';

    //show errors (disable in production)
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $conn=pg_connect($GLOBALS['connection_string']) or die('Could not connect: ' . pg_last_error());

    function getCorsiLaurea() {

        $sql = "SELECT * FROM corso_laurea";
        $result = pg_prepare($conn, "querypercorso", $sql);
        $result = pg_execute($conn, "querypercorso", array($year, $course));

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
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>Didattica UniPD</title>

  <!-- Bootstrap core CSS -->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="css/simple-sidebar.css" rel="stylesheet">

</head>

<body>

  <div class="d-flex" id="wrapper">

    <!-- Sidebar -->
    <div class="bg-light border-right" id="sidebar-wrapper">
      <div class="sidebar-heading">Menu </div>
      <div class="list-group list-group-flush">
        <a href="percorso.php" class="list-group-item list-group-item-action bg-light">Percorso</a>
        <a href="#" class="list-group-item list-group-item-action bg-light">Query2</a>
        <a href="#" class="list-group-item list-group-item-action bg-light">Query3</a>
      </div>
    </div>
    <!-- /#sidebar-wrapper -->

    <!-- Page Content -->
    <div id="page-content-wrapper">

      <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
        <button class="btn btn-primary" id="menu-toggle">Toggle Menu</button>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
            <li class="nav-item active">
              <a class="nav-link" href="index.html">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="https://github.com/lucamoroz/Didactics_DB">Github</a>
            </li>
          </ul>
        </div>
      </nav>

      <div class="container-fluid">

          <?php printCorsiLaurea() ?>

      </div>
    </div>
    <!-- /#page-content-wrapper -->

  </div>
  <!-- /#wrapper -->

  <!-- Bootstrap core JavaScript -->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Menu Toggle Script -->
  <script>
    $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
    });
  </script>

</body>

</html>
