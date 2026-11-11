<?php
  /**
   * All the general functions of the website resides here.
   * php version 8.1
   *
   * @category Select
   *
   * @package Functions
   *
   * @author Waqas Ahmad <waqaskanju@gmail.com>
   *
   * @license http://www.abc.com MIT
   *
   * @link Adfas
   **/
require_once '../sand_box.php';
$link=$LINK;
$path=getcwd();
        $main_dir=dirname($path, 1);
        $chunks = explode('\\', $main_dir);
        $chunks_length=count($chunks);
        $my_directory=$chunks[$chunks_length-1];
$q="SELECT Id,Name,Status from subjects";
$exe=mysqli_query($link, $q) or die('error in  subject selection');
echo "<table class='table table-striped table-hover table-bordered'>
<tr>
  <th scope='col'>Id </th>
  <th scope='col'>Subject Name </th>
  <th scope='col'>Status</th>
</tr>";
while ($exer=mysqli_fetch_assoc($exe)) {
    $name=$exer['Name'];
    $value=$exer['Status'];
    $id=$exer['Id'];
    if ($value==1) {
        $status= 'Active';
    } else {
        $status= 'Inactive';
    }
            echo "<tr>
            <td>
            $id
            </td>
            <td>
            <a href=http://localhost/$my_directory/edit_subject.php?id=$id>
            $name</a>
            </td>
            <td>$status</td></tr>";
}
echo "</table>";
?>