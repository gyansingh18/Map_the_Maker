// app/javascript/controllers/map_controller.js

import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  // static targets = [ "instructions" ]
  static values = {
    apiKey: String,
    markers: Array
  }

  // Add a new property to store the currently open popup
  activePopup = null;

  connect() {
    console.log("stimulus map")
    this.instructions = document.getElementById('instructions');
    this.instructions.classList.add('d-none');
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    this.#fitMapToMarkers()

    this.map.on('load', () => {
      // this.map.setCenter([115.137, -8.54]); // A more central point for Bali
      // this.map.setZoom(9);
      this.#addMarkersToMap();
    });

    // Event listener to clear activePopup when any popup is closed manually by user
    this.map.on('popupclose', () => {
      this.activePopup = null;
    });

    // this.getRoute([-122.677738,45.522458])
  }

  // create a function to make a directions request and update the destination
  // async getRoute(end) {

  //   // an arbitrary start/origin point will always be the same
  //   // only the end/destination will change
  //   const start = [-122.662323, 45.523751];

  //   // this is where the code for the next step will go

  //   // make a directions request using cycling profile
  //   const query = await fetch(
  // `https://api.mapbox.com/directions/v5/mapbox/cycling/${start[0]},${start[1]};${end[0]},${end[1]}?steps=true&geometries=geojson&access_token=${mapboxgl.accessToken}`
  //   );
  //   const json = await query.json();
  //   const data = json.routes[0];
  //   const route = data.geometry;
  //   const geojson = {
  //     'type': 'Feature',
  //     'properties': {},
  //     'geometry': data.geometry
  //   };

  //   if (this.map.getSource('route')) {
  //     // if the route already exists on the map, reset it using setData
  //     this.map.getSource('route').setData(geojson);
  //   }

  //   // otherwise, add a new layer using this data
  //   else {
  //     this.map.addLayer({
  //       id: 'route',
  //       type: 'line',
  //       source: {
  //         type: 'geojson',
  //         data: geojson
  //       },
  //       layout: {
  //         'line-join': 'round',
  //         'line-cap': 'round'
  //       },
  //       paint: {
  //         'line-color': '#3887be',
  //         'line-width': 5,
  //         'line-opacity': 0.75
  //       }
  //     });
  //   }
  // }

  getDirections(event) {
    // Close the currently active popup if one exists
    if (this.activePopup) {
      this.activePopup.remove();
      this.activePopup = null; // Clear the reference
    }

    const targetLat = parseFloat(event.currentTarget.dataset.mapTargetLat);
    const targetLng = parseFloat(event.currentTarget.dataset.mapTargetLng);
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
  };

  #fetchDirections(origin, destination) {
    const query = `https://api.mapbox.com/directions/v5/mapbox/driving/${origin[0]},${origin[1]};${destination[0]},${destination[1]}?alternatives=true&annotations=duration%2Cdistance&geometries=geojson&language=en&overview=full&steps=true&access_token=${mapboxgl.accessToken}`;

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
          const route = data.routes[0];
          const geo = route.geometry;
          // const instructions = document.getElementById('instructions');
          const steps = route.legs[0].steps;

          // instructionsDiv.style.display = 'block'; // Show the display block

          // let tripInstructions = '';
          //   for (const step of steps) {
              // tripInstructions += `<li>${step.maneuver.instruction}</li>`;
            // }

          const duration = Math.floor(route.duration / 60); // in minutes
          const distance = (route.distance / 1000).toFixed(1); // in kilometers

          this.instructions.innerHTML = `
            <div class="trip-summary">
              <span>🛵 <strong>${duration} min</strong> (${distance} km)</span>
              <button class="clear-route-button" data-action="click->map-reset#close">×</button>
            </div>
          `;
          this.instructions.classList.remove('d-none');

          console.log("Route received from Mapbox API:", geo);
          this.#addRouteToMap(geo);
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
        'line-color': '#DEA82B',
        'line-width': 5,
        'line-opacity': 0.75
      }
    });

    // Add starting point to the map
    if (this.map.getLayer('start')) {
      this.map.removeLayer('start');
      this.map.removeSource('start');
    }

    this.map.addSource('start', {
      type: 'geojson',
      data: {
        type: 'Feature',
        geometry: {
          type: 'Point',
          // Get the first coordinate from the route, which is the start
          coordinates: route.coordinates[0]
        }
      }
    });

    this.map.addLayer({
      id: 'start',
      type: 'circle',
      source: 'start',
      paint: {
        'circle-radius': 7,
        'circle-color': '#3887be', // A clear blue for the start point
        'circle-stroke-width': 2,
        'circle-stroke-color': '#ffffff' // White outline for visibility
      }
    });

     // Optional: Fit the map to the route's bounds
    const coordinates = route.coordinates;
    const bounds = new mapboxgl.LngLatBounds();
    for (const coord of coordinates) {
      bounds.extend(coord);
    }
    this.map.fitBounds(bounds, { padding: 125 });
  }

  // clearRoute() { // ADD THIS ENTIRE METHOD
  //   if (this.map.getSource('route')) {
  //     this.map.removeLayer('route');
  //     this.map.removeSource('route');
  //   }
  //   const instructionsDiv = document.getElementById('instructions');
  //   instructionsDiv.style.display = 'none';
  //   instructionsDiv.innerHTML = '';
  // }

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
    // const baliBounds = [
    //   [114.225, -8.823],
    //   [115.659, -8.044]
    // ];
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 50, maxZoom: 15, duration: 0 })
  }

   clearRoute() {
    // Hide the instructions panel by clearing its content
    const instructionsDiv = document.getElementById('instructions');
    instructionsDiv.innerHTML = '';
    this.instructions.classList.add('d-none'); // Add this line


    // Remove the route line from the map
    if (this.map.getSource('route')) {
      this.map.removeLayer('route');
      this.map.removeSource('route');
    }

    // Remove the start marker from the map
    if (this.map.getLayer('start')) {
        this.map.removeLayer('start');
        this.map.removeSource('start');
    }

    // Optional: Fit map back to all markers
    this.#fitMapToMarkers();
  }

}
