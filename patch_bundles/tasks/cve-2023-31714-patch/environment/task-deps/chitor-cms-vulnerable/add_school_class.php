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
$selected_class=$CLASS_NAME;
$selected_school=$SCHOOL_NAME;

if ($SCHOOL_CHANGES!=1) {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_POST['submit'])) {
    $school_name=$_POST['school'];
    $school_name=Validate_input($school_name);
    $school_id =  Convert_School_Name_To_id($school_name);

    $class_name=$_POST['class_name'];
    $class_name=Validate_input($class_name);

    $pass_percentage=$_POST['pass_percentage'];
    $pass_percentage=Validate_input($pass_percentage);
    
    $q="INSERT INTO school_classes (`Name`,`School_Id`,`Pass_Percentage`,`Status`) 
    VALUES ('$class_name',$school_id,$pass_percentage,'1')";
    $exe=mysqli_query($link, $q) or
    die('Error in Class Addition '. mysqli_error($link));
    if ($exe) {
          echo "<div class='bg-success'>New class added Successfully</div>";
          redirection(1, 'add_school_class.php');
    } else {
          echo "Error in Insertion";
    }
}
?>
  <?php Page_header('Add Class to School'); ?>
  
</head>
<body>
  <div class="container-fluid">
    <form class="p-3" method="POST">
      <div class='row'>
        <?php Select_school($selected_school); ?>
        <div class="col-sm-6 form-group">
          <label for="class_name" class="form-label">Class Name:</label>
          <input type="text" required placeholder="Type Class Name" 
          class="form-control" name="class_name" id="class_name">
        </div>
      </div>
      <div class="col-sm-4 form-group">
        <label for="pass_percentage" class="form-label">Pass Percentage:</label>
        <input type="number" class="form-control" name="pass_percentage" 
               value="33.3" 
               step="0.1" min="0" max="100" required>
      </div>
      <input type="submit" name="submit" class="btn btn-primary mt-3" 
            value="Add Class to School">
    </form>
  </div>

  <div class='container-fluid'>
    <h3>Existing School Classes</h3>
    <div id='exiting-school-classes'>
    </div>
  </div>
  <script type="text/javascript" src="js/add_school_class.js">
<?php Page_close(); ?>