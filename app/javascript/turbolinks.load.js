// https://stephanwagner.me/jBox/get_started#tooltips
const jBox = require('jbox')
const trkDatatables = require('trk_datatables')
import { I18N } from 'const'

document.addEventListener('turbolinks:load', () => {
  // add tooltip to all elements with title <a title='Hi'>
  new jBox('Tooltip', {
    attach: '[title]'
  })

  trkDatatables.initialise({
    language: I18N.datatables[document.documentElement.lang],
  })

  $('[data-select2-initialize]').each(function() {
    let options = {
    }
    if ($(this).attr('placeholder')) options['placeholder'] = $(this).attr('placeholder')
    // else
    // options['placeholder'] = 'Please select'
    options['language'] = I18N.select2[document.documentElement.lang]
    $(this).select2(options)
  })

  // $('[data-select2-ajax-initialize]').each ->
  //   url = $(this).data('select2AjaxInitialize')
  //   options = {
  //     ajax: {
  //       url: url
  //       dataType: 'json'
  //     }
  //     width: 'resolve'
  //   }
  //   if $(this).attr 'placeholder'
  //     options['placeholder'] = $(this).attr 'placeholder'
  //   else
  //     options['placeholder'] = '<%= I18n.translate 'please_select' %>'
  //   $(this).select2 options
  //   # click on label should trigger open and focus
  //   # https://github.com/select2/select2/issues/2311#issuecomment-180666626
  //   $(this).focus ->
  //     $(this).select2('open')
})
