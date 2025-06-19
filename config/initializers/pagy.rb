# Optionally override some pagy default with your own in the pagy initializer
Pagy::DEFAULT[:limit] = 5 # items per page
# Pagy::DEFAULT[:size]  = 9  # nav bar links
# Pagy::DEFAULT[:size]  = [1,4,4,1] # nav bar links (optional)

# Better user experience handled automatically
require 'pagy/extras/overflow'
# Pagy::DEFAULT[:overflow] = :last_page
require 'pagy/extras/bootstrap'
