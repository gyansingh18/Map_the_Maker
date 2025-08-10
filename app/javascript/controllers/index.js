// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AnimatedNumber from '@stimulus-components/animated-number'

application.register('animated-number', AnimatedNumber)

eagerLoadControllersFrom("controllers", application)
