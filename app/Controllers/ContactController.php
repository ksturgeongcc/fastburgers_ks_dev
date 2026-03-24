<?php
// This controller handles the contact page (/contact)

class ContactController
{
    public function index(): void
    {
        // Page title
        $title = 'Fast Burgers - Contact Us';

        // Choose the view file
        $view = BASE_PATH . '/app/Views/contact.php';

        // Load the layout
        require BASE_PATH . '/app/Views/layout.php';
    }
}
