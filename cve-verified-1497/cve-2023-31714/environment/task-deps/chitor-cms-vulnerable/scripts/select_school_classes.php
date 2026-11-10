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
require_once '../db_connection.php';

$link=connect();
if (isset($_GET['school_name'])) {
    $school_name=$_GET['school_name'];
    $school_name=Validate_input($school_name);
  
    /**
     *  Showing the Combo box with Class Names
     *
     * @param string $school_name which column data you want to get.
     *
     * @return $selected_class For example 6th 7th etc
     */
    function Select_Classes_By_School_id($school_name) 
    {
        global $link;
        $path=getcwd();
        $main_dir=dirname($path, 1);
        $chunks = explode('\\', $main_dir);
        $chunks_length=count($chunks);
        $my_directory=$chunks[$chunks_length-1];
        //echo $my_directory;
        $school_id=Convert_School_Name_To_id($school_name);
        $q="SELECT Id,Name,Status from school_classes WHERE School_Id='$school_id'";
        $exe=mysqli_query($link, $q) or die('error in  class selection');
        echo "<table class='table table-striped table-hover table-bordered'>
                <tr>
                  <td scope='col'>Class Name </td>
                  <td scope='col'>Status</td>
                </tr>";
        while ($exer=mysqli_fetch_assoc($exe)) {
            $name=$exer['Name'];
            $value=$exer['Status'];
            $id= $exer['Id'];
            if ($value==1) {
                $status= 'Active';
            } else {
                $status= 'Inactive';
            }
          
            echo "<tr>
            <td>
            <a href=http://localhost/$my_directory/edit_school_class.php?id=$id>
            $name</a>
            </td>
            <td>$status</td></tr>";
        }
        echo "</table>";
    }
    $school_classes=Select_Classes_By_School_id($school_name);
}



if (isset($_GET['tech'])) {

    $school_name=$_GET['school'];
    $school_name=Validate_input($school_name);
    $school_id=Convert_School_Name_To_id($school_name);
     $q="SELECT Name from school_classes WHERE School_Id=$school_id";
    $exe=mysqli_query($link, $q) or die('error in  class selection');
    echo "<option value''>Select Option</option>";
    while ($exer=mysqli_fetch_assoc($exe)) {
        $name=$exer['Name'];
        echo "<option value'$name'>$name</option>";
    }
    
}
?>