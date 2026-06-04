import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    type: String,
    data: Object,
    options: Object
  }

  connect() {
    if (!window.Chartkick) {
      return
    }

    if (this.chart && this.chart.destroy) {
      this.chart.destroy()
    }

    this.chart = new Chartkick[this.typeValue](this.element, this.dataValue, this.optionsValue || {})
  }

  disconnect() {
    if (this.chart && this.chart.destroy) {
      this.chart.destroy()
    }
  }
}
