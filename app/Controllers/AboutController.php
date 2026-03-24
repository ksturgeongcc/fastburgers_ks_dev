<?php
// This controller handles the contact page (/contact)

class AboutController
{
    public function index(): void
    {
        // Page title
        $title = 'Fast Burgers - About Us';

        // Choose the view file
        $view = BASE_PATH . '/app/Views/about.php';

        // Load the layout
        require BASE_PATH . '/app/Views/layout.php';
    }
}
