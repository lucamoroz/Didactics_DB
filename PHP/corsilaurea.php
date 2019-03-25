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
      $selected = (isset($_GET['school']) ? $_GET['school'] : "");
      $ret = pg_query($conn, "SELECT codice, nome FROM scuola;");
    
      $year_form = "<select class='form-control' name='school'>";
      while($row = pg_fetch_assoc($ret)) {
        if($selected == $row['codice'])
          $year_form .= "<option value={$row['codice']} selected>{$row['nome']}</option>";
        else
          $year_form .= "<option value={$row['codice']}>{$row['nome']}</option>";
      }
      $year_form .= "</select>";
      
      return $year_form;
    }

    /**
     * restituisce il codice html della select contenente le tipologie dei corsi di laurea
     */
    function get_tipicorsi_form() {
      $selected = (isset($_GET['type']) ? $_GET['type'] : "");
      $tipi =  array('LT'=>'Laurea triennale', 
                    'LM'=>'Laurea magistrale', 
                    'CU'=>'Laurea magistrale a ciclo unico');
                    
      $select_html = "<select class='form-control' name='type'>";
      foreach($tipi as $codice => $nome) {
        if($selected == $codice)
          $select_html .= "<option value=$codice selected>$nome</option>";
        else
          $select_html .= "<option value=$codice>$nome</option>";
      }
      $select_html .= "</select>";
      return $select_html;
    }

    /**
     * Dato un corso restituisce un array con le sue classi di appartenenza
     */
    function get_classi_appartenenza($conn, $corso) {
      $sql = "SELECT cl.codice, cl.descrizione
              FROM classe AS cl
              JOIN appartiene AS a ON cl.codice = a.classe
              WHERE a.corso_laurea = $1;";
      $result = pg_prepare($conn, "", $sql);
      $result = pg_execute($conn, "", array($corso));
      $classi = array();
      while($row = pg_fetch_row($result)) {
        array_push($classi, $row[0]);
      }
      return $classi;
    }

    /**
     * restituisce il codice html della tabella dei corsi di laurea
     */
    function get_corsi_laurea($conn, $scuola, $tipo) {

        $sql = "SELECT * FROM corso_laurea AS C WHERE c.scuola = $1 AND c.tipo = $2;";
        $result = pg_prepare($conn, "querycorsi", $sql);
        $result = pg_execute($conn, "querycorsi", array($scuola, $tipo));

        $html_table = "<table class='table' style='width:90%'><thead class='thead-dark'><tr>
                <th>Codice</th>
                <th>Nome</th>
                <th>Ordinamento</th>
                <th>CFU</th>
                <th>Classe</th>
              </tr></thead><tbody>";

        while($row = pg_fetch_assoc($result)) {
          $url_offerta = build_link_offerta($conn, $row['codice']);
          
          $html_table .= "<tr>
                    <td>{$row['codice']}</td>";
          if($url_offerta == "")
                    $html_table .= "<td>{$row['nome']}</td>";
          else
          	$html_table .= "<td><a href=\"$url_offerta\">{$row['nome']}</a></td>";
          
          $html_table .= "<td>{$row['ordinamento']}</td>
                          <td>{$row['cfu']}</td>";
          $html_table .= '<td><ul class="list-unstyled">';
          $classi = get_classi_appartenenza($conn, $row['codice']);
          foreach($classi as $classe)
            $html_table .= "<li>$classe</li>";
          $html_table .= '</ul></td></tr>';
        }
        $html_table .= "</tbody></table>";

        return $html_table;
    }
    function build_link_offerta($conn, $codice) {
    	$query = "SELECT MAX(coorte) as coorte
    		  FROM percorso
    		  WHERE corso_laurea = $1";
    	$result = pg_prepare($conn, "", $query);
    	$result = pg_execute($conn, "", array($codice));
    	
    	$max_coorte = pg_fetch_assoc($result)['coorte'];
    	if($max_coorte == NULL)
    		return "";
	$data = array(
		'year' => $max_coorte,
		'course' => $codice
	);
	$url = "percorso.php?" . http_build_query($data);
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
              <a class="nav-link" href="index.php">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="https://github.com/lucamoroz/Didactics_DB">Github</a>
            </li>
          </ul>
        </div>
      </nav>

      <div class="container-fluid">
          <br>
          <h3> Corsi di laurea </h3>          
          <br>
          <form action="#" method="GET" enctype="multipart/form-data">
				<div class="form-row">
					<div class="form-group col-md-2">
						<?php
						echo get_schools_form($conn);
						?>
					</div>
					<div class="form-group col-md-2">
						<?php
						echo get_tipicorsi_form($conn);
						?>
					</div>
				</div>
				<input type="submit" class="btn btn-primary" value="Submit">
			</form>
	  <br>
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
