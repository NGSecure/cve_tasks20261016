<?php
/**
 * Add Marks of Students
 * php version 8.1
 *
 * @category Adfsad
 *
 * @package Adf
 *
 * @author Khan <abc@examp.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;
Page_header('Class Test');
?>
</style>
</head>
<body>
<div class="container">
  <form class="no-print" action="#" method="GET" >
    <div class="row">
      <?php
        // Default values are coming from Config.php
        $selected_class=$CLASS_NAME;
        $selected_school=$SCHOOL_NAME;
        select_class($selected_class);
        select_school($selected_school);
        ?>
      </div>
      <button type="submit" name="submit" class="btn btn-primary mt-1">
        Show Test List
      </button>
    </form>
  </div>
<?php
if (isset($_GET['submit'])) {
    
    $class_name=$_GET['class_exam'];
    $class_name=Validate_input($class_name);
    
    $school_name=$_GET['school'];
    $school_name=Validate_input($school_name);
} else {
    $class_name=$CLASS_NAME;
    $school_name=$SCHOOL_NAME;
}  
?>
<div class="container">
    <div class="row m-t-1">
        <div class="log col-sm-2">
            <img src="./images/khyber.png" alt="khyber">
        </div>
        <div class="header text-center col-sm-8">
            <h2>GOVT. HIGHER SECONDARY SCHOOL </h2>
            <h2>CHITOR, DISTRICT SWAT  </h2>
            <h5>Class Test </h5>
            <h5> Class: <?php echo $class_name; ?>
                <!-- Date: <?php  echo date('d-m-Y') ?> -->
                Subject: English
            </h5>
        </div>
        <div class="logo2 col-sm-2">
        <img src="./images/kpesed.png" alt="kpesed.png">
        </div>
    </div>
</div>

<div class="container">
    <table class="table table-bordered" id="award-list">
        <thead>
    <tr>
        <th>Serial No</th>
        <th>Name </th>
        <th>Father Name</th>
         <th>Test 1</th>
         <th>Test 2</th>
         <th>Test 3</th>
         <th>Test 4</th>
         <th>Test 5</th>
         <th>Test 6</th>
         <th>Test 7</th>
         <th>Test 8</th>
         <th>Test 9</th>
         <th>Test 10</th>
    </tr>
</thead>
        <?php
        $q="Select * from students_info WHERE
        Class='$class_name'
        AND
        School='GHSS CHITOR'
        AND
        Status='1'
        Order by
        Roll_No ASC";
        $qr = mysqli_query($link, $q) or die('Error in Q 1'.mysqli_error($link));
        $i=1;
        while ($qfa=mysqli_fetch_assoc($qr)) {
            echo  '<tr>
            <td>'.$i. '</td>
            <td>'.$qfa['Name']. '</td>
            <td>'.$qfa['FName']. '</td>';
            for ($num=1;$num<=10;$num++) {
                echo '<td> </td>';
            }
             echo '</tr>';
            $i++;
        }
        ?>
    </table>
</div>

<?php page_close(); ?>
