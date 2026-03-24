<?php
// login.php view
// expects optional $errors array
?>

<link rel="preload" as="image"
  href="https://res.cloudinary.com/dkt1t22qc/image/upload/v1742357451/Prestataires_Documents/cynbxx4vxvgv2wrpakiq.jpg" />

<div class="bg-cover bg-center"
  style="background-image:url(https://res.cloudinary.com/dkt1t22qc/image/upload/v1742357451/Prestataires_Documents/cynbxx4vxvgv2wrpakiq.jpg)">

  <div class="flex h-screen items-center justify-center">
    <div class="flex flex-col items-center space-y-8">

      <div>
        <img
          src="https://res.cloudinary.com/dkt1t22qc/image/upload/v1742348949/Prestataires_Documents/smj7n1bdlpjsfsotwpco.png"
          alt="TyBot Logo"
          class="cursor-pointer" />
      </div>

      <div class="w-80 rounded-[20px] bg-white p-8"
           style="box-shadow:#00000057 1px 3px 4px">

        <h1 class="mb-4 text-center text-3xl font-bold text-black"
            style="text-shadow:#00000063 0px 3px 5px">
          Welcome Back !
        </h1>

        <!-- Error Messages -->
        <?php if (!empty($errors)): ?>
          <div class="mb-4 rounded bg-red-100 p-3 text-sm text-red-700">
            <ul class="list-disc pl-4">
              <?php foreach ($errors as $error): ?>
                <li><?= htmlspecialchars($error) ?></li>
              <?php endforeach; ?>
            </ul>
          </div>
        <?php endif; ?>

        <!-- FORM START -->
        <form method="POST" action="" class="space-y-4">

          <input
            type="email"
            name="email"
            placeholder="Email address"
            required
            class="w-full rounded-md bg-[#E9EFF6] p-2.5 placeholder:text-[#000000]"
            style="box-shadow:rgb(0 0 0 / 21%) 0px 7px 5px 0px" />

          <input
            type="password"
            name="password"
            placeholder="Password"
            required
            class="w-full rounded-md bg-[#E9EFF6] p-2.5 placeholder:text-[#000000]"
            style="box-shadow:rgb(0 0 0 / 21%) 0px 7px 5px 0px" />

          <div class="pt-2">
            <span
              class="ml-2 cursor-pointer text-[10px] text-[#228CE0] hover:underline">
              Forget Password?
            </span>
          </div>

          <div class="flex justify-center">
            <button
              type="submit"
              class="h-10 w-full cursor-pointer rounded-md bg-gradient-to-br from-[#7336FF] to-[#3269FF] text-white shadow-md shadow-blue-950">
              Sign In
            </button>
          </div>

        </form>
        <!-- FORM END -->

        <div class="mt-4 text-center text-[#969696]">
          Don't have an account?
          <a href="/register"
             class="cursor-pointer text-[#7337FF] hover:underline">
            Sign up
          </a>
        </div>

      </div>
    </div>
  </div>
</div>