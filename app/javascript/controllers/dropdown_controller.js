import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menuDropdown"];

  connect() {
    // Certifique-se de que o menu começa oculto
    this.menuDropdownTarget.classList.add("hidden");
  }

  show() {
    this.menuDropdownTarget.classList.remove("hidden");
    this.menuDropdownTarget.classList.add("visible");
  }

  hide() {
    this.menuDropdownTarget.classList.remove("visible");
    this.menuDropdownTarget.classList.add("hidden");
  }

  toggle(event) {
    event.preventDefault(); // Impede o comportamento padrão
    if (this.menuDropdownTarget.classList.contains("hidden")) {
      this.show();
    } else {
      this.hide();
    }
  }
}
