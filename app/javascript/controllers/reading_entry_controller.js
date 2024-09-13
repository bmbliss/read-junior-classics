import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]
  static values = { completed: Boolean, url: String, literaryWorkId: Number }

  toggleStatus(event) {
    const status = event.target.checked ? "completed" : "in_progress"
    this.updateReadingEntry({ status: status, literary_work_id: this.literaryWorkIdValue })
  }

  async updateReadingEntry(data) {
    const response = await fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ reading_entry: data })
    })

    if (response.ok) {
      const result = await response.json()
      this.completedValue = result.status === "completed"
      this.element.dataset.readingEntryCompletedValue = this.completedValue
      this.updateProgressPercentage(result.progress_percentage)
    } else {
      console.error("Failed to update reading entry")
      this.checkboxTarget.checked = !this.checkboxTarget.checked
      this.showFlashNotice("Failed to update reading entry", "error")
    }
  }

  updateProgressPercentage(percentage) {
    const progressElement = document.getElementById("program-progress-percentage")
    if (progressElement) {
      progressElement.textContent = `${percentage}`
    }
  }
}
