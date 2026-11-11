<?php
/**
 * Exam seating Plan
 * php version 8.1
 *
 * @category Exam
 *
 * @package None
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com
 **/

require_once 'sand_box.php';
$link=$LINK;
?>
  <?php Page_header('Seating Plan'); ?>
</head>
<body>
<div class="row">
    <div class="col-md-2">

        <?php
        $q="SELECT Roll_No,Name from Students_Info WHERE Status=1 AND Class='6th' AND School='$SCHOOL_NAME'";
        $exe=mysqli_query($link, $q);
        $i=1;
        echo "<p>Class=6th</p>";
        echo '<p>S#  Roll# Name</p>';
        while($exer=mysqli_fetch_assoc($exe)) {

            echo "<p>". $i ." ".$exer['Roll_No'] ." ".$exer['Name']." "."</p>";
            $i++;
        }
        ?>

    </div>
    <div class="col-md-2">

    <?php
        $q="SELECT Roll_No,Name from Students_Info WHERE Status=1 AND Class='7th' AND School='$SCHOOL_NAME'";
        $exe=mysqli_query($link, $q);
        $i=1;
        echo "<p>Class=7th</p>";
        echo '<p>S#  Roll# Name</p>';
    while($exer=mysqli_fetch_assoc($exe)) {

        echo "<p>". $i ." ".$exer['Roll_No'] ." ".$exer['Name']." "."</p>";
        $i++;
    }
    ?>

</div>
<div class="col-md-2">
<?php
$q="SELECT Roll_No,Name from Students_Info WHERE Status=1 AND Class='8th' AND School='$SCHOOL_NAME'";
        $exe=mysqli_query($link, $q);
        $i=1;
        echo "<p>Class=8th</p>";
        echo '<p>S#  Roll# Name</p>';
while($exer=mysqli_fetch_assoc($exe)) {

    echo "<p>". $i ." ".$exer['Roll_No'] ." ".$exer['Name']." "."</p>";
    $i++;
}
?>

</div>

<div class="col-md-2">
<?php
$q="SELECT Roll_No,Name from Students_Info WHERE Status=1 AND Class='9th A' AND School='$SCHOOL_NAME'";
        $exe=mysqli_query($link, $q);
        $i=1;
        echo "<p>Class=9th A</p>";
        echo '<p>S#  Roll# Name</p>';
while($exer=mysqli_fetch_assoc($exe)) {

    echo "<p>". $i ." ".$exer['Roll_No'] ." ".$exer['Name']." "."</p>";
    $i++;
}
?>

</div>

<div class="col-md-2">
<?php
$q="SELECT Roll_No,Name from Students_Info WHERE Status=1 AND Class='9th B' AND School='$SCHOOL_NAME'";
        $exe=mysqli_query($link, $q);
        $i=1;
        echo "<p>Class=9th B</p>";
        echo '<p>S#  Roll# Name</p>';
while($exer=mysqli_fetch_assoc($exe)) {

    echo "<p>". $i ." ".$exer['Roll_No'] ." ".$exer['Name']." "."</p>";
    $i++;
}
?>

</div>

<div class="col-md-2">
<?php
$q="SELECT Roll_No,Name from Students_Info WHERE Status=1 AND Class='10th A' AND School='$SCHOOL_NAME'";
        $exe=mysqli_query($link, $q);
        $i=1;
        echo "<p>Class=10th A</p>";
        echo '<p>S#  Roll# Name</p>';
while($exer=mysqli_fetch_assoc($exe)) {

    echo "<p>". $i ." ".$exer['Roll_No'] ." ".$exer['Name']." "."</p>";
    $i++;
}
?>

</div>



</div>
