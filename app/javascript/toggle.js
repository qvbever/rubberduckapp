// Function to toggle the border on click and retain it during content updates
function toggleBorder(event) {
  // Get all icons
  const icons = document.querySelectorAll('.icon');

  // Remove the border class from all icons
  icons.forEach(icon => {
    icon.classList.remove('icon-border');
  });

  // Add the border class to the clicked icon
  const clickedIcon = event.currentTarget;
  clickedIcon.classList.add('icon-border');

  // Store the selected icon's query in localStorage
  localStorage.setItem('selectedIcon');

  // Perform your content change logic (AJAX, etc.)
  search(event);  // Call your function to change the content
}
