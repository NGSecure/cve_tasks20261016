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

if ($SUBJECT_CHANGES=="0") {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

if (isset($_GET['submit'])) {
    $subject_name=$_GET['subject'];
    $subject_name=Validate_input($subject_name);

    $class_name=$_GET['class_exam'];
    $class_name=Validate_input($class_name);
    
    $teacher_name=$_GET['teacher_name'];
    $teacher_name=Validate_input($teacher_name);

    $class_id=Convert_Class_Name_To_id($class_name);
    $subject_id=Convert_Subject_Name_To_id($subject_name);
    $teacher_id=Convert_Teacher_Name_To_id($teacher_name);

    $check_subject="SELECT Id from class_subjects
    WHERE Class_Id=$class_id AND Subject_Id=$subject_id";
    $exe=mysqli_query($link, $check_subject);
    $exer=mysqli_fetch_assoc($exe);
    $effected_rows=mysqli_num_rows($exe);
    if ($effected_rows==0) {
        echo "Subject No Found. Please Add it in Add_Class_Subject Page.";
    } else if ($effected_rows==1) {
        $class_subject_id=$exer['Id'];

        $q2="UPDATE subject_teacher SET Teacher_Id=$teacher_id 
             WHERE Class_Subject_Id=$class_subject_id";
        $exe2=mysqli_query($link, $q2) or die('Error in Employee Subject Addittion');
        if ($exe2) {
            echo "Teacher Assigned Successfully";
        } else {
            echo "There is some error in Teacher Assignment";
        }
    } else {
        echo "There is Duplication. Kindly Correct";
    }

}
?>
    <?php Page_header('Update Assign Subject Teacher'); ?>
    </head>

    <body >
  <div class="bg-warning text-center">
    <h4>Update Subject Teacher</h4>
  </div>

  <?php  require_once 'nav.html';?>
  <div class="container">
    <div class="form-row">
      <div class="col-md-12 ">
      <div class="row">
  <div class="col-md-12 ">
    <form action="#" method="GET">
      <div class="form-row no-print">
      <?php
        $selected_class='';
        $selected_subject='';
        $selected_teacher='';
        Select_class($selected_class);
        Select_subject($selected_subject);?>
    </div>
    <div class="row">

    <?php Select_teacher($selected_teacher); ?>

    <div class="col-md-6">
    <div class="col-md-3">
        <button  class="btn btn-primary no-print mt-4" type="submit" name="submit">
        Submit
    </button>
</div>
</div>
    </form>

</div>
</div>
</div>

<?php Page_close(); ?>

