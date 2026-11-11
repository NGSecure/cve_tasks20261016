<?php

namespace MicroweberPackages\FormBuilder\Elements;

class Text extends Input
{
    public function getType()
    {
        return 'text';
    }
    protected $attributes = [
        'type' => 'text',
        'class'=>'form-control'
    ];

}
