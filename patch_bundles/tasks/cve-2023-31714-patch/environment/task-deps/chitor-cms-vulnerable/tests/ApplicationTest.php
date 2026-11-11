<?php
/**
 * Add New Students to CMS
 * php version 8.1
 *
 * @category Student
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
 * Application Testing
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
class ApplicationTest extends TestCase
{
    /**
     * This function change absent to zero for total marks calculation.
     *
     * @return Marks of A for absent.
     */
    public function testMarksToAbsent()
    {
         $marks=-1;
         $this->assertEquals("A", Show_absent($marks));

           $marks=2;
           $this->assertEquals(2, Show_absent($marks));
    }

    
}



?>