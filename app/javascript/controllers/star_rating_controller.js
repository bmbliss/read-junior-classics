import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]
  
  connect() {
    if (this.hasInputTarget) {
      this.updateStars(this.inputTarget.value)
    }
  }
  
  rate(event) {
    const rating = event.currentTarget.dataset.starRatingIndexValue
    this.inputTarget.value = rating
    this.updateStars(rating)
    this.element.closest('form').requestSubmit()
  }
  
  updateStars(rating) {
    this.starTargets.forEach((star, index) => {
      const span = star.querySelector('span')
      if (index < rating) {
        span.classList.remove('text-gray-300')
        span.classList.add('text-yellow-400')
      } else {
        span.classList.remove('text-yellow-400')
        span.classList.add('text-gray-300')
      }
    })
  }
} 