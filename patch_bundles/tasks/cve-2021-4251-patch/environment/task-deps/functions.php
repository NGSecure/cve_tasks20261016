<?php
include_once(AS__PATH.'/libs/random_compat/random.php');

function hasValue($var, $checkZero = false) {
	if(!isset($var)) {
		return false;
	}
	if(is_array($var)) {
		return false;
	}

	if($var === NULL || trim($var) == '') {
		return false;
	}
	if($checkZero) {
		if($var === 0 || $var == '0') {
			return false;
		}
	}
	return true;
}

function getFullURL() {

	$s = '';
	if(!empty($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] == "on") {
		$s = 's';
	}
	$protocol = substr(strtolower($_SERVER["SERVER_PROTOCOL"]), 0, strpos(strtolower($_SERVER["SERVER_PROTOCOL"]), "/")) . $s;
	$port = ($_SERVER["SERVER_PORT"] == "80") ? "" : (":" . $_SERVER["SERVER_PORT"]);
	$url = $protocol . "://" . $_SERVER['SERVER_NAME'] . $port . $_SERVER['REQUEST_URI'];

	return $url;
}


function getBaseURL() {
	return rtrim($_SESSION[AS_APP]['environment']['base_url'], '/');
}


function getThemePath($addpath = '') {

	$extended = $addpath;
	if(substr($extended, 0, 1) != '/') {
		$extended = '/' . $addpath;
	}

	return AS_WWW_PATH.'/theme/' . $_SESSION[AS_APP]['theme']['dirname'] . $extended;
}


function getThemeURL($addpath = '') {

	$extended = $addpath;
	if(substr($extended, 0, 1) != '/') {
		$extended = '/' . $addpath;
	}

	$base = getBaseURL();

	if(substr($base, -1)=='/') {
		$base = substr($base, 0, strlen($base)-1);
	}

	return $base . '/theme/' . $_SESSION[AS_APP]['theme']['dirname'] . $extended;
}


function convertArrayToCSV($array, $header_row = true, $col_sep = ",", $row_sep = "\n", $qut = '"') {
	if(!is_array($array) or !is_array($array[0])) {
		return false;
	}

	$output = '';
	$headers = array();

	//Header row.

	foreach($array[0] as $key=> $val) {
		//Escaping quotes.
		$key = str_replace($qut, "$qut$qut", $key);
		if($header_row) {
			$output .= "$col_sep$qut$key$qut";
		}
		$headers[] = $key;
	}

	if($header_row) {
		$output = substr($output, 1) . $row_sep;
	}

	//Data rows.
	foreach($array as $key=> $val) {
		$tmp = '';
		//foreach ($val as $cell_key => $cell_val)
		foreach($headers as $ik) {
			$thiscellval = isset($val[$ik]) ? $val[$ik] : '';
			$cell_val = str_replace($qut, "$qut$qut", $thiscellval);
			if(is_numeric($cell_val) || empty($cell_val)) {
				$tmp .= "$col_sep$cell_val";
			}
			else {
				$tmp .= "$col_sep$qut$cell_val$qut";
			}
		}
		$output .= substr($tmp, 1) . $row_sep;
	}

	return trim($output);
}


//getRandomString requires either PHP7 OR include_once(AS__PATH.'/libs/random_compat/random.php');
function getRandomString($length = 8, $upper = true, $lower = true, $numbers = true, $symbols = false) {

	$alphabet = '';
	$randomStr = '';

	if($upper) {
		$alphabet .= "ABCDEFGHIJKLMNPQRSTUVWXYZ";
	}
	if($lower) {
		$alphabet .= "abcdefghijklmnpqrstuvwxyz";
	}
	if($numbers) {
		$alphabet .= "123456789";
	}
	if($symbols) {
		$alphabet .= '{}()[]#:;^!|&,.?_`~@$%/\=+-*';
	}

	$alphamax = strlen($alphabet) - 1;

	for($i = 0; $i < $length; $i++) {
		$randomStr .= $alphabet[random_int(0, $alphamax)];
	}

	return $randomStr;
}

