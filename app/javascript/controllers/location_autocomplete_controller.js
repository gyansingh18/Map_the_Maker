// import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="location-autocomplete"
export default class extends Controller {
  static values = { apiKey: String, imageLink: String }

  static targets = ["location"]

  connect() {
    console.log("in autocomplete ")
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address"
    })
    this.geocoder.addTo(this.element)
    this.geocoder.on("result", event => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())

    // MAP DISPLAY
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: document.getElementById("map"),
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    this.map.on('load', () => {
      this.map.setCenter([115.137, -8.54]); // A more central point for Bali
      this.map.setZoom(9);
    });
  }

  #setInputValue(event) {
    this.locationTarget.value = event.result["place_name"]

    // ADD MARKER TO MAP
    const customMarker = document.createElement("div")
    customMarker.innerHTML = `<img height="30" width="30" alt="Logo" src="${this.imageLinkValue}"></img>`

    this.marker = new mapboxgl.Marker(customMarker)
      .setLngLat(event.result.center)
      .addTo(this.map)

    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend(event.result.center)
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 12, duration: 0 })
  }

  #clearInputValue() {
    this.locationTarget.value = "";
    this.marker.remove();
  }

  disconnect() {
    this.geocoder.onRemove()
  }
}
