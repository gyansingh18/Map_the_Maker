# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "star-rating.js" # @4.3.1
# pin "tom-select/dist/js/tom-select.complete.min.js", to: "tom-select--dist--js--tom-select.complete.min.js.js" # @2.4.3
pin "tom-select" # @2.4.1

pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@3.1.2/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.1.0/nodelibs/browser/process-production.js"
pin "@stimulus-components/animated-number", to: "https://ga.jspm.io/npm:@stimulus-components/animated-number@5.0.0/dist/stimulus-animated-number.mjs"
