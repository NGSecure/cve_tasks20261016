<?php
/**
 * Testing Absent
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

use PHPUnit\Framework\TestCase;

/**
 * Absent to 0
 * php version 8.1
 *
 * @category None
 *
 * @package None
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com
 **/
class AbsentTest extends TestCase
{
    /**
     * Absent Calucation.
     *
     * @return None of A for absent.
     */
    public function testAbsentToMarks()
    {
        include './functions.php';
         $marks_value=-1;
         $this->assertEquals(0, Change_Absent_tozero($marks_value));

           $marks_value=2;
           $this->assertEquals(2, Change_Absent_tozero($marks_value));
    }

    
}



?>