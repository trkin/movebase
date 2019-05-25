window.dispatchWindowEvent = function(event_name, ...detail) {
  const event = new CustomEvent(event_name, { detail: detail })
  window.dispatchEvent(event)
}
