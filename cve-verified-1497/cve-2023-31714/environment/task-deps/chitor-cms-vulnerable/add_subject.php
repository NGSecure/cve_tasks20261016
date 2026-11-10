<?php
/**
 * Add Subject
 * php version 8.1
 *
 * @category Site
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

if ($SUBJECT_CHANGES!=1) {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_GET['submit'])) {
    $subject_name=$_GET['subject_name'];
    $subject_name=Validate_input($subject_name);
    $q="INSERT INTO subjects (`Name`,`Status`) VALUES ('$subject_name','1')";
    $exe=mysqli_query($link, $q);
    if ($exe) {
        echo "<div class='alert-success'>New Subject added</div>";
        redirection(1, 'add_subject.php');
    } else {
        echo "Error in Subject Insertion";
    }
    
}
?>
  <?php Page_header('Add Subject'); ?>
</head>
<body class="background">
<?php require_once 'nav.html';?>
<div class="container-fluid">
  <form method="GET" class="p-3" action="#">
    <div class="row bg-white mt-1 p-3">    
      <div class="form-group col-sm-3">
        <label for="subject_name" class="form-label">New Subject Name:</label>
        <input type="text" name="subject_name" id="subject_name" 
        class="form-control" required>
      </div>
      <div class="col-sm-3">
        <input type="submit" name="submit" value="Save" 
        class="btn btn-primary mt-4">
      </div>
    </div>
  </form>
</div>

<div class="container-fluid">
<h3>Existing  Subjects</h3>
<p class="text-white">Click on Subject Name to Edit</p>
  <div id="existing_subjects" class="bg-white">
  </div>
</div>
<script src="js/select_subjects.js">
<?php Page_close(); ?>