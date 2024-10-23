import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "rating", "notesSection", "existingNotes", "editNotesSection", "notesTextarea", "addNotes"]
  static values = { completed: Boolean, url: String, literaryWorkId: Number }

  toggleStatus(event) {
    const status = event.target.checked ? "completed" : "in_progress"
    this.updateReadingEntry({ status: status, literary_work_id: this.literaryWorkIdValue })
  }

  updateRating(event) {
    const rating = event.target.value;
    this.updateReadingEntry({ rating: rating, literary_work_id: this.literaryWorkIdValue });
  }

  toggleNotes() {
    this.notesTextareaTarget.classList.toggle('hidden')
    this.saveNotesButtonTarget.classList.toggle('hidden')
  }

  addNotes() {
    this.showEditNotesSection()
  }

  editNotes() {
    this.showEditNotesSection()
  }

  showEditNotesSection() {
    if (this.hasExistingNotesTarget) {
      this.existingNotesTarget.classList.add('hidden')
    }
    this.editNotesSectionTarget.classList.remove('hidden')
  }

  cancelNotes() {
    this.editNotesSectionTarget.classList.add('hidden')
    if (this.hasExistingNotesTarget) {
      this.existingNotesTarget.classList.remove('hidden')
    }
  }

  async saveNotes() {
    const notes = this.notesTextareaTarget.value
    this.updateReadingEntry({ notes: notes, literary_work_id: this.literaryWorkIdValue })
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
      if (data.status) {
        this.completedValue = result.status === "completed"
        this.element.dataset.readingEntryCompletedValue = this.completedValue
      }
      if (data.notes) {
        this.notesTextareaTarget.value = result.notes
        this.updateNotesDisplay(result.notes)
        this.editNotesSectionTarget.classList.add('hidden')
      }
      this.updateProgressPercentage(result.progress_percentage)
    } else {
      console.error("Failed to update reading entry")
      if (data.status) {
        this.checkboxTarget.checked = !this.checkboxTarget.checked
      }
      if (data.rating) {
        this.ratingTarget.value = this.ratingTarget.dataset.previousValue || ""
      }
      if (data.notes) {
        // Optionally, you could show an error message here
      }
    }
  }

  updateProgressPercentage(percentage) {
    const progressElement = document.getElementById("program-progress-percentage")
    if (progressElement) {
      progressElement.textContent = `${percentage}`
    }
  }

  updateNotesDisplay(notes) {
    if (this.hasExistingNotesTarget) {
      this.existingNotesTarget.innerHTML = `
        <p class="text-sm text-gray-600 dark:text-slate-400 mb-2">
          <strong>Notes:</strong> ${this.truncate(notes, 100)}
        </p>
        <button class="text-sm text-primary-500 hover:text-primary-600 dark:text-primary-dark-600" data-action="click->reading-entry#editNotes">
          Edit Notes
        </button>
      `
      this.existingNotesTarget.classList.remove('hidden')
    } else {
      this.addNotesTarget.innerHTML = `
        <div data-reading-entry-target="existingNotes">
          <p class="text-sm text-gray-600 dark:text-slate-400 mb-2">
            <strong>Notes:</strong> ${this.truncate(notes, 100)}
          </p>
          <button class="text-sm text-primary-500 hover:text-primary-600 dark:text-primary-dark-600" data-action="click->reading-entry#editNotes">
            Edit Notes
          </button>
        </div>
      `
    }
  }

  truncate(str, length) {
    return str.length > length ? str.substring(0, length - 3) + '...' : str
  }
}
