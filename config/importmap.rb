# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "star-rating.js" # @4.3.1
pin "#lib/client.js", to: "#lib--client.js.js" # @0.13.7
pin "@mapbox/mapbox-gl-geocoder", to: "https://ga.jspm.io/npm:@mapbox/mapbox-gl-geocoder@5.0.0/lib/index.js"
pin "#lib/client.js", to: "https://ga.jspm.io/npm:@mapbox/mapbox-sdk@0.13.7/lib/browser/browser-client.js"
pin "@mapbox/fusspot", to: "https://ga.jspm.io/npm:@mapbox/fusspot@0.4.0/lib/index.js"
pin "@mapbox/mapbox-sdk", to: "https://ga.jspm.io/npm:@mapbox/mapbox-sdk@0.13.7/index.js"
pin "@mapbox/mapbox-sdk/services/geocoding", to: "https://ga.jspm.io/npm:@mapbox/mapbox-sdk@0.13.7/services/geocoding.js"
pin "@mapbox/parse-mapbox-token", to: "https://ga.jspm.io/npm:@mapbox/parse-mapbox-token@0.2.0/index.js"
pin "base-64" # @0.1.0
pin "eventemitter3" # @3.1.2
pin "events" # @3.3.0
pin "fuzzy" # @0.1.3
pin "is-plain-obj" # @1.1.0
pin "lodash.debounce" # @4.0.8
pin "nanoid" # @3.3.11
pin "subtag" # @0.5.0
pin "suggestions" # @1.7.1
pin "xtend" # @4.0.2
pin "mapbox-gl" # @3.1.2
pin "process" # @2.1.0
