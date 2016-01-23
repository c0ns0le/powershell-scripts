function f{
"`$abc is $abc"
$abc = 456
"`$abc is $abc"

"`$Local:abc is $Local:abc"
"`$Script:abc is $Script:abc"
"`$Global:abc is $Global:abc"
}

###### Test 1 ######
$abc = 123
f
$abc

###### Test 2 ########
$abc = 123
. f
$abc

###### Test 3 ########
$Private:abc = 123
f
$abc