function fun (x) {
if (x == x) {
return "x"
} else {
return "y"
}
}
function funu (s, j, s2) {
return (() => {
console.log (s + " " + String (j) + " " + s2)
return s + " " + String (j) + " " + s2
}) ()
}
var name = "Rene "
var schwimmer = "Hallo " + name + "schwimm bitte: "
var wahr = true
funu (schwimmer, 10, "Bahnen")