/**
 * @deprecated Deprecated as of r90. Use httpError() instead.
 */
function error($status, $redirectToError=true) {
	if(!headers_sent()) {
		header("Status: " . $status);
	}
	if($redirectToError) {
		include(AS_WWW_PATH."/error.php");
	}
	die();
}

/**
 * Sets the http response code and optionally overwrites output buffer with error template
 * @param int $statusCode HTTP Status Code to return. Ex: 404
 * @param bool $replaceOBwError If true, overtakes the request (nothing further in your code will run) and places error page in output buffer. If false, output buffer remains in existing state. When true, $die is ignored and the error page handles the rest of the request.
 * @param bool $die If true, function dies after setting status code and optionally including error page. If false, caller must handle the error output.
 * @return int new HTTP status code
 */
function httpError($statusCode, $replaceOBwError=true, $die=true) {
	if(!headers_sent()) {
		http_response_code($statusCode);
	}
	if($replaceOBwError) {
		include(AS_WWW_PATH."/error.php");
	}
	if($replaceOBwError || $die) {
		die();
	}
}


function pie($v) {
	error_log('******PIE Function is being ran******');
	elog($v);
	echo '<pre>';
	var_dump($v);
	die();
}

function elog( $v ) {

	if(is_array($v) || is_object($v)) {
		$v = json_encode($v);
	}
	elseif(is_numeric($v)) {
		$v = (string) $v;
	}
	elseif(is_bool($v)) {
		$v = $v ? 'true' : 'false';
	}

	error_log( $v );

}

function urlExists($url) {
	$hdrs = @get_headers($url);

	echo @$hdrs[1] . "\n";

	return is_array($hdrs) ? preg_match('/^HTTP\\/\\d+\\.\\d+\\s+2\\d\\d\\s+.*$/', $hdrs[0]) : false;
}


function getXMLAsArray($src, $format = 'array') {
	$xml = simplexml_load_file($src);
	$json = json_encode($xml);
	if($format == 'json') {
		return $json;
	}
	elseif($format == 'array') {
		return json_decode($json, true);
	}
	elseif($format == 'object') {
		return json_decode($json, false);
	}
	else {
		return false;
	}
}

/**
 *
 * @param string $path Full path of directory to get files and directories from
 * @param bool $returnSimple [optional] Default=false; Set to true for flat list of full file paths
 * @param mixed $fileFilter  [optional] Default=null (no filter); Pass a string or string[] of three characters to get only files that use that extension (rather whose last three characters of extension matches)
 * @param mixed $dirFilter [optional] Default=null (no filter); Pass a string or string[] of a name of a directory to only return directories with that name (files and subdirectories are not included unless $returnAncestorsOnFilter is set to true)
 * @param bool $returnAncestorsOnFilter [optional] Default=false; Set to true to include the files and subdirectories of directories that match the $dirFilter in the response
 * @param bool $stripLongFilePath [optional] Default=false; Set to true to remove part of the full file path in the response. $stripPath MUST BE PROVIDED if this is true.
 * @param string $stripPath [optional] Default = ''; If $stripLongFilePath is true, you must provide a string that will be removed from the full file path in the response
 * @return mixed[]
 */
