<?php
/**
 * Edit Class Subject
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

if (isset($_GET['update'])) {
    $subject_name=$_GET['subject'];
    $subject_name=Validate_input($subject_name);

    $school_name=$_GET['school'];
    $school_name=Validate_input($school_name);

    $class_name=$_GET['class_exam'];
    $class_name=Validate_input($class_name);

    $total_marks=$_GET['total_marks'];
    $total_marks=Validate_input($total_marks);

    $status=$_GET['status'];
    $status=Validate_input($status);

    $id=$_GET['id'];
    $id=Validate_input($id);

    $class_id=Convert_Class_Name_To_id($class_name);
    $subject_id=Convert_Subject_Name_To_id($subject_name);
    $school_id=Convert_School_Name_To_id($school_name);

    $q="UPDATE class_subjects SET 
    School_Id=$school_id,
    Class_Id=$class_id,
    Subject_Id=$subject_id,
    Total_Marks=$total_marks,
    Status=$status 
    WHERE Id=$id";
    
    $exe=mysqli_query($link, $q) or die('Error in Subject Updation');
    if ($exe) {
        echo "<div class='alert-success'>Subject Updated Successfully</div>";
        header('refresh:1; url=edit_class_subject.php');
    } else {
        echo "There is some error in Subject Updation";
    }
}
?>
<?php Page_header('Edit Class Subject'); ?>
</head>
<body>
<?php  require_once 'nav.html';?>
  <div class="bg-warning text-center">
    <h4>Edit Subjects to Classes (Selected School=<?php echo $SCHOOL_NAME ?>)</h4>
  </div>
  
<div class="container-fluid">
  <form action="#" method="GET">
    <div class="row no-print">
<?php
if (isset($_GET['id'])) {
    $id=$_GET['id'];
    $id=Validate_input($id);

    $q="SELECT * from class_subjects WHERE Id=$id";
    $exe=mysqli_query($link, $q);
    $exer=mysqli_fetch_assoc($exe);

    $school_id=$exer['School_Id'];
    $class_id=$exer['Class_Id'];
    $subject_id=$exer['Subject_Id'];
    $total_marks=$exer['Total_Marks'];
    $status=$exer['Status'];
    $id=$exer['Id'];

    $selected_school=Convert_School_Id_To_name($school_id);
    $selected_class=Convert_Class_Id_To_name($class_id);
    $selected_subject=Convert_Subject_Id_To_name($subject_id);;
    Select_school($selected_school);
    Select_class($selected_class);
    ?>
    </div> <!-- end of row select school select class -->
    <div class="row mt-3">
    <?php
      Select_subject($selected_subject);
    ?>
      <div class="form-group col-sm-6">
        <label for="total_marks" class="form-label">Total Marks:</label>
        <input type="number" class="form-control" id="total_marks"
            max="100" min="-1" name="total_marks" 
            value="<?php echo $total_marks;?>"
            placeholder="type total marks of this subject" required>
      </div>
      <div class="form-group col-sm-6">
        <label for="status" class="form-label">Status:</label>
        <input type="number" class="form-control" id="status"
            max="1" min="0" name="status" 
            value="<?php echo $status;?>"
            placeholder="type status value" required>
      </div>
      <div class="col-sm-2">
        <input type="hidden" name="id" value="<?php echo $id; ?>">
        <button  class="btn btn-primary no-print mt-4" type="submit" name="update">
          Update
        </button>
    </div> <!-- end of row -->
<?php } ?>
  </form>
</div> <!-- end of container  -->
<div class="container-fluid">
  <div class="row">

<?php
$school=$SCHOOL_NAME;
$classes_array=School_classes();
$school_id=Convert_School_Name_To_id($school);
foreach ($classes_array as $class) {
    $class_id=Convert_Class_Name_To_id($class);
    echo "<div class='col-sm-4 border border-info'>
        <legend class='text-center'> Class $class Subjects </legend>";
    $q="SELECT * from class_subjects WHERE 
    Class_Id=$class_id AND School_Id=$school_id";
    $exe=mysqli_query($link, $q);
    echo "<table class='table table-border table-striped table-hover'>
            <th>Name</th><th>Marks</th><th>Status</th><th>Edit</th>";
    while ($exer=mysqli_fetch_assoc($exe)) {
        $subject_id=$exer['Subject_Id'];
        $subject_name=Convert_Subject_Id_To_name($subject_id);
        $total_marks=$exer['Total_Marks'];
        $status=$exer['Status'];
        $id=$exer['Id'];
        $status=change_status_to_word($status);
         echo "<tr>
         <td> $subject_name </td>
         <td> $total_marks </td>
         <td> $status </td>
         <td> <a href='edit_class_subject.php?id=$id'> Edit</td>
         <tr>";
    }
    echo "</table>";
    echo "</div>";
}
?>
  </div>

 </div> <!-- End of main container -->
<?php Page_close(); ?>

