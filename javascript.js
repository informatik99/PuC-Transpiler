function fun (x) {
if (x == x) {
return "x"
} else {
return "y"
}
}
function funu (s, j) {
return (() => {
console.log (j + " " + s)
return j + " " + s
}) ()
}
var name = "Hallo" + "Rene"
var schwimmer = name + name
var wahr = true
funu ("Hallo Text", "jj")
