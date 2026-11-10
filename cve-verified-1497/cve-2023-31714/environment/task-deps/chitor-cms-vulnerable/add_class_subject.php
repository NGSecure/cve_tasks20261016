<?php
/**
 * Add New Students to CMS
 * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
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

if (isset($_POST['submit'])) {
    $subject_name=$_POST['subject'];
    $subject_name=Validate_input($subject_name);

    $school_name=$_POST['school'];
    $school_name=Validate_input($school_name);

    $class_name=$_POST['class_exam'];
    $class_name=Validate_input($class_name);
    
    $total_marks=$_POST['total_marks'];
    $total_marks=Validate_input($total_marks);

    $class_id=Convert_Class_Name_To_id($class_name);
    $subject_id=Convert_Subject_Name_To_id($subject_name);
    $school_id=Convert_School_Name_To_id($school_name);

    $q="INSERT INTO class_subjects (School_Id,Class_Id,Subject_Id,Total_Marks)
    VALUES ($school_id,$class_id, $subject_id, $total_marks)";
    $exe=mysqli_query($link, $q) or die('Error in Subject Addittion');
    if ($exe) {
        echo "Subject Added Successfully";
        redirection(1, 'add_class_subject.php');
    } else {
        echo "There is some error in Subject Addition";
    }
}
?>
<?php Page_header('Add Class Subject'); ?>
</head>
<body class="background">
  <div class="bg-warning text-center">
    <h4>Add Subjects to Class</h4>
  </div>
  <?php  require_once 'nav.html';?>
  <aside class="float-end mt-3  p-3">
  <p>
      <a href="delete_class_subject.php" class="btn btn-danger"> 
        Delete Class's Subject</a>
    </p>
    <p>
      <a href="edit_class_subject.php" class="btn btn-warning"> 
        Edit Class's Subject</a>
    </p>
    <p>
      <a href="add_subject.php" class="btn btn-info"> 
        Add Subject to List</a>
    </p>
</aside>
  <div class="container">
  
    <form action="#" method="POST">
      <div class="row no-print">
<?php

  $selected_school=$SCHOOL_NAME;
  $selected_class=$CLASS_NAME;
  $selected_subject='';
  Select_school($selected_school);
  Select_class($selected_class);
?>
  <div>
    <div class="row mt-3">
<?php
  Select_subject($selected_subject);
?>
      <div class="form-group col-md-4">
        <label for="total_marks" class="form-label">Total Marks:</label>
        <input type="number" class="form-control" id="total_marks"
            max="100" min="-1" name="total_marks" value="100"
            placeholder="type total marks of this subject" required>
      </div>
      <div class="col-md-2">
        <button  class="btn btn-primary no-print mt-4" type="submit" name="submit">
          Add Class's Subject
        </button>
</div> <!-- end of row -->
</form>
</div>
<div class="container mt-3 bg-white p-3">
  <h3>Existing Subject's of Classes</h3>
    <div class="row">
<?php
$school=$SCHOOL_NAME;
$classes_array=School_classes();
foreach ($classes_array as $class) {
    echo "<div class='col-4'>
        <h5> Class $class Subjects </h5>";
    $subjects=Select_Subjects_Of_class($school, $class);
    echo '<ul>';
    for ($i=0; $i<count($subjects); $i++) {
        echo "<li>";
        echo $subjects[$i]['Name'];
        echo "</li>";
    }
    echo "</ul>";
    echo "</div>";
}
?>
  </div>

 </div> <!-- End of main container -->
<?php Page_close(); ?>

