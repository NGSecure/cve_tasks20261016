<?php
/**
 * Permission
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

if ($PERMISSION_CHANGES!=1) {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}

/* Rules for Naming add under score between two words. */
if (isset($_POST['update'])) {
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

    $user_id=$_POST['user_id'];
    $user_id=Validate_input($user_id);


    $q="Update setting SET 
        Student_Changes=$student_changes,
        Batch_Marks_Changes=$batch_marks_changes,
        Single_Marks_Changes=$single_marks_changes,
        Subject_Changes=$subject_changes,
        School_Changes=$school_changes,
        Marks_Lock_Changes=$marks_lock_changes,
        Permission_Changes=$permission_changes  
        WHERE User_Id='$user_id'";
    
    $exe=mysqli_query($link, $q) or
    die('Error in School Updation '. mysqli_error($link));
    if ($exe) {
          echo "Permission updated";
    } else {
          echo "Error in Updation";
    }
}
?>
  <?php Page_header('Edit Permission'); ?>
</head>
<body>
<?php 

if (isset($_REQUEST['select'])) {
    $user_id=$_REQUEST['user_id'];
    $user_id=Validate_input($user_id);
    $q="SELECT * from setting WHERE user_id='$user_id'";
    $exe=mysqli_query($link, $q);
    $exer=mysqli_fetch_assoc($exe);
    $student_changes=$exer['Student_Changes'];
    $batch_marks_changes=$exer['Batch_Marks_Changes'];
    $single_marks_changes=$exer['Single_Marks_Changes'];
    $subject_changes=$exer['Subject_Changes'];
    $school_changes=$exer['School_Changes'];
    $marks_lock_changes=$exer['Marks_Lock_Changes'];
    $permission_changes=$exer['Permission_Changes'];
    ?>
    <div class="container-fluid">
  <h3 class="text-center bg-warning">Change Permissions</h3>
  <form class="p-3" method="POST" action="#">
    <div class="row mb-3">
      <div class="col-4 form-group">
        <label for="student_changes" class="form-label">Student Change:</label>
        <input type="number" placeholder="Student changes value" 
               class="form-control" name="student_changes" min="0" max="1" 
               value="<?php echo $student_changes;?>" id="student_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="batch_marks_changes" class="form-label">
            Batch Marks Changes:
        </label>
        <input type="number" placeholder="Batch Marks Change value" 
               class="form-control" name="batch_marks_changes" min="0" max="1"
               value="<?php echo $batch_marks_changes;?>" 
               id="batch_marks_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="single_marks_changes" class="form-label">
            Single Marks Changes:
        </label>
        <input type="number" placeholder="Single Marks Change value" 
               class="form-control" name="single_marks_changes" min="0" max="1"
               value="<?php echo $single_marks_changes;?>" id="single_marks_changes" 
               required>
      </div>
    </div> <!-- end of row -->
    <div class="row mb-3">
      <div class="col-4 form-group">
        <label for="subject_changes" class="form-label">Subject Changes:</label>
        <input type="number" placeholder="Subject changes value" 
               class="form-control" name="subject_changes" min="0" max="1" 
               value="<?php echo $subject_changes;?>" id="subject_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="school_changes" class="form-label">School Changes:</label>
        <input type="number" placeholder="School Change value" 
               class="form-control" name="school_changes" min="0" max="1"
               value="<?php echo $school_changes;?>" id="school_changes" required>
      </div>
      <div class="col-4 form-group">
        <label for="marks_lock_changes" class="form-label">
            Marks Lock Changes:
        </label>
        <input type="number" placeholder="Marks Lock Change value" 
               class="form-control" name="marks_lock_changes" min="0" max="1"
               value="<?php echo $marks_lock_changes;?>" id="marks_lock_changes" 
               required>
      </div>
    </div> <!-- end of row -->
    <div class="row mb-3">
      <div class="col-4 form-group">
        <label for="permission_changes" class="form-label">
            Permission Changes:
        </label>
        <input type="number" placeholder="Permission Change value" 
               class="form-control" name="permission_changes" min="0" max="1"
               value="<?php echo $permission_changes;?>" id="permission_changes" 
               required>
      </div>
      <div class="col-4">
        <input type="hidden" name="user_id" value="<?php echo $user_id;?>">
        <input type="submit" name="update" value="Update" 
               class="btn btn-primary mt-4">
      </div>
    </div> <!-- row end -->
  </form>
</div>

<?php  } ?>


  
  
<div id="existing_employees" class="container-fluid bg-white">
</div>
<script type="text/javascript" src="js/select_employees.js">
<?php Page_close(); ?>