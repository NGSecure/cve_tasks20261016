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

if ($SUBJECT_CHANGES=="0" || $SUBJECT_CHANGES>1) {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_GET['submit'])) {
    $name=$_GET['subject_name'];
    $name=Validate_input($name);

    $status=$_GET['status'];
    $status=Validate_input($status);

    $id=$_GET['id'];
    $id=Validate_input($id);

    $q="Update  subjects SET Name='$name', Status='$status' WHERE Id='$id'";
    $exe=mysqli_query($link, $q) or
    die('Error in Subject Updation '. mysqli_error($link));
    if ($exe) {
          echo "<div class='alert-success'>Subject Updated</div>";
          redirection(1, "edit_subject.php?id=$id");
    } else {
          echo "<div class='alert-success'>Error in Subject Updation</div>";
    }
}
?>
  <?php Page_header('Edit Subject'); ?>
</head>
<body>
<?php 
$url_id=$_GET['id'];
$url_id=Validate_input($url_id);

$q="SELECT * from subjects WHERE Id='$url_id'";
$exe=mysqli_query($link, $q);
$exer=mysqli_fetch_assoc($exe);

$subject_name=$exer['Name'];
$status=$exer['Status'];
$id=$exer['Id'];
?>
<?php require_once 'nav.html';?>
<div class="container-fluid">
  <form class="p-3">
    <div class="row">
      <div class="col-sm-6 form-group">
        <label for="subjet_name" class="form-label">Subject Name:</label>
        <input type="text" placeholder="Type Subject Name" 
                class="form-control" name="subject_name" 
                value="<?php echo $subject_name; ?>" id="subject_name" required>
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
            value="Update Subject Name">
      </div>
    <div>
    </form>
  </div>

  <div class="container-fluid">
<h3>Exisiting Subjects</h3>
  <div id="existing_subjects" class="bg-white">
  </div>
</div>
<script src="js/select_subjects.js">
<?php Page_close(); ?>