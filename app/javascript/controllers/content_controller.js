import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="content"
export default class extends Controller {
  static targets = ["content", "contentContainer"]

  search(event) {
    const searchQuery = event.currentTarget.dataset.query;

    // Perform the search by updating the page content with AJAX
    const url = `/rubberducks?query=${encodeURIComponent(searchQuery)}`;

    // Fetch the results and update the content dynamically
    fetch(url, {
      headers: {
        'X-Requested-With': 'XMLHttpRequest' // Mark it as an AJAX request
      }
    })
      .then(response => response.text())
      .then(html => {
        // this.contentTarget.innerHTML = html;
        this.contentContainerTarget.innerHTML = "";
        this.contentContainerTarget.innerHTML = html;

        applySelectedIconBorder();
      })
      .catch(error => console.log("Error during search:", error));
  }
}

function applySelectedIconBorder() {
  const selectedIcon = localStorage.getItem('selectedIcon');
  if (selectedIcon) {
    const iconToHighlight = [...document.querySelectorAll('.icon')].find(icon => {
      return icon.dataset.query === selectedIcon;
    });
    if (iconToHighlight) {
      iconToHighlight.classList.add('icon-border');
    }
  }
}

// Call this function on page load to set the border if applicable
window.onload = function() {
  applySelectedIconBorder();
};
