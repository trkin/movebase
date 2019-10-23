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
}
