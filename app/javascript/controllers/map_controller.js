// app/javascript/controllers/map_controller.js

import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

   this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    this.#fitMapToMarkers()

    // Set a default center and zoom for Bali instead of fitting bounds
    this.map.on('load', () => { // Ensure map is loaded before setting view
      this.map.setCenter([115.137, -8.54]); // A more central point for Bali
      this.map.setZoom(9); // Adjust this zoom level to zoom in/out
    });

    this.#addMarkersToMap()

  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      // Create a HTML element for your custom marker
      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      // Pass the element as an argument to the new marker
      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const baliBounds = [
      [114.225, -8.823], // Southwest coordinates of Bali
      [115.659, -8.044]  // Northeast coordinates of Bali
    ];
    this.map.fitBounds(baliBounds, { padding: 10, maxZoom: 25, duration: 0 });
  }

}
