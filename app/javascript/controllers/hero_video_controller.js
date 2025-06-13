// app/javascript/controllers/hero_video_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["video"];

  connect() {
    console.log("Video Playing")
    if (this.hasVideoTarget) {
      this.videoTarget.playbackRate = 1; // Set desired speed for hero video playback
    }
  }
}
