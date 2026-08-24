import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    // Remove preload class from html (used for flash prevention)
    document.documentElement.classList.remove("night-mode-preload")
    this.applyTheme(this.currentTheme)
  }

  toggle() {
    const newTheme = this.currentTheme === "night" ? "day" : "night"
    localStorage.setItem("theme", newTheme)
    this.applyTheme(newTheme)
  }

  applyTheme(theme) {
    document.body.classList.toggle("night-mode", theme === "night")
    if (this.hasIconTarget) {
      this.iconTarget.textContent = theme === "night" ? "☀️" : "🌙"
    }
  }

  get currentTheme() {
    return localStorage.getItem("theme") || "day"
  }
}
