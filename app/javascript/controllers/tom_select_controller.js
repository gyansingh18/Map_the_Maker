import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    console.log("tom select");
    new TomSelect(this.element)
  }
}
