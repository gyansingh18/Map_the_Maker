import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]
  static values = { favorited: Boolean }

  toggle(event) {
    event.preventDefault();

    const icon = this.iconTarget;

    if (this.favoritedValue) {
      icon.classList.remove('fa-solid');
      icon.classList.add('fa-solid');
      icon.style.color = "#555555";
    } else {
      icon.classList.remove('fa-solid');
      icon.classList.add('fa-solid');
      icon.style.color = "#d01111";
    }

    this.favoritedValue = !this.favoritedValue;
  }
}
