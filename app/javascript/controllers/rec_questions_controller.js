import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["rec1", "rec2", "question"]

  connect() {
  }

  disable() {
    this.rec1Target.classList.add("d-none");
    this.rec2Target.classList.add("d-none");
  }

  insert(event) {
    console.log(event.srcElement.innerText)
    const selected_question = event.srcElement.innerText
    console.log(this.questionTarget)
    this.questionTarget.value = selected_question
  }
}
