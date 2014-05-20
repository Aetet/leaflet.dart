part of leaflet.map.handler;

// ScrollWheelZoom is used by L.Map to enable mouse scroll wheel zoom on the map.
class ScrollWheelZoom extends Handler {
  addHooks() {
    L.DomEvent.on(this._map._container, 'mousewheel', this._onWheelScroll, this);
    L.DomEvent.on(this._map._container, 'MozMousePixelScroll', L.DomEvent.preventDefault);
    this._delta = 0;
  }

  removeHooks() {
    L.DomEvent.off(this._map._container, 'mousewheel', this._onWheelScroll);
    L.DomEvent.off(this._map._container, 'MozMousePixelScroll', L.DomEvent.preventDefault);
  }

  _onWheelScroll(e) {
    var delta = L.DomEvent.getWheelDelta(e);

    this._delta += delta;
    this._lastMousePos = this._map.mouseEventToContainerPoint(e);

    if (!this._startTime) {
      this._startTime = /*+*/new Date();
    }

    var left = Math.max(40 - (/*+*/new Date() - this._startTime), 0);

    clearTimeout(this._timer);
    this._timer = setTimeout(L.bind(this._performZoom, this), left);

    L.DomEvent.preventDefault(e);
    L.DomEvent.stopPropagation(e);
  }

  _performZoom() {
    var map = this._map,
        delta = this._delta,
        zoom = map.getZoom();

    delta = delta > 0 ? Math.ceil(delta) : Math.floor(delta);
    delta = Math.max(Math.min(delta, 4), -4);
    delta = map._limitZoom(zoom + delta) - zoom;

    this._delta = 0;
    this._startTime = null;

    if (!delta) { return; }

    if (map.options.scrollWheelZoom == 'center') {
      map.setZoom(zoom + delta);
    } else {
      map.setZoomAround(this._lastMousePos, zoom + delta);
    }
  }
}