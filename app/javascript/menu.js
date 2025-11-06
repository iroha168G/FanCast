document.addEventListener("turbo:load", () => {
  const button = document.getElementById("menu-button");
  const menu = document.getElementById("menu");
  const menuIcon = document.getElementById("menu-icon");
  const closeIcon = document.getElementById("close-icon");

  if (button) {
    button.addEventListener("click", () => {
      menu.classList.toggle("hidden");
      menuIcon.classList.toggle("hidden");
      closeIcon.classList.toggle("hidden");
    });
  }
});
