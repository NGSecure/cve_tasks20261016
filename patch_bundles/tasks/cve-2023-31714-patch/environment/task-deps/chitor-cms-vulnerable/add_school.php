<?php
/**
 * Add  All Subjects Marks of Students
 * php version 8.1
 *
 * @category Exam
 *
 * @package None
 *
 * @author Waqas <admin@waqaskanju.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;

if ($SCHOOL_CHANGES!=1) {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_POST['submit'])) {
    $new_name=$_POST['school_name'];
    $new_name=Validate_input($new_name);
    $q="INSERT INTO schools (`Name`,`Status`) VALUES ('$new_name','1')";
    $exe=mysqli_query($link, $q);
    if ($exe) {
        echo "<div class='alert-info'>New school added</div>";
        header(1, 'add_school.php');

    } else {
        echo "Error in Insertion";
    }
    
}
?>
  <?php Page_header('Add School'); ?>
</head>
<body class="background">
<?php require_once 'nav.html';?>
<div class="container-fluid">
  <form method="POST" class="p-3" action="#">
    <div class="row bg-white mt-1 p-3">    
      <div class="form-group col-sm-3">
        <label for="school_name" class="form-label">New School Name:</label>
        <input type="text" name="school_name" id="school_name" class="form-control" 
        required>
      </div>
      <div class="col-sm-3">
        <input type="submit" name="submit" value="Save" 
        class="btn btn-primary mt-4">
      </div>
    </div>
  </form>
</div>

<div class="container-fluid">
<h3>Existing Schools</h3>
<p class="text-white">Click on the school name to edit.</p>
  <div id="existing_schools" class="bg-white">
  </div>
</div>
<script type="text/javascript" src="js/add_schools.js">
<?php Page_close(); ?>