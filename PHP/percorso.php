<?php
//include db connection data
include 'env.php';

//show errors (disable in production)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn=pg_connect($GLOBALS['connection_string']) or die('Could not connect: ' . pg_last_error());

function get_year_form($conn) {
	/**
	@return String: a 'select' form, each option has 'anno' as value and as text
	*/
	$years = array();
	//set field as selected if present
	$selected = (isset($_GET['year']) ? $_GET['year'] : "");

	$ret = pg_query($conn, "SELECT anno FROM coorte;");

	while($row = pg_fetch_row($ret)) {
		array_push($years, $row[0]);	
	}
	
	$year_form = "<select class='form-control' name='year'>";
	foreach($years as $year) {
		if ($selected == $year)
			$year_form .= "<option value='$year' selected>$year</option>";
		else
			$year_form .= "<option value='$year'>$year</option>";
	}
	$year_form .= "</select>";
	
	return $year_form;
}

function get_course_form($conn) {
	/**
	@return String: a 'select' form, each option has 'codice' as value and 'nome' as text
	*/	
	//set field as selected if present
	$selected = (isset($_GET['course']) ? $_GET['course'] : "");
	$result = pg_query($conn, "SELECT codice, nome, tipo FROM corso_laurea;");
	
	$course_form = "<select class='form-control' name='course'>";
	while($row = pg_fetch_assoc($result)) {
		$cod = $row["codice"];
		$name = $row["nome"];
		$type = $row["tipo"];
		if($selected == $row['codice']) 
			$course_form .= "<option value='$cod' selected>$name - $type</option>";
		else
			$course_form .= "<option value='$cod'>$name - $type</option>";
	}
	$course_form .= "</select>";
	return $course_form;
}

/**
	Dati un 'corso di studi' e una 'coorte' trovare tutte le attività formative ordinate per anno e semestre,
	mostrare canale, anno accademico, nome e cognome del docente se il corso è attivato.
	@return String: html della tabella contenente le attività formative
*/
function get_percorso($conn, $year, $course) {
	$sql = 'SELECT af.nome as nomeatt, p.anno, p.semestre, a.canale, a.anno_accademico, 
						d.nome as nomedoc, d.cognome as cognomedoc, af.codice, d.matricola
					FROM propone as p 
					JOIN attivita_formativa as af ON p.attivita_formativa = af.codice
					LEFT JOIN attiva as a 
					ON p.corso_laurea = a.corso_laurea
						AND p.curriculum = a.curriculum
						AND p.coorte = a.coorte
						AND p.attivita_formativa = a.attivita_formativa
					LEFT JOIN docente as d ON a.responsabile = d.matricola
					WHERE p.coorte = $1 and p.corso_laurea = $2
					ORDER BY p.anno ASC, p.semestre ASC;';
	$result = pg_prepare($conn, "querypercorso", $sql);
	$result = pg_execute($conn, "querypercorso", array($year, $course));
	
	$html_table = "<table class='table' style='width:90%'><thead class='thead-dark'><tr>
											<th>Nome</th>
											<th>Anno</th>
											<th>Semestre</th>
											<th>Canale</th>
											<th>Anno accademico</th>
											<th>Responsabile</th>
											<th>Scheda corso</th>
										</tr></thead><tbody>";

	while($row = pg_fetch_assoc($result)) {
		$html_table .= "<tr>
												<td>{$row['nomeatt']}</td>
												<td>{$row['anno']}</td>
												<td>{$row['semestre']}</td>
												<td>{$row['canale']}</td>
												<td>{$row['anno_accademico']}</td>
												<td>{$row['nomedoc']} {$row['cognomedoc']}</td> ";

		$html_table .= "<td>";
		if($row['nomedoc'] != null) {
			$url_scheda_corso = build_istanza_attform_query($row['codice'], $row['canale'], $row['anno_accademico'], $row['matricola']);
			$html_table .= "<a href=\"$url_scheda_corso\"> Scheda corso </a>";
		}
		$html_table .= '</td></tr>';
	}
	$html_table .= "</tbody></table>";
	return $html_table;
}

/**
	Costruisce l'href per reindirizzare alla scheda del corso
*/
function build_istanza_attform_query($attivita_formativa, $canale, $annoacc, $responsabile) {
	$data = array(
		'attform' => $attivita_formativa,
		'canale' => $canale,
		'annoacc' => $annoacc,
		'resp' => $responsabile
	);
	$url = "schedacorso.php?" . http_build_query($data);
	return $url;
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
				<a href="corsilaurea.php" class="list-group-item list-group-item-action bg-light">Corsi di laurea</a>
        <a href="percorso.php" class="list-group-item list-group-item-action bg-light">Offerta formativa</a>
        <a href="schedacorso.php" class="list-group-item list-group-item-action bg-light">Attività formative</a>
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
			<br>
			<h3>Offerta formativa</h3>
			<br>
			<form action="#" method="GET" enctype="multipart/form-data">
				<div class="form-row">
					<div class="form-group col-md-2">
						<?php
						echo get_year_form($conn);
						?>
					</div>
					<div class="form-group col-md-2">
						<?php
						echo get_course_form($conn);
						?>
					</div>
				</div>
				<input type="submit" class="btn btn-primary" value="Submit">
			</form>
			<br>
			<hr>
			<?php
				//show result table if requested
				if($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET['year']) and isset($_GET['course'])) {
					echo '<hr> <h3> Corsi proposti </h3>';
					echo get_percorso($conn, $_GET['year'], $_GET['course']);
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





