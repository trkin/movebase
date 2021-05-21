import { Controller } from 'stimulus'

export default class extends Controller {
  // add class 'active'
  add() {
    let selector = this.data.get('selector')
    let elements = this._findElements(selector)
    for (let element of elements) {
      element.classList.add('active')
    }
    console.log(`activate#add ${selector}`)
  }

  // toggle class 'active'
  // <div class='sidebar__overlay' data-controller='activate' data-action='click->activate#toggle' data-activate-selector='#sidebar,.sidebar__overlay'></div>
  // <%= button_tag class: "btn btn-link", 'data-controller': 'activate', 'data-action': 'activate#toggle', 'data-activate-selector': '#sidebar,.sidebar__overlay' do %>
  toggle() {
    let selector = this.data.get('selector')
    let elements = this._findElements(selector)
    for (let element of elements) {
      element.classList.toggle('active')
    }
    console.log(`activate#toggle ${selector}`)
  }

  // toggle and remove self element
  toggleAndRemoveMe() {
    this.toggle()
    this.element.innerHTML = ''
  }

  // this is for radio button with some VALUE
  // enable and disable targets which has data value that contains VALUE
  enableDisableForValue(event) {
    let selector = this.data.get('selector')
    let elements = this._findElements(selector)
    let value = event.target.value
    for (let element of elements) {
      if (element.dataset.activateValue.indexOf(value) != -1) {

        element.classList.add('active')
        element.disabled = false
        for(let input of element.querySelectorAll('input,select')) {
          input.disabled = false
        }
      } else {
        element.classList.remove('active')
        element.disabled = true
        for(let input of element.querySelectorAll('input,select')) {
          input.disabled = true
        }
      }
    }
    // we need this for jbox modal to be resized
    window.dispatchEvent(new Event('resize'))
    console.log(`activate#enableDisableForValue ${selector} ${value}`)
  }

  _findElements(selectors) {
    let elements = []
    for (let selector of selectors.split(',')) {
      if (selector[0] == '#') {
        let element_by_id = document.getElementById(selector.substring(1))
        if (element_by_id) elements.push(element_by_id)
      } else if (selector[0] == '.') {
        let elements_by_class = document.getElementsByClassName(selector.substring(1))
        elements = elements.concat(Array.from(elements_by_class))
      } else {
        let elements_by_tag_name = document.getElementsByTagName(selector)
        elements = elements.concat(Array.from(elements_by_tag_name))
      }
    }
    return elements
  }
}
