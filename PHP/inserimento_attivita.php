<?php
//include db connection data
include 'env.php';

//show errors (disable in production)
//ini_set('display_errors', 1);
//ini_set('display_startup_errors', 1);
//error_reporting(E_ALL);

$conn=pg_connect($GLOBALS['connection_string']) or die('Could not connect: ' . pg_last_error());

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
        <a href="inserimento_attivita.php" class="list-group-item list-group-item-action bg-light">Inserimento attività</a>
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
			<h3>Inserimento attività formativa</h3>
			<br>
			<form action="#" method="GET" enctype="multipart/form-data">
				<div class="form-row">
					<div class="form-group col-md-2">
						<!-- CODICE -->
            <input class='form-control' type="text" name="codice" placeholder="Codice">
					</div>
					<div class="form-group col-md-2">
            <!-- NOME -->
            <input class='form-control' type="text" name="nome" placeholder="Nome">
					</div>
          <div class="form-group col-md-2">
            <!-- TIPO -->
            <select class='form-control' name='tipo'>
              <option value='insegnamento'>Insegnamento</option>
              <option value='tirocinio'>Tirocinio</option>
              <option value='lingua'>Lingua</option>
              <option value='prova_finale'>Prova finale</option>
            </select>
					</div>
				</div>
				<input type="submit" class="btn btn-primary" value="Submit">
			</form>
			<br>
			<hr>
			<?php
				//show result table if requested
				if($_SERVER["REQUEST_METHOD"] == "GET" and isset($_GET['codice']) and isset($_GET['nome']) and isset($_GET['tipo'])) {
          $codice = $_GET['codice'];
          $nome = $_GET['nome'];
          $tipo = $_GET['tipo'];
          $err_mess = "";
          $result = false;

          if(empty($codice) || empty($nome) || empty($tipo))
            $err_mess = "campi vuoti.";

          //se non ci sono errori
          if(empty($err_mess)) {
            pg_prepare($conn, "", "INSERT INTO attivita_formativa(codice, nome, tipo)
                                   VALUES ($1, $2, $3);");
            $result = pg_execute($conn, "", array($codice, $nome, $tipo));

            if($result)
            echo '<div class="alert alert-success" role="alert">
                    Inserimento confermato!
                  </div>';
            else {
              $err_mess = "chiavi duplicate.";
            }
          }

          if(!empty($err_mess)) {
            echo '<div class="alert alert-danger" role="alert">
                    Inserimento fallito: ' .  $err_mess .
                  '</div>';
          }
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
