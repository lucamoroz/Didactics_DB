<?php
//include db connection data
include 'env.php';

//show errors (disable in production)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn=pg_connect($GLOBALS['connection_string']) or die('Could not connect: ' . pg_last_error());


function get_istanza_attivita_formativa($conn, $cod, $can, $year, $resp) {
	$result = pg_prepare($conn, 
            			"queryistanza", 
            			"SELECT af.nome as nome, iaf.canale as canale, iaf.anno_accademico as anno_accademico, CONCAT(d.nome, ' ', d.cognome) as responsabile, iaf.acquisire as acquisire, iaf.contenuti as contenuti, iaf.testi as testi
            			 FROM istanza_attivita_formativa as iaf JOIN attivita_formativa as af
            			 	ON iaf.attivita_formativa = af.codice
            			 	JOIN docente as d ON d.matricola = iaf.responsabile
            			 WHERE iaf.attivita_formativa = $1
            			 	AND iaf.canale = $2
            			 	AND iaf.anno_accademico = $3
            			 	AND iaf.responsabile = $4;");
	$result = pg_execute($conn, "queryistanza", array($cod, $can, $year, $resp));
	if($row = pg_fetch_assoc($result)) {
		return $row;
	} else {
		return array();
	}
	
}

/**
SELECT af.nome, iaf.canale, iaf.anno_accademico, iaf.responsabile
FROM istanza_attivita_formativa as iaf JOIN attivita_formativa as af
	ON iaf.attivita_formativa = af.codice
        WHERE iaf.attivita_formativa = 'IN10100190'
         AND iaf.canale = 2
         AND iaf.anno_accademico = 2015
         AND iaf.responsabile = '1139049';
         
SELECT af.nome, iaf.canale, iaf.anno_accademico, CONCAT(d.nome, ' ', d.cognome) as responsabile, iaf.acquisire, iaf.contenuti, iaf.testi
            			 FROM istanza_attivita_formativa as iaf JOIN attivita_formativa as af
            			 	ON iaf.attivita_formativa = af.codice
            			 	JOIN docente as d ON d.matricola = iaf.responsabile
            			 WHERE iaf.attivita_formativa = 'IN10100190'
            			 	AND iaf.canale = 2
            			 	AND iaf.anno_accademico = 2015
            			 	AND iaf.responsabile = '1139049';
*/
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
        <a href="percorso.php" class="list-group-item list-group-item-action bg-light">Offerta formativa</a>
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
              <a class="nav-link" href="index.php">Home <span class="sr-only"></span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="https://github.com/lucamoroz/Didactics_DB">Github</a>
            </li>
          </ul>
        </div>
      </nav>
	
	
	<!-- CONTENT -->
	<div class="container-fluid">
	<br><br>
	
	<?php
	//show result table if requested
	if($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET['attform']) and isset($_GET['canale']) and isset($_GET['annoacc']) and isset($_GET['resp'])) {
		$data_corso = get_istanza_attivita_formativa($conn, $_GET['attform'], $_GET['canale'], $_GET['annoacc'], $_GET['resp']);
		
		if(sizeof($data_corso)==0) {
			echo "Corso non trovato.";
			exit;
		}
		
		$html_table = "<table class='table' style='width:90%'>
				<thead class='thead-dark'><tr>
				  <th>Campo</th>
				  <th>Contenuto</th>
				</tr></thead><tbody>";
		foreach($data_corso as $key => $value) {
			//$html_table .= "<th>{$key}</th>";
			$html_table .= "<tr><td style='width: 30%'>{$key}</td><td style='width: 70%'>{$value}</td></tr>";
		}
		
		$html_table .= "</tbody></table>";
		echo $html_table;
		
	}
	?>

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





