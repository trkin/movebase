import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['processing']

  submit_ajax_and_update() {
    let url = $(this.element).closest('form').attr('action')
    let formData = $(this.element).closest('form').serialize()
    this.processingTarget.classList.add('active')
    $.get(url, formData, (data, textStatus) => {
      for(let id in data) {
        $(`#${id}`).val(data[id])
        if (id == 'error') flash_alert(data[id])
      }
      console.log(data)
      this.processingTarget.classList.remove('active')
    })
  }

  // https://esausilva.com/2017/02/21/filter-select-list-options-typeahead-in-javascript-es6/
  limit_select_options(event) {
    const value = event.currentTarget.value
    const select = document.querySelector(this.data.get('selector'))
    if (this.selectOptionsTarget === undefined) {
      this.selectOptionsTarget = Array.from(select.options)
    }
    this.selectOptionsTarget.forEach(option => {
      option.remove()
      option.selected = false
    })
    const matchArray = this.selectOptionsTarget.filter(option => {
      const regex = new RegExp(value, 'gi')
      return option.text.match(regex)
    })
    select.append(...matchArray)
    console.log(`limit_select_options ${value} ${matchArray.length}`)
  }
}
