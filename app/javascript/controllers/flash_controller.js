import { Controller } from 'stimulus'
const jBox = require('jbox')

export default class extends Controller {
  connect() {
    this._show_message()
  }

  show(event) {
    event.preventDefault()
    this._show_message()
  }

  _show_message() {
    const message = this.data.get('message')
    if (message.length == 0) return
    const addClass = this.data.has('alert') ? 'flash-alert' : 'flash-notice'
    flash_message(message, addClass)
  }
}

window.flash_alert = function(message) {
  flash_message(message, 'flash-alert')
}

window.flash_notice = function(message) {
  flash_message(message, 'flash-notice')
}
window.flash_message = function(message, addClass) {
  console.log(`flash_message ${addClass} ${message}`)
  // https://stephanwagner.me/jBox/get_started
  new jBox('Notice', {
    autoClose: 10000,
    attributes: {
      x: 'right',
      y: 'bottom',
    },
    stack: true,
    animation: {
      open:'bounce',
      close:'fadeOut',
    },
    content: message,
    addClass: addClass,
  })
}
