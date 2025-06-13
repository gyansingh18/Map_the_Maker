import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
// import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/pdunleav/cjofefl7u3j3e2sp0ylex3cyb"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken, mapboxgl: mapboxgl }))
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

        const customMarker = document.createElement("div");
        customMarker.innerHTML = marker.marker_html;

        new mapboxgl.Marker(customMarker)
          .setLngLat([ marker.lng, marker.lat ])
          .setPopup(popup)
          .addTo(this.map)
      })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}




// import { Controller } from "@hotwired/stimulus"
// import mapboxgl from 'mapbox-gl'

// export default class extends Controller {
//   static values = {
//     apiKey: String,
//     markers: Array
//   }

//   connect() {
//     mapboxgl.accessToken = this.apiKeyValue

//     this.map = new mapboxgl.Map({
//       container: this.element,
//       style: "mapbox://styles/mapbox/streets-v10",
//       center: [115.188919,-8.409518],
//       zoom: 2
//     })

//       marker = new mapboxgl.Marker({ draggable: true })
//         .setLngLat([115.188919,-8.409518])
//         .addTo(map)

//       marker.on('dragend', function() {
//         const lngLat = marker.getLngLat();
//         document.getElementById('coordinates').innerHTML =
//           `Longitude: ${lngLat.lng}<br />Latitude: ${lngLat.lat}`;
//       })

//     // this.#addMarkersToMap()
//     // this.#fitMapToMarkers()
//   }
// }
//   //  marker = new mapboxgl.Marker({ draggable: true })
//   // .setLngLat([0, 0])
//   // .addTo(map);


//   // marker = new mapboxgl.Marker({ draggable: true })
//   //   .setLngLat([0, 0])
//   //   .addTo(map);

//   // marker.on('dragend', function() {
//   //   const lngLat = marker.getLngLat();
//   //   document.getElementById('coordinates').innerHTML =
//   //     `Longitude: ${lngLat.lng}<br />Latitude: ${lngLat.lat}`;
//   // });