function ls($path, $returnSimple = false, $fileFilter=null, $dirFilter=null, $returnAncestorsOnFilter=false, $stripLongFilePath=false, $stripPath='') {

	$dir = array();

	if(substr($path, -1) != '/') {
		$path = $path . '/';
	}

	if($dirFilter!==null) {
		foreach($dirFilter as $dirFilterIndex=>$df) {
			$dirFilter[ $dirFilterIndex ] = strtolower($df);
		}
	}
	if($fileFilter!==null) {
		if(is_string($fileFilter)) {
			$fileFilter = array(strtolower($fileFilter));
		}
		foreach($fileFilter as $fileFilterIndex=>$ff) {
			$fileFilter[ $fileFilterIndex ] = strtolower($ff);
		}
	}

	if(!is_dir($path)) {
		return array();
	}

	if($handle = opendir($path)) {
		while(false !== ($entry = readdir($handle))) {
			if($entry != "." && $entry != ".." && $entry!='$RECYCLE.BIN' && $entry!='.quarantine' && $entry!='.tmb' && $entry!='Thumbs.db') {

				$isDIR = is_dir($path . $entry);

				$files = null;

				if($isDIR) {
					$filetype = 'dir';
					if($dirFilter===null || in_array(strtolower($entry), $dirFilter)) {
						$add = true;
					}
					else {
						$add = false;
					}

					if(($add && !$returnSimple) || $returnAncestorsOnFilter) {
						$files = ls($path . $entry, $returnSimple, $fileFilter, $dirFilter, $returnAncestorsOnFilter, $stripLongFilePath, $path);
					}
				}
				else {
					$filetype = 'file';
					if($fileFilter===null || in_array(strtolower(substr($entry, -3)), $fileFilter)) {
						$add = true;
					}
					else {
						$add = false;
					}
				}

				if($add || $files!==null) {
					if($returnSimple) {
						if($add) {
							$dir[] = $entry;
						}
						if($files!=null) {
							$dir = array_merge($dir, $files);
						}
					}
					else {

						$filePathFull = $path.$entry;

						if($stripLongFilePath) {
							if($stripPath=='') {
								$stripPath = $path;
							}
							$filePathFull = str_replace($stripPath, '', $filePathFull);
						}

						$dir[] = array(
							'name'=>$entry,
							'type'=>$filetype,
							'files'=>$files,
							'path'=>$filePathFull
						);
					}
				}

			}
		}
	}

	return $dir;
}

function lsPrint( $ls, $nested=0, $html='', $hrefBasePath='', $printLinks=false, $parent=null) {

if($nested>1) {
	error_log(json_encode($parent));
}
	$html.= '<ul class="ls ls-ul-nested-'.$nested.'">';

		foreach($ls as $item) {

				$html.= '<li class="ls-li ls-'.$item['type'].' ls-li-nested-'.$nested.'">';

					$html.= '<a class="ls-a ls-'.$item['type'].'" ';

					if($nested>1) {
						$path = $parent['path'].'/'.$item['name'];
					}
					else {
						$path = $item['path'];
					}

					if($item['type']=='file' && $hrefBasePath=='') {
						$html.= 'href="'.str_replace(AS_WWW_PATH, '', $path).'"';
					}
					elseif($item['type']=='file' && $hrefBasePath!='') {
						$html.= 'href="'.$hrefBasePath.base64_encode($path).'"';
					}
					$html.= '>'.$item['name'].'</a>';

					if($printLinks) {
						$html .= '<div>'.  getBaseURL().str_replace(AS_WWW_PATH, '', $path) .'</div>';
					}

					if(is_array($item['files']) && count($item['files'])>0) {
						$html = lsPrint($item['files'], $nested+1, $html, $hrefBasePath, false, $item);
					}

				$html.= '</li>';

		}

	$html.= '</ul>';

	return $html;
}

function lsPrintSelect($files, $html='') {
	foreach($files as $file) {
		if($file['type']=='dir') {
			$html .= '<optgroup label="'.$file['name'].'">';
			$html .= lsPrintSelect($file['files']);
			$html .= '</optgroup>';
		}
		else {
			$html .= '<option value="'.$file['path'].'">'.$file['name'].'</option>';
		}
	}

	return $html;
}

function view( $path ) {

	$path = trim($path, '/');

	$parts = explode('/', $path);

	$c = count($parts);

	if($c>0) {

		$ses = $_SESSION[AS_APP]['theme']['views'];

		if(!isset($ses[$parts[0]])) {
			return $path;
		}

		$dir = array();

		foreach($parts as $i=>$v) {
			if($v!='views' && $i<($c-1)) {
				if(isset($ses[$v])) {
					$ses = $ses[$v];
					$dir[] = $v;
				}
			}
		}

		$fil = $parts[$c-1];

		if( in_array( $fil, $ses ) ) {
			return getThemePath('templates/'.implode('/',$dir) .'/'.$fil);
		}

	}

	return $path;
}

