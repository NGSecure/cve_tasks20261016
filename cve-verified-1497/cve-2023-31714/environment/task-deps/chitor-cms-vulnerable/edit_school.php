<?php
/**
 * Edit School
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

if ($SCHOOL_CHANGES=="0") {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_GET['submit'])) {
    $name=$_GET['school_name'];
    $name=Validate_input($name);

    $status=$_GET['status'];
    $status=Validate_input($status);
    
    $id=$_GET['id'];
    $id=Validate_input($id);

    $q="Update  schools SET Name='$name', Status='$status' WHERE Id='$id'";
    $exe=mysqli_query($link, $q) or
    die('Error in School Updation '. mysqli_error($link));
    if ($exe) {
          echo "school updated";
    } else {
          echo "Error in Updation";
    }
}
?>
  <?php Page_header('Edit School'); ?>
</head>
<body>
<?php 
$url_id= $_GET['id'];
$url_id=Validate_input($url_id);
$q="SELECT * from schools WHERE Id='$url_id'";
$exe=mysqli_query($link, $q);
$exer=mysqli_fetch_assoc($exe);

$school_name=$exer['Name'];
$status=$exer['Status'];
$id=$exer['Id'];
?>
<div class="container-fluid">
  <form class="p-3">
    <div class="row">
      <div class="col-sm-6 form-group">
        <label for="school_name" class="form-label">School Name:</label>
        <input type="text" placeholder="Type School Name" 
                class="form-control" name="school_name" 
                value="<?php echo $school_name; ?>" id="school_name" required>
      </div>
    <div>
    <div class="row mt-1">
      <div class="col-sm-6 form-group">
        <label for="status" class="form-label">Status:</label>
        <input type="number" class="form-control" name="status" 
               value="<?php echo $status;?>" min="0" max="1" required>
      </div>
      <div class="col-sm-6">
      <input type="hidden" value="<?php echo $id;?>" name="id">
      <input type="submit" name="submit" class="btn btn-primary mt-4" 
            value="Update School Name">
      </div>
    <div>
    </form>
  </div>

  <div class="container-fluid">
  <h3>Existing Schools</h3>
  <div id="existing_schools" class="bg-white">
  </div>
</div>
<script type="text/javascript" src="js/add_schools.js">
<?php Page_close(); ?>