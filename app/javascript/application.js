// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import flatpickr from "flatpickr";

document.addEventListener('turbo:load', function() {
  flatpickr('.datepicker', {
    enableTime: false,       // Disable time picker
    dateFormat: 'Y/m/d',     // Format: Day/Month/Year
    minDate: 'today',        // Disable past dates
  });
});
