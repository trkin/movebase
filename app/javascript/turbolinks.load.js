// https://stephanwagner.me/jBox/get_started#tooltips
const jBox = require('jbox')
const $ = require('jquery')
const trkDatatables = require('trk_datatables')(window, $)

document.addEventListener('turbolinks:load', () => {
  // add tooltip to all elements with title <a title='Hi'>
  new jBox('Tooltip', {
    attach: '[title]'
  })

  trkDatatables.initialise()
})
