// ✅ Show the loading spinner immediately
function showLoading() {
    if (document.getElementById("loading-overlay")) return; // Prevent duplicate overlays

    // Create overlay
    const loadingOverlay = document.createElement("div");
    loadingOverlay.id = "loading-overlay";
    loadingOverlay.style.position = "fixed";
    loadingOverlay.style.top = "0";
    loadingOverlay.style.left = "0";
    loadingOverlay.style.width = "100%";
    loadingOverlay.style.height = "100%";
    loadingOverlay.style.background = "rgba(0, 0, 0, 0.5)";
    loadingOverlay.style.display = "flex";
    loadingOverlay.style.alignItems = "center";
    loadingOverlay.style.justifyContent = "center";
    loadingOverlay.style.zIndex = "9999";

    // ✅ Add the spinner inside the loading overlay
    loadingOverlay.innerHTML = `
      <div class="spinner">
        <div></div><div></div><div></div>
        <div></div><div></div><div></div>
      </div>
    `;

    // ✅ Append styles for the spinner
    const style = document.createElement("style");
    style.innerHTML = `
      .spinner {
        width: 70.4px;
        height: 70.4px;
        --clr: rgb(247, 197, 159);
        --clr-alpha: rgb(247, 197, 159,.1);
        animation: spinner 1.6s infinite ease;
        transform-style: preserve-3d;
        position: relative;
      }

      .spinner > div {
        background-color: var(--clr-alpha);
        height: 100%;
        position: absolute;
        width: 100%;
        border: 3.5px solid var(--clr);
      }

      .spinner div:nth-of-type(1) { transform: translateZ(-35.2px) rotateY(180deg); }
      .spinner div:nth-of-type(2) { transform: rotateY(-270deg) translateX(50%); transform-origin: top right; }
      .spinner div:nth-of-type(3) { transform: rotateY(270deg) translateX(-50%); transform-origin: center left; }
      .spinner div:nth-of-type(4) { transform: rotateX(90deg) translateY(-50%); transform-origin: top center; }
      .spinner div:nth-of-type(5) { transform: rotateX(-90deg) translateY(50%); transform-origin: bottom center; }
      .spinner div:nth-of-type(6) { transform: translateZ(35.2px); }

      @keyframes spinner {
        0% { transform: rotate(45deg) rotateX(-25deg) rotateY(25deg); }
        50% { transform: rotate(45deg) rotateX(-385deg) rotateY(25deg); }
        100% { transform: rotate(45deg) rotateX(-385deg) rotateY(385deg); }
      }
    `;

    document.head.appendChild(style);
    document.body.appendChild(loadingOverlay);
}

// ✅ Hide the loading spinner
function hideLoading() {
    const loadingOverlay = document.getElementById("loading-overlay");
    if (loadingOverlay) {
        document.body.removeChild(loadingOverlay);
    }
}

// ✅ Download PDF with loading indicator
function downloadPDF(pdfBase64, filename) {
    showLoading(); // ✅ Show loading immediately

    setTimeout(() => {
        try {
            const byteArray = Uint8Array.from(atob(pdfBase64), c => c.charCodeAt(0));
            const blob = new Blob([byteArray], { type: "application/pdf" });

            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = filename;

            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(link.href);
        } catch (error) {
            console.error("Error downloading PDF:", error);
        } finally {
            hideLoading(); // ✅ Hide loading after download starts
        }
    }, 500); // ✅ Reduced delay for a faster loader
}
