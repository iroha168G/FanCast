document.addEventListener("DOMContentLoaded", () => {
  const timers = document.querySelectorAll(".elapsed-time");

  timers.forEach(timer => {
    const startTime = new Date(timer.dataset.start);

    const updateElapsed = () => {
      const now = new Date();
      const diff = Math.floor((now - startTime) / 1000);

      const hours = Math.floor(diff / 3600);
      const minutes = Math.floor((diff % 3600) / 60);
      const seconds = diff % 60;

      timer.textContent = 
        `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    };

    updateElapsed();
    setInterval(updateElapsed, 1000);
  });
});
