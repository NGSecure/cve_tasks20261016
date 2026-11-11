<?php
/**
 * Employee Registration
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


if ($PERMISSION_CHANGES=="0") {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_POST['add'])) {
    $full_name=$_POST['full_name'];
    $full_name=Validate_input($full_name);

    $user_name=$_POST['user_name'];
    $user_name=Validate_input($user_name);

    $password=$_POST['password'];
    $password=Validate_input($password);
    $password=md5($password);

    $student_changes=$_POST['student_changes'];
    $student_changes=Validate_input($student_changes);

    $batch_marks_changes=$_POST['batch_marks_changes'];
    $batch_marks_changes=Validate_input($batch_marks_changes);

    $single_marks_changes=$_POST['single_marks_changes'];
    $single_marks_changes=Validate_input($single_marks_changes);
    
    $subject_changes=$_POST['subject_changes'];
    $subject_changes=Validate_input($subject_changes);

    $school_changes=$_POST['school_changes'];
    $school_changes=Validate_input($school_changes);

    $marks_lock_changes=$_POST['marks_lock_changes'];
    $marks_lock_changes=Validate_input($marks_lock_changes);

    $permission_changes=$_POST['permission_changes'];
    $permission_changes=Validate_input($permission_changes);

    // Real Values of School and Class can not be added when you are the first user
    // so defulat 1 value is added.
    $school_name=$_POST['school'];
    $school_name=Validate_input($school_name);
    $school_id=1;

    $class_name=$_POST['class_exam'];
    $class_name=Validate_input($class_name);
    $class_id=1;
    
    $select_user_name="SELECT Employee_Id from login WHERE 
          User_Name='$user_name'";
    $user_name_exe=mysqli_query($link, $select_user_name);
    
    // Do not insert when user name is duplicate 
    if (mysqli_num_rows($user_name_exe) > 0) {
        echo "Duplicate User Name";
        
    } else {
        // Insert when no duplicate.

        // Insert employee name.
        $q="INSERT INTO employees (`Name`) VALUES('$full_name')";
        $exe=mysqli_query($link, $q);

        // Select Largest Id
        $q2="SELECT Id from employees Order by Id DESC LIMIT 1 ";
        $exe2=mysqli_query($link, $q2);
        $exer2=mysqli_fetch_assoc($exe2);
        $id=$exer2['Id'];

        // double check if the largest ID and the user add name are same.
        $select_employee="SELECT Name FROM employees WHERE Id='$id'";
        $select_employee_exe=mysqli_query($link, $select_employee);
        $select_employee_exer=mysqli_fetch_assoc($select_employee_exe);
        $db_name=$select_employee_exer['Name'];

        if ($db_name==$full_name) {
             //"Both Equal both are ok then carry on...";
            $q3="INSERT INTO login (Employee_Id,User_Name,Password) 
                VALUES($id,'$user_name','$password')";

            $exe_login_exe=mysqli_query($link, $q3) or 
            die('error in login query addition.');
            if ($exe_login_exe) {
                $q4="INSERT INTO setting (User_Id,Selected_School_Id,
                Selected_Class_Id,Student_Changes,Batch_Marks_Changes,
                Single_Marks_Changes,Subject_Changes,School_Changes,
                Marks_Lock_Changes,Permission_Changes) 
                VALUES('$id','$school_id','$class_id',
                '$student_changes','$batch_marks_changes','$single_marks_changes',
                '$subject_changes','$school_changes','$marks_lock_changes',
                '$permission_changes')";

                $setting_exe=mysqli_query($link, $q4) or 
                die('error in setting addition.');
                if ($setting_exe) {
                    echo "Employee Registerd Successfully.";
                    header('refresh:1; url=index.php');
                }
            }
        } else {
            echo "both are not same";
        }
    }
    
}
?>
  <?php Page_header('Employee Registration'); ?>
</head>
<body>

<div class="container-fluid">
  <h3 class="text-center bg-warning">Employee Registration</h3>
    <!-- Login Form -->
  <form action="#" method="POST">
  <div class="row">
  <div class='col-4'>
      <label for="name">Full Name*</label>
      <input type="text"  id="fullname" name="full_name" class="form-control"
             placeholder="Type Your Name" required>
    </div>    
  <div class='col-4'>
      <label for="name">User Name*</label>
      <input type="text"  id="username" name="user_name" class="form-control"
             placeholder="Type User Name" required>
    </div>
    <div class="col-4">
      <label for="name">Password*</label>
      <input type="password"  id="name" name="password" class="form-control"
             placeholder="Type Password" required>
    </div>
    <!-- Class and School Selection -->
    <div class="row mt-4">
        <?php
        $selected_class='';
        $selected_school='';
        Select_school($selected_school);
        Select_class($selected_class);
        ?>
        </div>
  <!-- Permission Form -->

    <div class="row mb-3 mt-4">
      <div class="col-4 form-group">
        <label for="student_changes" class="form-label">Student Change:</label>
        <input type="number" placeholder="Student changes value" 
               class="form-control" name="student_changes" min="0" max="1" 
               value="0" id="student_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="batch_marks_changes" class="form-label">
            Batch Marks Changes:
        </label>
        <input type="number" placeholder="Batch Marks Change value" 
               class="form-control" name="batch_marks_changes" min="0" max="1"
               value="0" 
               id="batch_marks_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="single_marks_changes" class="form-label">
            Single Marks Changes:
        </label>
        <input type="number" placeholder="Single Marks Change value" 
               class="form-control" name="single_marks_changes" min="0" max="1"
               value="0" id="single_marks_changes" 
               required>
      </div>
    </div> <!-- end of row -->
    <div class="row mb-3 mt-4">
      <div class="col-4 form-group">
        <label for="subject_changes" class="form-label">Subject Changes:</label>
        <input type="number" placeholder="Subject changes value" 
               class="form-control" name="subject_changes" min="0" max="1" 
               value="0" id="subject_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="school_changes" class="form-label">School Changes:</label>
        <input type="number" placeholder="School Change value" 
               class="form-control" name="school_changes" min="0" max="1"
               value="0" id="school_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="marks_lock_changes" class="form-label">
            Marks Lock Changes:
        </label>
        <input type="number" placeholder="Marks Lock Change value" 
               class="form-control" name="marks_lock_changes" min="0" max="1"
               value="0" id="marks_lock_changes" 
               required>
      </div>
    </div> <!-- end of row -->
    <div class="row mb-3 mt-4">
      <div class="col-4 form-group">
        <label for="permission_changes" class="form-label">
            Permission Changes:
        </label>
        <input type="number" placeholder="Permission Change value" 
               class="form-control" name="permission_changes" min="0" max="1"
               value="0" id="permission_changes" 
               required>
      </div>
      <div class="col-4">
        <input type="submit" name="add" value="Add" class="btn btn-primary mt-4">
      </div>
    </div> <!-- row end -->
  </form>
</div>


<?php Page_close(); ?>