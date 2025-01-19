// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"]; // Define o elemento alvo

  toggle() {
    this.menuTarget.classList.toggle("hidden");  // Alterna a classe 'hidden'
    this.menuTarget.classList.toggle("visible"); // Alterna a classe 'visible'
  }
}
