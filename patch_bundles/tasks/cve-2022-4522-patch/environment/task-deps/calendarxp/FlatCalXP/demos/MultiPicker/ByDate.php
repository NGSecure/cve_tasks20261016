<script language="php">
Function GetDates()
{
	global $HTTP_POST_VARS;
	$dateList=$HTTP_POST_VARS["allSelected"]; 
	$dates = split( ',', $dateList);
	$tempstr="Date list(sorted by user selected):"."<br>"; 
	for ($i = 0; $i < count($dates); $i++) {
		$tempstr=$tempstr.$dates[$i]."<br>";
	}
	return $tempstr;
	
}

</script>
<?php
		$returndate=GetDates();
		echo $returndate;
?>