import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-click"
export default class extends Controller {
  connect() {
    console.log("connect");

    this.element.click();
  }
}
