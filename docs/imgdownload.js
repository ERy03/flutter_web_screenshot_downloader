function save(filename, data) {
  const blob = new Blob([data], { type: "application/octet-stream" });
    const elem = window.document.createElement("a");
    elem.href = window.URL.createObjectURL(blob);
    elem.download = filename;
    document.body.appendChild(elem);
    const evt = new Event("click", { bubbles: true, cancelable: false});
    elem.dispatchEvent(evt);
    document.body.removeChild(elem);
}
