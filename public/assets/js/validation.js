document.getElementById("registerForm").addEventListener("submit", function(e){

e.preventDefault();

let firstName = document.getElementById("firstName").value.trim();
let surname = document.getElementById("surname").value.trim();
let email = document.getElementById("email").value.trim();
let password = document.getElementById("password").value.trim();

let error = "";

if(firstName === ""){
error = "First name is required";
}
else if(surname === ""){
error = "Last name is required";
}
else if(email === ""){
error = "Email is required";
}
else if(password.length < 8){
error = "Password must be at least 8 characters";
}

if(error !== ""){
document.getElementById("error").innerText = error;
return;
}

localStorage.setItem("savedEmail", email);

window.location.href = "login.html";

});