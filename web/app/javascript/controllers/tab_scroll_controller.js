import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Scroll to the first card when page loads (which is now the changed registration)
    this.scrollToFirstCard()

    // Also listen for turbo navigation
    document.addEventListener('turbo:load', () => this.scrollToFirstCard())
  }

  scrollToFirstCard() {
    // Find the active tab pane
    const activePane = document.querySelector('.tab-pane.show.active')
    if (activePane) {
      // Find the first card in the active pane
      const firstCard = activePane.querySelector('[id$="-card-"]')
      if (firstCard) {
        // Scroll the card into view at the top
        firstCard.scrollIntoView({ behavior: 'smooth', block: 'start' })

        // // Add top padding by scrolling up a bit
        // setTimeout(() => {
        //   window.scrollBy({ top: -100, behavior: 'smooth' })
        // }, 300)

        // // Highlight the card briefly
        // firstCard.style.backgroundColor = '#f0f0f0'
        // setTimeout(() => {
        //   firstCard.style.backgroundColor = ''
        // }, 2000)
      }
    }
  }
}
