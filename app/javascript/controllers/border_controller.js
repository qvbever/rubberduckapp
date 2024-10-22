import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["icon"]

  toggleBorder(event) {
    // Get the clicked icon
    const clickedIcon = event.currentTarget;

    this.iconTargets.forEach(icon => {
      icon.classList.remove("icon-border");
    });

    // Add border class to the clicked icon
    clickedIcon.classList.add("icon-border");
  }

}
