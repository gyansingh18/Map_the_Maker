import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    new TomSelect(this.element, {
      maxItems: 10,
      create: true,
	    createFilter: function(input) {
        input = input.toLowerCase();
        return !(input in this.options);
      }
    })
  }
}
