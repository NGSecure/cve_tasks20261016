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

if ($SCHOOL_CHANGES=="0") {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_GET['submit'])) {
    $status=$_GET['status'];
    $status=Validate_input($status);
    
    $name=$_GET['class_name'];
    $name=Validate_input($name);
    
    $id=$_GET['id'];
    $id=Validate_input($id);

    $school=$_GET['school'];
    $school=Validate_input($school);

    $pass_percentage=$_GET['pass_percentage'];
    $pass_percentage=Validate_input($pass_percentage);

    $school_id=Convert_School_Name_To_id($school);
    $q="Update  school_classes 
    SET Status='$status', Name='$name', School_Id='$school_id', 
    Pass_Percentage='$pass_percentage' WHERE Id='$id'";
    $exe=mysqli_query($link, $q) or
    die('Error in Class Updation '. mysqli_error($link));
    if ($exe) {
          echo "<div class='alert-success'>Class Updated</div>";
          header('refresh:1 url=add_school_class.php');
    } else {
          echo "Error in Updation";
    }
}
?>
  <?php Page_header('Edit School\'s Class'); ?>
</head>
<body>
<?php 
$url_id=$_GET['id'];
$url_id=Validate_input($url_id);

$q="SELECT * from school_classes WHERE Id='$url_id'";
$exe=mysqli_query($link, $q);
$exer=mysqli_fetch_assoc($exe);
$school_id=$exer['School_Id'];
$school_name=Convert_School_Id_To_name($school_id);
$class_name=$exer['Name'];
$status=$exer['Status'];
$pass_percentage=$exer['Pass_Percentage'];
$id=$exer['Id'];
?>
<div class="container-fluid">
  <form class="p-3">
    <div class="row">
      <?php Select_school($school_name); ?>
      <div class="col-sm-6 form-group">
        <label for="class_name" class="form-label">Class Name:</label>
        <input type="text" placeholder="Type Class Name" 
                class="form-control" name="class_name" 
                value="<?php echo $class_name; ?>" id="class_name" required>
      </div>
    <div>
    <div class="row mt-1">
      <div class="col-sm-4 form-group">
        <label for="pass_percentage" class="form-label">Pass Percentage:</label>
        <input type="number" class="form-control" name="pass_percentage" 
               value="<?php echo $pass_percentage;?>" 
               step="0.1" min="0" max="100" required>
      </div>
      <div class="col-sm-4 form-group">
        <label for="status" class="form-label">Status:</label>
        <input type="number" class="form-control" name="status" 
               value="<?php echo $status;?>" min="0" max="1" required>
      </div>
      <div class="col-sm-4">
      <input type="hidden" value="<?php echo $id;?>" name="id">
      <input type="submit" name="submit" class="btn btn-primary mt-4" 
            value="Update Class Name">
      </div>
    <div>
    </form>
  </div>

  <div class='container-fluid'>
    <h3>Existing School Classes</h3>
    <div id='exiting-school-classes'>
    </div>
  </div>
  <script type="text/javascript" src="js/add_school_class.js">
<?php Page_close(); ?>