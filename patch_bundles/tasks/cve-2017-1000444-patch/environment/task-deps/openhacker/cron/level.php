<?php 

$userid = $_SESSION["userid"];

$sql = "SELECT * FROM accounts WHERE id = '$userid'";
$result = $conn->query($sql);

while ($row = $result->fetch_assoc()){
	
	$experience = $row['experience'];
	$level = $row['level'];
	
}

$newlevel = $experience / $MEP4LVL; 

$sql2 = "UPDATE accounts SET level = $newlevel WHERE id = '$userid'";
$result2 = $conn->query($sql2);


?>