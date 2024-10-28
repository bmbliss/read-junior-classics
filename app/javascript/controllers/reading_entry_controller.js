import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rating"]
  static values = { url: String, literaryWorkId: Number, readingEntryId: Number, childId: Number }

  updateRating(event) {
    const rating = event.target.value;

    this.updateReadingEntry({ 
      rating: rating,
      reading_entry_id: this.readingEntryIdValue,
      literary_work_id: this.literaryWorkIdValue,
      child_id: this.childIdValue
    });
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
      await response.json()
    } else {
      console.error("Failed to update reading entry")
      if (data.rating) {
        this.ratingTarget.value = this.ratingTarget.dataset.previousValue || ""
      }
    }
  }
}
