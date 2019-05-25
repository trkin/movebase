import { Controller } from 'stimulus'
import { GOOGLE_API_KEY } from 'const'
const INITIAL_ZOOM = 12

// https://discourse.stimulusjs.org/t/call-stimulus-function-from-google-maps-callback/191
window.dispatchMapEvent = function(...detail) {
  const event = new CustomEvent('google-map-callback', { detail: detail })
  window.dispatchEvent(event)
}

export default class extends Controller {
  connect() {
    // http://stackoverflow.com/questions/9228958/how-to-check-if-google-maps-api-is-loaded
    if (typeof google === 'object' && typeof google.maps === 'object') {
      console.log('connect google is loaded but we need to bind on newly created object')
      this.initMap();
    } else {
      console.log('connect loadScript')
      this.loadScript();
    }
  }

  initMap(event) {
    console.log('initMap')
    let latitude = parseFloat(this.data.get('latitude'))
    let longitude = parseFloat(this.data.get('longitude'))
    let zoom_level = INITIAL_ZOOM
    this.map = new google.maps.Map(this.element, {
      center: { lat: latitude, lng: longitude },
      zoom: zoom_level,
    })

    let marker = new google.maps.Marker({
      map: this.map,
      anchorPoint: new google.maps.Point(0, -29),
      draggable: true,
      animation: google.maps.Animation.DROP,
      position: {
        lat: latitude,
        lng: longitude,
      },
    })
  }

  // https://developers.google.com/maps/documentation/javascript/examples/map-simple-async
  loadScript() {
    let script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://maps.googleapis.com/maps/api/js?libraries=places' +
      `&key=${GOOGLE_API_KEY}&callback=dispatchMapEvent`;
    document.body.appendChild(script);
  }
}