function recurse_copy($src,$dst) {
    $dir = opendir($src);
    if(!file_exists($dst)) {
	    mkdir($dst, 0777, true);
    }
    while(false !== ( $file = readdir($dir)) ) {
        if (( $file != '.' ) && ( $file != '..' )) {
            if ( is_dir($src . '/' . $file) ) {
                recurse_copy($src . '/' . $file,$dst . '/' . $file);
            }
            else {
                copy($src . '/' . $file,$dst . '/' . $file);
            }
        }
    }
    closedir($dir);
}

function strToBool( $string ) {
	if($string=='true' || $string=='1') {
		return true;
	}
	return false;
}

function convertToWindowsPath( $forwardSlashPath ) {

	$windowsPath = preg_replace('/\//', '\\', $forwardSlashPath);

	return $windowsPath;
}

function getProcessIDTree( $ppid, $pids=array() ) {

	$children = explode(' ', exec('wmic process where (ParentProcessId='.trim($ppid).') get Caption,ProcessId'));

	foreach($children as $childPID) {
		if(trim($childPID)!='' && is_numeric(trim($childPID))) {
			$pids = getProcessIDTree($childPID, $pids);
			$pids[] = trim($childPID);
		}
	}

	return $pids;
}

function darken($color, $dif=20){

    $color = str_replace('#', '', $color);
    if (strlen($color) != 6){ return '000000'; }
    $rgb = '';

    for ($x=0;$x<3;$x++){
        $c = hexdec(substr($color,(2*$x),2)) - $dif;
        $c = ($c < 0) ? 0 : dechex($c);
        $rgb .= (strlen($c) < 2) ? '0'.$c : $c;
    }

    return '#'.$rgb;
}

/**
 *
 * Echos a value from an array key which may or may not exist
 * @deprecated
 * @param array $arr  array containing set of unknown keys
 * @param mixed $key  key of the array whose value should be echoed (string or numeric)
 * @param boolean $boolean optional  default:false, if true will echo 0 instead of empty string if the key cannot be found
 * @return null
 */
function aecho( $arr, $key, $boolean=false ) {
	if(!isset( $arr[$key] )) {
		if($boolean) {
			$str = 0;
		} else {
			$str = '';
		}
	}
	else {
		$str = $arr[$key];
	}
	echo $str;

	return null;
}


/**
 *
 * Returns a value from an array key which may or may not exist
 * @deprecated
 * @param array $arr  array containing set of unknown keys
 * @param mixed $key  key of the array whose value should be returned (string or numeric)
 * @param boolean $boolean optional  default:false, if true will return 0 instead of empty string if the key cannot be found
 * @return mixed
 */
function areturn( $arr, $key, $boolean=false ) {
	if(!isset( $arr[$key] )) {
		if($boolean) {
			$str = 0;
		} else {
			$str = '';
		}
	}
	else {
		$str = $arr[$key];
	}
	return $str;
}

/**
 *
 * @param string $num Phone number to format (ideally pass just digits, as it will strip out all others)
 * @param string $divider Character to use to divide digit groups
 * @return string
 */
function phone( $num, $divider='.' ) {
	$num = preg_replace("/[^0-9]/", "", $num);
	if(strlen($num)>0) {

		$p1 = substr($num, 0, 3);
		$p2 = substr($num, 3, 3);
		$p3 = substr($num, 6, 4);

		return $p1 . $divider . $p2 . $divider . $p3;
	}
	return '';
}

function getProtocolFromUrl($url) {

	if (preg_match('/^(http|https)/i', $url, $matches) == false) {
		$protocol = 'http';
	} else {
		$protocol = $matches[0];
	}

	return $protocol;

}

