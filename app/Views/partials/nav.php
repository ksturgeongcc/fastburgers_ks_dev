<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$isLoggedIn = !empty($_SESSION['auth']['logged_in']) && !empty($_SESSION['auth']['token']);
$isAdmin = !empty($_SESSION['auth']['is_admin']);

$dashboardLink = '/customer-dashboard';

if ($isAdmin) {
    $dashboardLink = '/admin-dashboard';
}
?>

<nav class="bg-white border-gray-200 py-2.5 dark:bg-gray-900">
    <div class="flex flex-wrap items-center justify-between max-w-screen-xl px-4 mx-auto">

        <!-- Logo -->
        <a href="/" class="flex items-center">
            <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">
                Company Logo
            </span>
        </a>

        <!-- Right Side Buttons -->
        <div class="flex items-center lg:order-2 gap-3">

            <?php if (!$isLoggedIn): ?>

                <!-- Login Button -->
                <a href="/login"
                   class="text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 dark:bg-purple-600 dark:hover:bg-purple-700 focus:outline-none dark:focus:ring-purple-800">
                    Login
                </a>

                <!-- Register Button -->
                <a href="/register"
                   class="text-purple-700 border border-purple-700 hover:bg-purple-50 focus:ring-4 focus:ring-purple-200 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 dark:text-white dark:border-purple-500 dark:hover:bg-purple-700 dark:hover:text-white focus:outline-none">
                    Register
                </a>

            <?php else: ?>

                <!-- Logout Button -->
                <a href="/logout"
                   class="text-white bg-red-600 hover:bg-red-700 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 focus:outline-none">
                    Logout
                </a>
                
                <a href="<?= htmlspecialchars($dashboardLink) ?>"
                   class="text-purple-700 border border-purple-700 hover:bg-purple-50 focus:ring-4 focus:ring-purple-200 font-medium rounded-lg text-sm px-4 lg:px-5 py-2 lg:py-2.5 dark:text-white dark:border-purple-500 dark:hover:bg-purple-700 dark:hover:text-white focus:outline-none">
                    Dashboard
                </a>

            <?php endif; ?>

            <!-- Mobile Toggle -->
            <button data-collapse-toggle="mobile-menu-2" type="button"
                class="inline-flex items-center p-2 ml-1 text-sm text-gray-500 rounded-lg lg:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600"
                aria-controls="mobile-menu-2" aria-expanded="true">
                <span class="sr-only">Open main menu</span>
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd"
                        d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
                        clip-rule="evenodd"></path>
                </svg>
            </button>
        </div>

        <!-- Main Navigation Links -->
        <div class="items-center justify-between w-full lg:flex lg:w-auto lg:order-1" id="mobile-menu-2">
            <ul class="flex flex-col mt-4 font-medium lg:flex-row lg:space-x-8 lg:mt-0">

                <li>
                    <a href="/"
                        class="block py-2 pl-3 pr-4 text-gray-700 hover:text-purple-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white">
                        Home
                    </a>
                </li>

                <li>
                    <a href="/about"
                        class="block py-2 pl-3 pr-4 text-gray-700 hover:text-purple-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white">
                        About
                    </a>
                </li>

                <li>
                    <a href="/contact"
                        class="block py-2 pl-3 pr-4 text-gray-700 hover:text-purple-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white">
                        Contact
                    </a>
                </li>

            </ul>
        </div>

    </div>
</nav>

<script src="https://unpkg.com/flowbite@1.4.1/dist/flowbite.js"></script>