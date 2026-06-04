import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const messages = this.element.closest(".chat-messages")
    if (messages) {
      messages.scrollTop = messages.scrollHeight
    }
  }
}
