<?php
/**
 * Edit Student Details.
 * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Waqas <abc@examp.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link None
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;
Page_header('Edit Student');
  
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
      <h4>Edit Student Information</h4>
    </div>
    <form action="#" method="GET">
      <div class="row m-3">
        <div class="col-sm-2">
          <label for="name" class="h5 form-label">
            Type roll number to load data:
          </label>
        </div>
        <div class="col-sm-4">
          <input type="number" class="form-control" id="rollno"
                  name="roll_no" required placeholder="Type Roll No" min="1">
        </div>
        <div class="col-lg-2">
          <input type="submit" name="submit" 
             value="Search" class="btn btn-primary">
        </div>
      </div> <!-- end of row -->
    </form>
  </div>   <!-- End of Container -->

  
      <?php
        /* Rules for Naming add under score between two words. */
        if (isset($_GET['submit'])) {

            $roll_no=$_GET['roll_no'];
            $roll_no=Validate_input($roll_no);

            $q="Select * from students_info WHERE Roll_NO=".$roll_no;
            $qd=mysqli_query($link, $q);
            if (mysqli_num_rows($qd)==0) {
                echo '<h5 class="text-danger container"> 
                          Roll Number Not Found! Try Again. 
                      </h5>';
                exit();
            }
            $data=mysqli_fetch_assoc($qd);

            /* First letter of variable is in lower case */
            $roll_no=$data['Roll_No'];
            $name=$data['Name'];
            $fname=$data['FName'];
            $school=$data['School'];
            $class=$data['Class'];
            $dob=$data['Dob'];

            $admission_no=$data['Admission_No'];
            $date_admission=$data['Admission_Date'];
            $mobile_no=$data['Mobile_No'];
            $father_cnic=$data['Father_Cnic'];
            $form_b=$data['Student_Form_B'];
            $status=$data['Status'];
            $gender=$data['Gender'];
            ?>
      
    <div class="container-fluid">
      <h5 class="bg-info p-2 text-center">
        Data of Roll No <?php echo $roll_no;?>
      </h5>
    <form class="p-3" action="#" method="POST" >
        <div class="row mt-1 p-3 bg-white">   <!-- Row 1 start -->
            <!-- Hidden roll no -->
          <input type="hidden" class="form-control" id="rollno" name="roll_no"
                 placeholder="type Roll No" min="1"
                 value="<?php echo $roll_no  ?>" autofocus required
                 onfocusout="check_roll_no_student()">
                 <!-- Column 1 -->
          <div class="form-group col-md-4">
            <label for="name" class="form-label">Name:</label>
            <input type="text" class="form-control" id="name" name="name"
                   value="<?php echo $name  ?>" placeholder="type Name"required>
          </div>
            <div class="form-group col-md-4">
              <label for="fname" class="form-label">Father Name:</label>
              <input type="text" class="form-control" id="fname" name="fname"
              value="<?php echo $fname ?>" placeholder="type Father Name" required>
            </div>
              <div class="form-group col-md-4">
              <label for="dob" class="form-label">Date of Birth</label>
              <input type="date" class="form-control" id="dob" name="dob"
              value="<?php echo $dob  ?>" placeholder="type date of birth">
            </div>
          </div> <!-- End of Row 1 -->
          <div class="row mt-1 p-3 bg-white">
            <div class="form-group col-md-4">
              <label for="admission_no" class="form-label">Admission No</label>
              <input type="number" class="form-control" id="admission_no"
              name="admission_no" value="<?php echo $admission_no  ?>"
              placeholder="type date of admission no">
            </div>
            <div class="form-group col-md-4">
              <label for="admission" class="form-label">Admission Date</label>
              <input type="date" class="form-control" id="admission"
                     name="date_admission"  value="<?php echo $date_admission  ?>"
                     placeholder="type date of admission">
            </div>
            <div class="form-group col-md-4">
              <label for="mobile" class="form-label">Mobile No</label>
              <input type="text" class="form-control" id="mobile" name="mobile_no"
                     value="<?php echo $mobile_no  ?>" placeholder="type mobile no" >
            </div>
          </div> <!-- End of Row 2 -->
          <div class="row mt-1 p-3 bg-white">
            <div class="form-group col-md-4">
              <label for="fcnic" class="form-label">Fathere CNIC </label>
              <input type="text" class="form-control" id="fcnic" name="fcnic"
                      value="<?php echo $father_cnic ?>" 
                      placeholder="type father cnic no" >
            </div>
            <div class="form-group col-md-4">
              <label for="formb" class="form-label"> Student Form B</label>
              <input type="text" class="form-control" id="formb" name="formb"
                     value="<?php echo $form_b ?>" 
                     placeholder="type student form b no" >
            </div>
            <div class="form-group col-md-4">
              <label  class="form-lable" for="formb" tooltip="1 means active,
                0 means struck off, 
                if a person is struck off it will not we shown in award list etc">
                Status
              </label>
              <input type="number" class="form-control" id="status" min="0" max="1"
                     name="status" value="<?php echo $status ?>"
                     placeholder="1 for active 0 for not active" >
            </div>
          </div> <!-- End of Row 3 -->
          <input type="hidden" name="school" value="<?php echo $school ?>">
          <input type="hidden" name="class" value="<?php echo $class ?>">
          <div class="row mt-1 p-3 bg-white">  <!-- Row 4 started -->
            <?php
            $selected_class=$class;
            $selected_school=$school;
             Select_class($selected_class);
             Select_school($selected_school);
            ?>
          </div>
          <div class="row mt-1 p-3 bg-white">
          <div class="form-group col-md-4">
              <label for="roll_no" class="form-label">Roll No</label>
              <input type="number" class="form-control" id="roll_no" name="roll_no_d"
                     value="<?php echo $roll_no  ?>" placeholder="type Roll no" >
            </div>
            <div class="form-group col-md-4">
            <label for="gender" class="form-label">Gender</label>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="gender" value="Male" 
                id="male_id" <?php if ($gender=="Male") { echo "checked";} ?> >
                <label class="form-check-label" for="male_id">Male</label>
              </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="gender" value="Female" 
              id="female_id" <?php if ($gender=="Female") { echo "checked";} ?> >
              <label class="form-check-label" for="female_id">Female</label>
            </div>
          </div>  
        </div>
        
          <button type="submit" name="update" class="btn btn-primary mt-3">
              Update
            </button> 
          </form>
        <?php }  ?>
    </div>  <!-- End of container fluid -->
    <?php
    if (isset($_POST['update'])) {
                $roll_no=$_POST['roll_no'];
                $roll_no=Validate_input($roll_no);
                
                $name=$_POST['name'];
                $name=Validate_input($name);
                
                $fname=$_POST['fname'];
                $fname=Validate_input($fname);

                $school=$_POST['school'];
                $school=Validate_input($school);
                
                $class=$_POST['class_exam'];
                $class=Validate_input($class);

                $dob=$_POST['dob'];
                $dob=Validate_input($dob);
        if ($dob=='') {
            $default='01/01/1900';
            $date = strtotime($default);
            $dob = date('Y-m-d', $date);
        }
                $admission_no=$_POST['admission_no'];
                $admission_no=Validate_input($admission_no);

                $date_admission=$_POST['date_admission'];
                $date_admission=Validate_input($date_admission);

        if ($date_admission=='') {
            $default='01/01/1900';
            $date = strtotime($default);
            $date_admission=date('Y-m-d', $date);
        }
                $mobile_no=$_POST['mobile_no'];
                $mobile_no=Validate_input($mobile_no);

                $father_cnic=$_POST['fcnic'];
                $father_cnic=Validate_input($father_cnic);

                $form_b=$_POST['formb'];
                $form_b=Validate_input($form_b);

                $status=$_POST['status'];
                $status=Validate_input($status);

                $roll_no_d=$_POST['roll_no_d'];
                $roll_no_d=Validate_input($roll_no_d);

                $gender=$_POST['gender'];
                $gender=Validate_input($gender);

               $q="UPDATE students_info SET Name = '$name',
                                             FName='$fname',
                                             School='$school',
                                             Class='$class',
                                             Dob='$dob',
                                             Admission_No='$admission_no',
                                             Admission_Date='$date_admission',
                                             Mobile_No='$mobile_no',
                                             Father_Cnic = '$father_cnic',
                                             Student_Form_B =  '$form_b',
                                             Roll_No='$roll_no_d',
                                             Gender='$gender',
                                             Status='$status'
                                            WHERE Roll_No=$roll_no";

            $exe=mysqli_query($link, $q) or die('error'.mysqli_error($link));
        if ($exe) {
            $message= $roll_no."Updated Successfully";
            $alert_type='success';
            Show_alert($message, $alert_type);
        } else {
            echo 'error in submit';
        }

    }
    ?>
    <!-- Load Students Start -->
    <div class="container bg-white" id="show_selected_class_students">
    </div>
    <!-- Load Student End -->
 <script type="text/javascript" src="js/load_students.js">
  <?php Page_close(); ?>
