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
?>
<?php Page_header('View Locked Subjects'); ?>
</head>
<body>
  <?php require_once 'nav.html';?>
  <div class="bg-warning text-center">
    <h4>View Locked Subjects</h4>
  </div>
  
  <div class="container mt-3">
    <form action="#" method="POST">
      <div class="row no-print">
        <?php
          $selected_class=$CLASS_NAME;
          $selected_school=$SCHOOL_NAME;
          Select_school($selected_school);
          Select_class($selected_class);
        ?>
      </div>
      <button class="no-print btn btn-primary mt-3" type="submit" name="submit">
        Show Locked Subjects
      </button>
    </form>
  </div>
<?php
if (isset($_POST['submit'])) {
    $school_name=$_POST['school'];
    $school_name=Validate_input($school_name);

    $class_name=$_POST['class_exam'];
    $class_name=Validate_input($class_name);

    $school_id=Convert_School_Name_To_id($school_name);
    $class_id=Convert_Class_Name_To_id($class_name);
    
    $q="SELECT Subject_Id,Lock_Status from class_subjects
    WHERE Status='1' AND Class_Id='$class_id' AND
     School_Id='$school_id'";
    $exe=mysqli_query($link, $q);
    $effect=mysqli_num_rows($exe);
    if ($effect==0) {
        $msg="No Locked Subjects Available at School $school_name Class $class_name";
        $error_type="warning text-center";
        show_alert($msg, $error_type);
    } else {
        echo "<table class='table table-bordered table-stripped'>";
        echo "<tr><th>Subject Name</th><th>Lock Status</th>";
        while ($exer=mysqli_fetch_assoc($exe)) {
            $subject_id=$exer['Subject_Id'];
            $Lock_Status=$exer['Lock_Status'];
            if ($Lock_Status!=1) {
                $subject_lock_status="UnLock";
            } else {
                $subject_lock_status="Lock";
            }
            $subject_name=Select_Column_data(
                'subjects', "Name", "Id", $subject_id
            );
            echo "<tr><td>".$subject_name['Name']."</td>
                      <td>".$subject_lock_status."</td></tr>";
        }
        echo "</table>";
    }
}
?>
</div>
<?php Page_close(); ?>

