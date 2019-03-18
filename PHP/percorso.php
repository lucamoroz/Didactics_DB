<?php
//include db connection data
include 'env.php';

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);


error_reporting(E_ALL);



$conn=pg_connect($env) or die('Could not connect: ' . pg_last_error());

function get_year_form($conn) {
	/**
	@return String: a 'select' form, each option has 'anno' as value and as text
	*/
	$years = array();
	$ret = pg_query($conn, "SELECT anno FROM coorte;");

	while($row = pg_fetch_row($ret)) {
		array_push($years, $row[0]);	
	}
	
	$year_form = "<select name='year'>";
	foreach($years as $year) {
		$year_form .= "<option value='$year'>$year</option>";
	}
	$year_form .= "</select>";
	
	return $year_form;
}

function get_course_form($conn) {
	/**
	@return String: a 'select' form, each option has 'codice' as value and 'nome' as text
	*/
	$courses = array();
	$ret = pg_query($conn, "SELECT codice, nome FROM corso_laurea;");
	while($row = pg_fetch_row($ret)) {
		$courses[$row[1]] = $row[0];
	}
	$course_form = "<select name='course'>";
	foreach($courses as $c_name => $c_cod) {
		$course_form .= "<option value='$c_cod'>$c_name</option>";
	}
	$course_form .= "</select>";
	return $course_form;
}

function get_percorso($conn, $year, $course) {
	$result = pg_prepare($conn, 
            			"query", 
            			'SELECT a.nome, p.anno, p.semestre
				 FROM propone as p JOIN attivita_formativa as a ON p.attivita_formativa = a.codice
				 WHERE p.coorte = $1 and p.corso_laurea = $2
				 ORDER BY p.anno ASC, p.semestre ASC;');
	    $result = pg_execute($conn, "query", array($year, $course));
	    
	    $html_table = "<table style='width:80%'><tr><th>Nome</th><th>Anno</th><th>Semestre</th></tr>";
	    while($row = pg_fetch_row($result)) {
	    	$html_table .= "<tr><th>$row[0]</th><th>$row[1]</th><th>$row[2]</th></tr>";
	    }
	    $html_table .= "</table>";
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
              <a class="nav-link" href="index.html">Home <span class="sr-only"></span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="https://github.com/lucamoroz/Didactics_DB">Github</a>
            </li>
          </ul>
        </div>
      </nav>
	
	
	<!-- CONTENT -->
      <div class="container-fluid">
        
       	<form action="#" method="GET" enctype="multipart/form-data">
	<?php
	echo get_year_form($conn);
	echo get_course_form($conn);
	?>

	<input type="submit" value="Submit">
	</form>
	
	<?php
	//show result table if requested
	
	if($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET['year']) and isset($_GET['course'])) {
		echo get_percorso($conn, $_GET['year'], $_GET['course']);
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





