import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['buttons', 'selected']
  selectedSet = new Set()

  connect() {
    this.toggle()
  }

  toggle() {
    this.selectedSet.clear()
    this.element.querySelectorAll('[data-action="multiple#toggle"]:checked').forEach((checkbox) => this.selectedSet.add(checkbox.value))
    this.selectedTarget.value = [...this.selectedSet].join(' ')
    console.log([...this.selectedSet].join(' '))
    if (this.selectedSet.size == 0) {
      this.buttonsTarget.classList.remove('active')
    } else {
      this.buttonsTarget.classList.add('active')
    }
  }

  toggleAll(event) {
    if (event.currentTarget.checked) {
      this.element.querySelectorAll('[data-action="multiple#toggle"]').forEach((checkbox) => checkbox.checked = true)
    } else {
      this.element.querySelectorAll('[data-action="multiple#toggle"]').forEach((checkbox) => checkbox.checked = false )
    }
    this.toggle()
  }
}
