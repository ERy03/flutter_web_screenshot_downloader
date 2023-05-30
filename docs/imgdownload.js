function save(data) {
  try {
    const blob = new Blob([data], { type: "image/png" });
    const elem = window.document.createElement("a");
    elem.href = window.URL.createObjectURL(blob);
    elem.download = "dog.png";
    document.body.appendChild(elem);
    elem.click();
    document.body.removeChild(elem);
  } catch (error) {
    console.error(error);
  }
}

function saveTouchEnd(filename, data) {
  const blob = new Blob([data], { type: "image/png" });
  console.log(blob);
  const elem = window.document.createElement("a");
  console.log(elem);
  elem.href = window.URL.createObjectURL(blob);
  console.log(elem.href);
  elem.download = filename;
  document.body.appendChild(elem);
  elem.click();
  document.body.removeChild(elem);
}

// using filesaver.js
function downloadImage(uint8Array) {
  var blob = new Blob([uint8Array], { type: "image/png" });
  saveAs(blob, "screenshot.png");
}
function downloadImageAsFile(uint8Array) {
  var file = new File([uint8Array], { type: "image/png" });
  saveAs(file, "screenshot.png");
}
