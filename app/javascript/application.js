// Import Turbo, Stimulus, Popper.js, and Bootstrap globally
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { autoloadControllersFrom } from "@hotwired/stimulus-loading";
import "@popperjs/core";
import "bootstrap";
import "@fortawesome/fontawesome-free/js/all";
import flatpickr from "flatpickr";

// Initialize Stimulus controllers
const application = Application.start();
autoloadControllersFrom("controllers", application); // Correct autoloading of controllers
application.debug = false; // Disable debugging in production
window.Stimulus = application; // Optional: Expose Stimulus globally

// Conditionally load the `show.js` script only on the Show Page
document.addEventListener('turbo:load', () => {
  if (document.querySelector('.show-page')) {
    import("./controllers/show").then(({ loadShowPage }) => {
      loadShowPage();  // Dynamically loads show.js
    });
  }
});
