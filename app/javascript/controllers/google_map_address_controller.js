import { Controller } from 'stimulus'
import { GOOGLE_API_KEY, GOOGLE_MAPS_PLACES_COUNTRY } from 'const'

const INITIAL_LATITUDE = 45.2671352
const INITIAL_LONGITUDE = 19.83354959999997
const INITIAL_ZOOM = 12

// https://discourse.stimulusjs.org/t/call-stimulus-function-from-google-maps-callback/191
window.dispatchMapAddressEvent = function(...detail) {
  const event = new CustomEvent('googleMapAddressInitMap', { detail: detail })
  window.dispatchEvent(event)
}

window.dispatchWindowEvent = function(event_name, ...detail) {
  const event = new CustomEvent(event_name, { detail: detail })
  window.dispatchEvent(event)
}

export default class extends Controller {
  static targets = ['map', 'address', 'latitude', 'longitude']

  connect() {
    // http://stackoverflow.com/questions/9228958/how-to-check-if-google-maps-api-is-loaded
    if (typeof google === 'object' && typeof google.maps === 'object') {
      console.log('connect google is loaded but we need to bind on newly created object')
      this.googleMapAddressInitMap();
    } else {
      console.log('connect loadScript')
      this.loadScript();
    }
  }

  googleMapAddressInitMap(event) {
    let latitude = parseFloat(this.latitudeTarget.value) || INITIAL_LATITUDE
    let longitude = parseFloat(this.longitudeTarget.value) || INITIAL_LONGITUDE
    console.log(`googleMapAddressInitMap ${latitude} ${longitude}`)
    let zoom_level = INITIAL_ZOOM
    this.map = new google.maps.Map(this.mapTarget, {
      center: { lat: latitude, lng: longitude },
      zoom: zoom_level,
    })

    let autocomplete = new google.maps.places.Autocomplete(
      this.addressTarget,
      { componentRestrictions: { country: GOOGLE_MAPS_PLACES_COUNTRY } }
    )
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
    autocomplete.bindTo('bounds', this.map);
    autocomplete.addListener('place_changed', function() {
      let place = autocomplete.getPlace();
      window.dispatchWindowEvent('googleMapAddressPlaceChanged', marker, place)
      console.log('place_changed');
    });

    google.maps.event.addListener(marker, "dragend", function(e) {
      window.dispatchWindowEvent('googleMapAddressDragend', marker)
      console.log('dragend');
    });
  }

  googleMapAddressDragEnd(event) {
    let [marker] = event.detail
    this.updateFields(marker.getPosition())
  }

  googleMapAddressPlaceChanged(event) {
    let [marker, place] = event.detail
    if (!place.geometry) {
      window.alert("#{I18n.t('autocomplete_contains_no_geometry')}");
      return;
    }
    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      this.map.fitBounds(place.geometry.viewport);
    } else {
      this.map.setCenter(place.geometry.location);
      this.map.setZoom(17);  // Why 17? Because it looks good.
    }
    marker.setPosition(place.geometry.location);
    this.updateFields(place.geometry.location);
  }

  updateFields(location) {
    console.log('updateFields')
    this.latitudeTarget.value = location.lat()
    this.longitudeTarget.value = location.lng()
  }

  // https://developers.google.com/maps/documentation/javascript/examples/map-simple-async
  loadScript() {
    let script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://maps.googleapis.com/maps/api/js?libraries=places' +
      `&key=${GOOGLE_API_KEY}&callback=dispatchMapAddressEvent`;
    document.body.appendChild(script);
  }
}
