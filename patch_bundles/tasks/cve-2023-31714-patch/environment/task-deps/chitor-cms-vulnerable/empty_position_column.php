<?php
/**
 * Show Student detail
 * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Waqas <waqas@waqaskanju.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/
?>
<?php
session_start();
require_once 'sand_box.php';
$link=$LINK;
Page_header('Empty Position Column');
?>
</head>

<body>
  <div class="container-fluid">
    <?php require_once 'nav.html';?>
    <div class="row">
      <div class="col-6">
        <a class="btn btn-primary"
        href="http://localhost/Chitor-CMS/empty_position_column.php?table=position">
            Empty Position Table Value
        </a>
      </div>
      <div class="col-6">
        <a class="btn btn-primary"
           href="http://localhost/Chitor-CMS/empty_position_column.php?table=marks">
            Empty Marks Table
        </a>
      </div>
    </div>
<?php
if (isset($_GET['table'])) {
    $table_value=$_GET['table'];
    if ($table_value=="position") {
        $update_position="Update students_info set  Class_Position='' ";
        $exe_update=mysqli_query($link, $update_position);
        if ($exe_update) {
            echo '<div class="alert-success">Position emptified 
                  </div>';
              // redirection(2, 'empty_position_column.php');
        } else {
            echo 'error in position emptification';
        }
    }    
    if ($table_value=="marks") {
        $empty_marks="TRUNCATE Table marks;";
        $exe_marks=mysqli_query($link, $empty_marks);
        if ($exe_marks) {
            echo '<div class="alert-success">Marks table data deleted.
            .</div>';
            // redirection(2, 'empty_position_column.php');
        } else {
            echo 'Error in marks table emptification';
            
        }
    }
}

?>
</div>
<?php
  Page_close();
?>
