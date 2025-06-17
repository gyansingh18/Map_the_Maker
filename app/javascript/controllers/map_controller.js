// app/javascript/controllers/map_controller.js

import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  // Add a new property to store the currently open popup
  activePopup = null;

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    this.#fitMapToMarkers()

    this.map.on('load', () => {
      this.map.setCenter([115.137, -8.54]); // A more central point for Bali
      this.map.setZoom(9);
      this.#addMarkersToMap();
    });

    // Event listener to clear activePopup when any popup is closed manually by user
    this.map.on('popupclose', () => {
      this.activePopup = null;
    });
  }

  getDirections(event) {
    // Close the currently active popup if one exists
    if (this.activePopup) {
      this.activePopup.remove();
      this.activePopup = null; // Clear the reference
    }

    const targetLat = event.currentTarget.dataset.mapTargetLat;
    const targetLng = event.currentTarget.dataset.mapTargetLng;
    const destination = [targetLng, targetLat];

    console.log("Attempting to get directions to:", destination);

    if (navigator.geolocation) {
      try {
        navigator.geolocation.getCurrentPosition((position) => {
          const origin = [position.coords.longitude, position.coords.latitude];
          console.log("User current location (origin):", origin);

          this.#fetchDirections(origin, destination);
        }, (error) => {
          console.error("Geolocation error during getCurrentPosition:", error);
          let errorMessage = "Could not get your current location for directions.";
          if (error.code === error.PERMISSION_DENIED) {
            errorMessage += " Permission denied. Please enable location services for this site.";
          } else if (error.code === error.POSITION_UNAVAILABLE) {
            errorMessage += " Position unavailable. Ensure GPS/Wi-Fi is on.";
          } else if (error.code === error.TIMEOUT) {
            errorMessage += " Timeout. Couldn't get location in time.";
          }
          alert(errorMessage);
        }, { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 });
      } catch (e) {
        console.error("Error calling navigator.geolocation.getCurrentPosition:", e);
        alert("An unexpected error occurred with geolocation. Please check browser settings.");
      }
    } else {
      alert("Your browser does not support Geolocation. Cannot provide directions.");
    }
  }

  #fetchDirections(origin, destination) {
    const query = `https://api.mapbox.com/directions/v5/mapbox/driving/${origin[0]},${origin[1]};${destination[0]},${destination[1]}?steps=true&geometries=geojson&access_token=${mapboxgl.accessToken}`;

    console.log("Fetching directions with query:", query);

    fetch(query)
      .then(response => {
        if (!response.ok) {
          console.error("Mapbox API response not OK:", response.status, response.statusText);
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        if (data.routes && data.routes.length > 0) {
          const route = data.routes[0].geometry;
          console.log("Route received from Mapbox API:", route);
          this.#addRouteToMap(route);
        } else {
          console.warn("No routes found in Mapbox API response:", data);
          alert("Could not find a route to this maker. Please try a different location.");
        }
      })
      .catch(error => {
        console.error("Error fetching directions from Mapbox:", error);
        alert("There was an error getting directions. Please check your internet connection and try again.");
      });
  }

  #addRouteToMap(route) {
    if (this.map.getSource('route')) {
      this.map.removeLayer('route');
      this.map.removeSource('route');
    }

    this.map.addSource('route', {
      'type': 'geojson',
      'data': {
        'type': 'Feature',
        'properties': {},
        'geometry': route
      }
    });

    this.map.addLayer({
      'id': 'route',
      'type': 'line',
      'source': 'route',
      'layout': {
        'line-join': 'round',
        'line-cap': 'round'
      },
      'paint': {
        'line-color': '#3887be',
        'line-width': 5,
        'line-opacity': 0.75
      }
    });

     // Optional: Fit the map to the route's bounds
    const coordinates = route.coordinates;
    const bounds = new mapboxgl.LngLatBounds();
    for (const coord of coordinates) {
      bounds.extend(coord);
    }
    this.map.fitBounds(bounds, { padding: 250 });
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      // Store a reference to the popup when it's opened
      popup.on('open', () => {
        this.activePopup = popup;
      });

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const baliBounds = [
      [114.225, -8.823],
      [115.659, -8.044]
    ];
    this.map.fitBounds(baliBounds, { padding: 10, maxZoom: 25, duration: 0 });
  }

}
