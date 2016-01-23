$a = "d14151"

switch -wildcard ($a) 
{ 
    "a*" {"The color is red."} 
    "b*" {"The color is blue."} 
    "c*" {"The color is green."} 
    "d*" {"The color is yellow."} 
    "e*" {"The color is orange."} 
    "f*" {"The color is purple."} 
    "g*" {"The color is pink."}
    "h*" {"The color is brown."} 
    default {"The color could not be determined."}
}
