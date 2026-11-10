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
class MarksSubjectLinkTest extends TestCase
{
    /**
     * This function change absent to zero for total marks calculation.
     *
     * @return Marks of A for absent.
     */
    public function testSubjectMarksLink()
    {
         $subject="English";
         $this->assertEquals("English_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Urdu";
         $this->assertEquals("Urdu_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Maths";
         $this->assertEquals("Maths_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Hpe";
         $this->assertEquals("Hpe_Marks", Change_Subject_To_Marks_col($subject));


         $subject="Nazira";
         $this->assertEquals("Nazira_Marks", Change_Subject_To_Marks_col($subject));


         $subject="General Science";
         $this->assertEquals("Science_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Arabic";
         $this->assertEquals("Arabic_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Islamyat";
        $this->assertEquals(
            "Islamyat_Marks", Change_Subject_To_Marks_col($subject)
        );

         $subject="History And Geography";
         $this->assertEquals("History_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Computer Science";
        $this->assertEquals(
            "Computer_Marks", Change_Subject_To_Marks_col($subject)
        );

         $subject="Mutalia Quran";
         $this->assertEquals("Mutalia_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Drawing";
         $this->assertEquals("Drawing_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Social Study";
         $this->assertEquals("Social_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Pak Study";
         $this->assertEquals("Social_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Pashto";
         $this->assertEquals("Pashto_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Biology";
         $this->assertEquals("Biology_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Chemistry";
        $this->assertEquals(
            "Chemistry_Marks", Change_Subject_To_Marks_col($subject)
        );

         $subject="Physics";
         $this->assertEquals("Physics_Marks", Change_Subject_To_Marks_col($subject));

         $subject="Civics";
         $this->assertEquals("Civics_Marks", Change_Subject_To_Marks_col($subject));
         
         $subject="Economics";
        $this->assertEquals(
            "Economics_Marks", Change_Subject_To_Marks_col($subject)
        );
        
        $subject="Islamic Study";
        $this->assertEquals(
            "Islamic_Study_Marks", Change_Subject_To_Marks_col($subject)
        );
        
        $subject="Islamic Education";
        $this->assertEquals(
            "Islamic_Education_Marks", Change_Subject_To_Marks_col($subject)
        );
        
        $subject="Statistics";
        $this->assertEquals(
            "Statistics_Marks", Change_Subject_To_Marks_col($subject)
        );
    
         

    }

    
}



?>