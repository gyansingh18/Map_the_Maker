import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map-reset"
export default class extends Controller {
  close() {
    this.element.classList.add("d-none")
  }
}
