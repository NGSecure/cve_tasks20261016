<?php
/**
 * Delete Subject From Class
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

require_once '../sand_box.php';
$link=$LINK;



$subject_name=$_GET['subject'];
$subject_name=Validate_input($subject_name);

$class_name=$_GET['class_name'];
$class_name=Validate_input($class_name);

$school_name=$_GET['school'];
$school_name=Validate_input($school_name);

$class_id=Convert_Class_Name_To_id($class_name);
$subject_id=Convert_Subject_Name_To_id($subject_name);
$school_id=Convert_School_Name_To_id($school_name);

$q="Update class_subjects SET Status=0 WHERE Class_Id='$class_id'
AND Subject_Id='$subject_id' AND School_Id='$school_id'";
$exe=mysqli_query($link, $q) or die('Error in Subject Addittion');
if ($exe) {
    header("Refresh:1; url=delete_class_subject.php");
    echo "<div class='text-info'>
    Subject Removed Successfully.
    </div>";
    
} else {
    echo "<div class='bg-danger'>There is some error in Subject Deletion</div>";
}
?>