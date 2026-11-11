<script language="php">
Function GetRanges()
{
	global $HTTP_POST_VARS;
	$dateRange=$HTTP_POST_VARS["allSelected"]; 
	$dates = split('\[', $dateRange);
	$tempstr="Date Ranges:"."<br>"; 
	for ($i = 0; $i < count($dates); $i++) {
		if (strcmp($dates[$i],"")!=0) {
			$str=substr($dates[$i],0,-1);
			$ft=split(',', $str);
			$tempstr=$tempstr.'from: '.$ft[0].' to: '.$ft[1]."<br>";
		}
	}
	return $tempstr;
	
}

</script>
<?php
		$returndate=GetRanges();
		echo $returndate;
?>