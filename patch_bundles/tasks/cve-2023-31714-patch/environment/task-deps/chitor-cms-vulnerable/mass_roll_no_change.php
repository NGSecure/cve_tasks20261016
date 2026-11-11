<?php
/**
 * Update Roll Numbers
 * php version 8.1
 *
 * @category Roll_No
 *
 * @package No
 *
 * @author Khan <abc@examp.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/

/**
 * Formula For Assigning Roll No
 * First Digit Current Year=21
 * Second digit class 10
 * For A=1
 * For B=2
 * Third digit Class No 00
 **/
require_once 'sand_box.php' ;
$link=$LINK;
// First Change the DOit TO make it work. It is disabled
// so that accident do not occur.
 Page_header('Mass Roll No Change'); ?>
</head>
<body>
<?php
require_once 'nav.html';
$doit=0;

if ($doit==1) {
    $r=2110101;
    for ($i=101;$i<=152;$i++) {
        $new_roll=$i;
        $sql = "UPDATE students_info SET Roll_No=$new_roll WHERE Roll_No=$i-1";
        $exe = mysqli_query($link, $sql);
        if ($exe) {
            echo "$sql"." Updated  Successfully". "<br>";
        } else {
            echo 'error in submit';
        }
        $r++;
    }
} else {
    echo "Page is inactive.";
}

 Page_close();
?>
