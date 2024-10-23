import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    this.updateTheme()
    this.setupMediaQueryListener()
  }

  updateTheme() {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark')
      this.toggleTarget.checked = true
    } else {
      document.documentElement.classList.remove('dark')
      this.toggleTarget.checked = false
    }
  }

  setupMediaQueryListener() {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
      if (!('theme' in localStorage)) {
        if (e.matches) {
          document.documentElement.classList.add('dark')
          this.toggleTarget.checked = true
        } else {
          document.documentElement.classList.remove('dark')
          this.toggleTarget.checked = false
        }
      }
    })
  }

  toggle() {
    if (this.toggleTarget.checked) {
      localStorage.theme = 'dark'
      document.documentElement.classList.add('dark')
    } else {
      localStorage.theme = 'light'
      document.documentElement.classList.remove('dark')
    }
  }
}

