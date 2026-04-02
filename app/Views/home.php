<?php
// This is the home page view.
// It only displays data passed from the controller.
?>
<div class="flex flex-col h-screen">

  <!-- Hero Section -->
  <div class=" flex-1">
    <div
      class=" h-[50%] bg-zinc-400 bg-cover bg-center bg-no-repeat flex items-center text-white pl-[137px]">
      <div class="flex flex-col">
        <div class="text-[34px] leading-8">fastburgers</div>
        <div class="text-[56px] font-medium mb-4">Open 7 days a week</div>
        <p class="w-[397px] mb-[40px]">
          The best restaurnant in town, serving delicious burgers made with fresh ingredients. Come and taste the difference!
        </p>
        <div class="flex gap-[16px]">
          <a href="login"> 
            <button class="rounded-[4px] p-[12px] bg-white font-medium text-black">
                Login           
            </button></a>
         <a href="register"> 
            <button class="rounded-[4px] p-[12px] bg-white font-medium text-black">
                Register           
            </button></a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- section -->
 <section class="text-gray-600 body-font">
    <div class="container mx-auto flex px-5 py-24 md:flex-row flex-col items-center">
        <div
            class="lg:flex-grow md:w-1/2 lg:pr-24 md:pr-16 flex flex-col md:items-start md:text-left mb-16 md:mb-0 items-center text-center">
            <h1 class="title-font sm:text-4xl text-3xl mb-4 font-medium text-gray-900">Our current Menu
                <br class="hidden lg:inline-block">Savers Menu
            </h1>
            <p class="mb-8 leading-relaxed">Come in and enjoy our special Savers Menu with great deals on our most popular items! Available all week long.</p>
            <div class="flex justify-center">
                <button class="inline-flex text-white bg-indigo-500 border-0 py-2 px-6 focus:outline-none hover:bg-indigo-600 rounded text-lg">View Menu</button>
                <button class="ml-4 inline-flex text-gray-700 bg-gray-100 border-0 py-2 px-6 focus:outline-none hover:bg-gray-200 rounded text-lg">View Main Menu</button>
            </div>
        </div>
        <div class="lg:max-w-lg lg:w-full md:w-1/2 w-5/6">
            <img class="object-cover object-center rounded" alt="hero" src="/assets/images/home_bg.jpg">
        </div>
    </div>
</section>
