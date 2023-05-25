function save(filename, data) {
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
