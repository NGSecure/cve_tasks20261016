<?php

/**
 * Configuration of Website.
 * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Khan <abc@examp.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link None
 **/
session_start();
  require_once 'sand_box.php';
  $link=$LINK;
  Page_Header('Delete Student');

if ($STUDENT_CHANGES=="0") {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}
?>
</head>
<body class="background">
  <?php  require_once 'nav.html';?>
  <div class="container-fluid">
      <div class="bg-warning text-center">
        <h4>Delete Student</h4>
      </div>
    <form action="#" method="GET">
      <div class="row">
        <div class="col-sm-3">
          <label for="name" class="h5">
             Type Roll Number to remove/Struck off:</label>
        </div>
        <div class="col-sm-4"><input type="number" class="form-control"
             id="rollno" name="roll_no" required placeholder="Type Roll No" min="1" 
             value="<?php 
                if (isset($_GET['roll_no'])) { 
                    echo $_GET['roll_no'];
                }
                ?>">
        </div>
      <div class="col-sm-2">
        <input class="btn btn-danger" type="submit" name="submit" value="Delete">
      </div>
    </div> <!-- End of Row -->
  </form>
</div>  <!-- End of Container -->
      <?php
        /* Rules for Naming add under score between two words. */
        if (isset($_GET['submit'])) {
            $roll_no=$_GET['roll_no'];
            $roll_no=Validate_input($roll_no);
            $qname="Select Name,FName from students_info where Roll_No=".$roll_no;
            $exe_name=mysqli_query($link, $qname);
            $name_data=mysqli_fetch_assoc($exe_name);
            $name=$name_data['Name'];
            $fname=$name_data['FName'];


            $q="update students_info set status=0 WHERE Roll_NO=".$roll_no;
            $exe=mysqli_query($link, $q);
            if ($exe) {
                echo "<div class='alert alert-success container' role='alert'>
                      Roll No $roll_no  $name  $fname  Deleted Successfully  </div>";
                header("Refresh:5; url=delete_student.php");
            } else {
                echo "Error in Delete Query". mysqli_error($link);
            }
        }
        ?>
    <?php Page_close(); ?>
