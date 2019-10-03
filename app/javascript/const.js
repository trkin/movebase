export const GOOGLE_API_KEY = 'AIzaSyBbLOnV7ig3oTRzStRLEfz54MAqvrZ4VMc'
export const GOOGLE_MAPS_PLACES_COUNTRY = 'rs'
// data for js translations
export const I18N = {
  datatables: {
    sr: require(`./locales/datatables.sr.json`),
    'sr-latin': require(`./locales/datatables.sr-latin.json`),
    en: require(`./locales/datatables.en.json`),
  },
  // https://github.com/select2/select2/tree/develop/src/js/select2/i18n
  // select2 will determine based on [lang] if no language option is fiven
  // we need to require before using i18n file
  select2: {
    sr: 'sr-Cyrl',
    _sr: require('select2/dist/js/i18n/sr-Cyrl.js'),
    'sr-latin': 'sr.js',
    '_sr-latin': require('select2/dist/js/i18n/sr.js'),
    en: 'en.js',
    _en: require('select2/dist/js/i18n/en.js'),
  },
}
