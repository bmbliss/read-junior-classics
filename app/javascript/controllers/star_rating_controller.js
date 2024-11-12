import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]
  
  connect() {
    if (this.hasInputTarget) {
      this.updateStars(this.inputTarget.value)
    }
  }
  
  rate(event) {
    const rating = parseInt(event.currentTarget.dataset.starRatingIndexValue)
    this.inputTarget.value = rating
    this.updateStars(rating)
    this.element.closest('form').requestSubmit()
  }
  
  hover(event) {
    const rating = parseInt(event.currentTarget.dataset.starRatingIndexValue)
    this.updateStars(rating, true)
  }
  
  resetHover() {
    this.updateStars(this.inputTarget.value)
  }
  
  updateStars(rating, isHover = false) {
    this.starTargets.forEach((star, index) => {
      const span = star.querySelector('span')
      if (index < rating) {
        span.classList.remove('text-gray-300')
        span.classList.add(isHover ? 'text-yellow-300' : 'text-yellow-400')
      } else {
        span.classList.remove('text-yellow-300', 'text-yellow-400')
        span.classList.add('text-gray-300')
      }
    })
  }
} 