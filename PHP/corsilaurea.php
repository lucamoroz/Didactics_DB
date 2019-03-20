<?php
    //include db connection data
    include 'env.php';

    //show errors (disable in production)
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    $conn=pg_connect($GLOBALS['connection_string']) or die('Could not connect: ' . pg_last_error());

    function get_schools_form($conn) {
      /**
      @return String: a 'select' form, each option has 'codice' as value and 'nome' as text
      */
      $ret = pg_query($conn, "SELECT codice, nome FROM scuola;");
    
      $year_form = "<select class='form-control' name='school'>";
      while($row = pg_fetch_assoc($ret)) {
        $year_form .= "<option value={$row['codice']}>{$row['nome']}</option>";
      }
      $year_form .= "</select>";
      
      return $year_form;
    }

    function get_tipicorsi_form() {
      $tipi =  array('LT'=>'Laurea triennale', 
                    'LM'=>'Laurea magistrale', 
                    'CU'=>'Laurea magistrale a ciclo unico');
      $select_html = "<select class='form-control' name='type'>";
      foreach($tipi as $codice => $nome) {
        $select_html .= "<option value=$codice>$nome</option>";
      }
      $select_html .= "</select>";
      return $select_html;
    }

    function get_corsi_laurea($conn, $scuola, $tipo) {

        $sql = "SELECT * FROM corso_laurea AS C WHERE c.scuola = $1 AND c.tipo = $2;";
        $result = pg_prepare($conn, "querypercorso", $sql);
        $result = pg_execute($conn, "querypercorso", array($scuola, $tipo));

        $html_table = "<table class='table' style='width:90%'><thead class='thead-dark'><tr>
                <th>Codice</th>
                <th>Nome</th>
                <th>Ordinamento</th>
                <th>CFU</th>
              </tr></thead><tbody>";

        while($row = pg_fetch_assoc($result)) {
          $html_table .= "<tr>
                    <td>{$row['codice']}</td>
                    <td>{$row['nome']}</td>
                    <td>{$row['ordinamento']}</td>
                    <td>{$row['cfu']}</td></tr>";
        }
        $html_table .= "</tbody></table>";

        return $html_table;
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
          <h3> Corsi di laurea </h3>

          <form action="#" method="GET" enctype="multipart/form-data">
            <div class="form-row">
              <div class="form-group col-md-2">
                <?php
                echo get_schools_form($conn);
                ?>
              </div>
              <div class="form-group col-md-2">
                <?php
                  echo get_tipicorsi_form();
                ?>
              </div>
              <input type="submit" class="btn btn-primary" value="Submit">
            </div>
          </form>

          <hr>

          <?php
            //show result table if requested
            if($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET['school']) and isset($_GET['type'])) {
              echo get_corsi_laurea($conn, $_GET['school'], $_GET['type']);
            }
          ?>

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
