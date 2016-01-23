function f2
{
    [CmdletBinding()]
    Param($a,$b,$c=2)

    process
    {
        "__PSBoundParameters__"
        $PSBoundParameters

        "__a__"
        $a
        "__b__"
        $b
        "__c__"
        $c

        "__args__"
        $args

        "__input__"
        $input

        "_____"
        $_
    }
}

"this is input","input2" | f2 1 2 3
"this is input","input2" | f2 1 2 3 4