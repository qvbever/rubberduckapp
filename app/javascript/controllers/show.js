// Initialize Flatpickr
import flatpickr from "flatpickr";

// Use the CDN-provided Flatpickr
document.addEventListener('turbo:load', function () {
  const rubberduckId = document.querySelector("[data-rubberduck-id]").dataset.rubberduckId;

  flatpickr("#booking_start_date, #booking_end_date", {
    altInput: true,
    altFormat: "F j, Y",  // User-friendly date format
    dateFormat: "Y-m-d",  // Format stored in the database
    minDate: "today",     // Disable past dates
    onChange: function(selectedDates) {
      if (selectedDates.length === 2) {
        const startDate = flatpickr.formatDate(selectedDates[0], "Y-m-d");
        const endDate = flatpickr.formatDate(selectedDates[1], "Y-m-d");

        // Fetch pricing information via AJAX
        fetch(`/rubberducks/${rubberduckId}/calculate_price?start_date=${startDate}&end_date=${endDate}`)
          .then(response => response.json())
          .then(data => {
            document.getElementById("bath-duration").textContent = data.num_days;
            document.getElementById("bath-cost").textContent = `€ ${data.price_per_bath} x ${data.num_days} baths = € ${data.total_bath_cost}`;
            document.getElementById("cleaning-fee").textContent = `€ ${data.cleaning_fee}`;
            document.getElementById("service-fee").textContent = `€ ${data.service_fee}`;
            document.getElementById("total-cost").textContent = `€ ${data.total_cost}`;
          });
      }
    }
  });
});
