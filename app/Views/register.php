<?php
// register.php view
// Expects optional: $errors (array of strings)
?>

<div class="min-h-screen flex items-center justify-center p-4">
  <div class="max-w-[440px] w-full bg-white rounded px-8 py-10" x-data="signUpForm()">
    <!-- Logo -->
    <div class="text-center mb-6">
      <h1 class="text-2xl font-normal tracking-wide text-bold">Fastburgers</h1>
    </div>

    <!-- Header -->
    <h2 class="text-xl font-normal text-center mb-2 font-bold">Register</h2>
    <p class="text-gray-500 text-center text-lg mb-8">
      Create your Fast Burgers account.
    </p>

    <!-- Errors -->
    <?php if (!empty($errors)): ?>
      <div class="mb-5 rounded border border-red-200 bg-red-50 px-4 py-3 text-red-800">
        <ul class="list-disc pl-5">
          <?php foreach ($errors as $err): ?>
            <li><?= htmlspecialchars($err) ?></li>
          <?php endforeach; ?>
        </ul>
      </div>
    <?php endif; ?>
    

    <!-- Form -->
    <!-- NOTE: No @submit.prevent — we want a normal POST to your controller -->
    <form class="space-y-5" method="POST" action="" id="registerForm">
      <p id="error"></p>

      <div class="grid grid-cols-2 gap-4">
        <input
          id="firstName"
          type="text"
          name="first_name"
          x-model="form.first_name"
          placeholder="First name*"
          class="w-full px-4 py-3.5 text-lg border border-2 border-gray-200 rounded focus:outline-none focus:border-rose-500 placeholder-gray-400" />
        <input
          id="lastName"
          type="text"
          name="last_name"
          x-model="form.last_name"
          placeholder="Last name*"
          class="w-full px-4 py-3.5 text-lg border border-2 border-gray-200 rounded focus:outline-none focus:border-rose-500 placeholder-gray-400" />
      </div>
      <div>
        <input
          type="text"
          name="phone"
          x-model="form.phone"
          x-ref="phoneInput"
          placeholder="Phone (optional)"
          class="w-full px-4 py-3.5 text-lg border border-2 border-gray-200 rounded focus:outline-none focus:border-rose-500 placeholder-gray-400" />
        <p class="text-sm text-gray-400 mt-2">Optional</p>
      </div>
      <div>
        <input
          id="email"
          type="email"
          name="email"
          x-model="form.email"
          placeholder="Email*"
          class="w-full px-4 py-3.5 text-lg border border-2 border-gray-200 rounded focus:outline-none focus:border-rose-500 placeholder-gray-400" />
      </div>
      <div class="relative">
        <input
          id="password"
          :type="showPwd ? 'text' : 'password'"
          name="password"
          x-model="form.password"
          minlength="8"
          placeholder="Password* (min 8 chars)"
          class="w-full px-4 py-3.5 text-lg border border-2 border-gray-200 rounded focus:outline-none focus:border-rose-500 placeholder-gray-400" />
        <button type="button" @click="showPwd = !showPwd" class="absolute right-3 top-1/2 -translate-y-1/2">
          <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
        </button>
      </div>
      <button
        type="submit"
        class="w-full bg-rose-700 text-white py-4 px-6 rounded text-lg hover:bg-rose-800 transition-colors mt-6"
        :disabled="isLoading">
        Register
      </button>
    </form>
  </div>
</div>

<script>
// Add an event listener that runs when the form is submitted
document.getElementById("registerForm").addEventListener("submit", function(e) {

  // Get the values entered in each form field
  // .trim() removes any spaces at the start or end of the input
  let firstName = document.getElementById("firstName").value.trim();
  let surname = document.getElementById("lastName").value.trim();
  let email = document.getElementById("email").value.trim();
  let password = document.getElementById("password").value.trim();
  // Variable used to store an error message if validation fails
  let error = "";
  // Regular expression pattern used to check if the email is valid
  // This checks for text before and after the @ symbol and a domain extension
  let emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  // Check if the first name field is empty
  if (firstName === "") {
    error = "First name is required";
  }
  // Check if the surname field is empty
  else if (surname === "") {
    error = "Surname is required";
  }
  // Check if the email field is empty
  else if (email === "") {
    error = "Email is required";
  }
  // Use the regex pattern to test if the email format is valid
  else if (!emailPattern.test(email)) {
    error = "Please enter a valid email address";
  }
  // Check if the password is at least 8 characters long
  else if (password.length < 8) {
    error = "Password must be at least 8 characters";
  }
  // If an error message exists, stop the form from submitting
  if (error !== "") {
    // Prevent the form from being sent to the server
    e.preventDefault();
    // Display the error message on the page
    document.getElementById("error").innerText = error;
    // Stop the rest of the script from running
    return;
  }
  // If validation passes, store the email in localStorage
  // This allows the login page to automatically fill the email field
  localStorage.setItem("savedEmail", email);
});
</script>
