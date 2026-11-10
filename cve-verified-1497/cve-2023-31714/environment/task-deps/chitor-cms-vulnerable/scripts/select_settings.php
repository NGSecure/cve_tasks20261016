<?php
session_start();

require_once '../sand_box.php';
$link=$LINK;
echo "<h3 class='text-center'>Existing Employees</h3>";
$q="SELECT User_Id from setting";
$exe=mysqli_query($link, $q);
echo "<table class='table table-stripped table-hover'>
        <tr>
            <th>User Id</th>
            <th>Name</th>
            <th>Edit</th>
        </tr>";
while ($exer=mysqli_fetch_assoc($exe)) {
    $user_id=$exer['User_Id'];
    $q2="SELECT Id,Name from employees WHERE Id='$user_id'";
    $exe2=mysqli_query($link, $q2);
    while ($exer2=mysqli_fetch_assoc($exe2)) {
        $id=$exer2['Id'];
        $name=$exer2['Name'];
        echo "<tr><td> $id </td> <td> $name </td>
        <td><a href='permissions.php?select=setting&user_id=$user_id'>Edit</td><tr>";
    }
}
"<table>";