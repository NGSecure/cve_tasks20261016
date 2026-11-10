<?php
/**
 * Calculate position of students
 * php version 8.1
 *
 * @category Exam
 * @package  None
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link None
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;
Page_header("Calculate Position");
$selected_class=$CLASS_NAME;
$selected_school=$SCHOOL_NAME;
?>
</head>
<?php
if (isset($_POST['submit'])) {
          $class_name=$_POST['class_exam'];
          $class_name=Validate_input($class_name);
          
          $school_name=$_POST['school'];
          $school_name=Validate_input($school_name);
          
          $em=Empty_Position_table();

    if ($em) {
        echo "Table is cleaned Successfully";
        $cp=Calculate_position($class_name, $school_name);
        if ($cp) {
                  echo "Total marks of $class_name of $school_name
                        entered into table successfully";
              Add_Data_Into_position();
        }
    }


}
?>
<body>
    <?php  require_once 'nav.html';?>
  <div class="bg-warning text-center">
    <h4>Class Position Calculation</h4>
  </div>
  <div class="container-fluid">
    <form action="#" method="POST">
      <div class="row">
        <?php Select_class($selected_class); ?>
        <?php Select_school($selected_school);?>
      </div>
      <button type="submit" name="submit" class="btn btn-primary mt-3">
        Submit
      </button>
    </form>
  </div>
<?php Page_close(); ?>

