<?php
  /**
   * All the general functions of the website resides here.
   * php version 8.1
   *
   * @category Functions
   *
   * @package Functions
   *
   * @author Waqas Ahmad <waqaskanju@gmail.com>
   *
   * @license http://www.abc.com MIT
   *
   * @link Adfas
   **/

  /**
   * All the general functions of the website resides here.
   * php version 8.1
   *
   * @category Functions
   *
   * @package Functions
   *
   * @author Waqas Ahmad <waqaskanju@gmail.com>
   *
   * @license http://www.abc.com MIT
   *
   * @link Adfas
   **/
/**
 * This function change -1 to absent.
 *
 * @param Integer $marks date of birth
 *
 * @return Makrs of A for absent.
 */
function Show_absent($marks)
{
    if ($marks == -1) {
            $marks ="A";
    }
    return $marks;
}

/**
 * This function change absent to zero for total marks calculation.
 *
 * @param Integer $marks_value date of birth
 *
 * @return Makrs of A for absent.
 */
function Change_Absent_tozero($marks_value)
{
    if ($marks_value == -1) {
            $marks_value=0;
    }
    return $marks_value;
}



/**
 * This function change subject name to column name where
 * marks of the subject will be added.
 *
 * @param string $subject Msg to be saved
 *
 * @return Void  save message.
 */
function Change_Subject_To_Marks_col($subject)
{
    switch ($subject) {
    case "English":
        return "English_Marks";
    break;
    case "Urdu":
        return "Urdu_Marks";
    break;
    case "Maths":
        return "Maths_Marks";
    break;
    case "Hpe":
        return "Hpe_Marks";
    break;
    case "Nazira":
        return "Nazira_Marks";
    break;
    case "General Science":
        return "Science_Marks";
    break;
    case "Arabic":
        return "Arabic_Marks";
    break;
    case "Islamyat":
        return "Islamyat_Marks";
    break;
    case "History And Geography":
        return "History_Marks";
    break;
    case "Computer Science":
        return "Computer_Marks";
    break;
    case "Mutalia Quran":
        return "Mutalia_Marks";
    break;
    case "Drawing":
        return "Drawing_Marks";
    break;
    case "Social Study":
        return "Social_Marks";
    break;
    case "Pak Study":
        return "Social_Marks";
    break;
    case "Pashto":
        return "Pashto_Marks";
    break;
    case "Biology":
        return "Biology_Marks";
    break;
    case "Chemistry":
        return "Chemistry_Marks";
    break;
    case "Physics":
        return "Physics_Marks";
    break;
    case "Civics":
        return "Civics_Marks";
    break;
    case "Economics":
        return "Economics_Marks";
    break;
    case "Islamic Study":
        return "Islamic_Study_Marks";
    break;
    case "Islamic Education":
        return "Islamic_Education_Marks";
    break;
    case "Statistics":
        return "Statistics_Marks";
    break;
    default:
        echo "Unknown Subject";
    }

}


/**
 * Project Folder Name
 * 
 * @return Void  show project folder used in print.
 */
function Project_Folder_name()
{
    // return folder of the project.
    $path=getcwd();
    //echo  $main_dir=dirname($path, 1);
    $chunks = explode('\\', $path);
    $chunks_length=count($chunks);
    return $my_directory=$chunks[$chunks_length-1];
    
}

/**
 * Project Folder Name
 * 
 * @param integer $status Name of class
 * 
 * @return Void  show project folder used in print.
 */
function Change_Status_To_word($status) 
{
    return $status==1? "Active" : "Inactive";
}

/**
 * Project Folder Name
 * 
 * @param time   $sec Time in Second
 * @param string $url Url of the page
 * 
 * @return Void  show project folder used in print.
 */
function redirection($sec,$url) 
{
    header("refresh:$sec; url=$url");
}

/**
 * Validate Form Input;
 *
 * @param string $data Name of the class.
 *
 * @return string return clean data.
 */
function Validate_input($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

/**
 * Show Alert Message
 * 
 * @param string $message    Time in Second
 * @param string $alert_type Url of the page
 * 
 * @return Void  show project folder used in print.
 */
function Show_alert($message,$alert_type)
{
    echo "<div class='alert alert-$alert_type alert-dismissible fade show' 
               role='alert'>
                  <strong>Success!</strong> $message
                    <button type='button' class='btn-close' data-bs-dismiss='alert' 
                            aria-label='Close'></button>
                </div>";
}
?>