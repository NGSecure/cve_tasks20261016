<?php
/**
 * Update Student Class
 *  * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Waqas <waqaskanju@gmail.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link www.waqaskanju.com
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;
?>
<?php
  Page_header("Update Student Class");
?>
<script>
  // This is default function. Here i am using it To update student class.
  function view_existing_subjects(){
    update_student_class();
  }
</script>
</head>
<body>
<?php  require_once 'nav.html';?>
  <div class="bg-primary text-white text-center">
    <?php

    $selected_school=$SCHOOL_NAME;
    if (isset($_GET['submit'])) {
        
        $class=$_GET['Class'];
        $class=Validate_input($class);
    } else {
            $class=$CLASS_NAME;
    }
    if ($STUDENT_CHANGES!=1) {
        echo '<div class="bg-danger text-center"> Not allowed!! </div>';
        exit;
    }
    ?>
    <h4 class="bg-warning">
      Form for Changing Class: <?php echo $class;?>
      Students Class Name
      Selected School <?php echo $selected_school ?>
    </h4>
  </div>
  
<div class="container-fluid">
<?php


    $q="SELECT Roll_No,Name,FName,Class from students_info 
    WHERE Class='$class' AND School='$selected_school' AND Status='1' 
    order by Roll_No ASC";

    $exe=mysqli_query($link, $q);
    $tab_index=1;
    $school_name=$SCHOOL_NAME;
    $school_id=Convert_School_Name_To_id($school_name);
    $class_names_array=Select_Single_Column_Array_data(
        "Name", "school_classes", "School_Id", "$school_id"
    );
    while ($qfa=mysqli_fetch_assoc($exe)) {
        $name=$qfa['Name'];
        $roll_no=$qfa['Roll_No'];
        $current_class=$qfa['Class'];
        ?>

    <form class="" action="#" id="<?php echo $roll_no;?>_form">
      <div class="row mb-3">
        <!-- tab index used as serial no of form. in addition to tab index.  -->
      <div class="col-sm-1">
          <?php echo $tab_index; ?>
        </div>
        <!-- Roll Number Read only that is why name field empty-->
        <div class="col-sm-1">
          <input type="number" class="form-control-plaintext"
                  value="<?php echo $roll_no ?>" readonly>
        </div>
        <!-- Student Name Read only that is why name field empty -->
        <div class="col-sm-1">
          <input type="text" class="form-control-plaintext" 
            readonly value="<?php echo $name ?>">
        </div>
        <!-- for selecting class; rollnoclass -->
        <div class="col-sm-1">
          <select class='form-control' name='class_name' 
          id="<?php echo $roll_no;?>_class_name" tabindex="<?php echo $tab_index;?>"
          required onchange='update_student_class(<?php echo $roll_no;?>)'>
          <option value=''>Select Class </option>
          <?php 
                $selected_class=$current_class;
            for ($i=0;$i<count($class_names_array);$i++) {
                echo "<option value='$class_names_array[$i]'";
                if ($selected_class==$class_names_array[$i]) {
                    echo "selected";
                }
                echo"> $class_names_array[$i] </option> ";
            }
            echo "   </select>";
            ?>
        </div>
        <!-- For showing Response  rollresponse -->
        <div class="col-sm-8 ">
          <span id="<?php echo $roll_no;?>_response" 
          class="form-control-plaintext"></span>
          <!-- For Selecing roll no. -->
        </div>
      </div> <!-- End of Row -->
    </form>
        <?php
        $tab_index++;
    }
    ?>
    
    </div>  <!-- End of Container -->
    <script src="js/update_class_name.js">
    </script>
<?php Page_close(); ?>
