library leaflet;

import 'dart:html';
import 'dart:js';
import 'dart:async';
import 'dart:convert' show JSON;

part 'options.dart';
part 'geo.dart';
part 'control.dart';

part 'layer/layer.dart';
part 'layer/tile.dart';
part 'layer/marker.dart';
part 'layer/vector.dart';

class LeafletMap {
  JsObject _L;
  JsObject _map;

  LeafletMap.selector(String selectors, [MapOptions options]) {
    _L = context['L'];
    var args = [selectors];
    if (options != null) {
      args.add(options.jsify());
    }
    _map = _L.callMethod('map', args);
  }

  LeafletMap(Element container, [MapOptions options]) {
    _L = context['L'];
    _map = _L.callMethod('map', [container, options.jsify()]);
  }

  void setView(LatLng center, num zoom,
      [ZoomPanOptions options, LatLngBounds maxBounds]) {
    var args = [center._latlng, zoom];
    if (options != null) {
      args.add(options.jsify());
    }
    if (maxBounds != null) {
      args.add(maxBounds._llb);
    }
    _map.callMethod('setView', args);
  }

  /// Adds the given layer to the map. If optional insertAtTheBottom is set to
  /// true, the layer is inserted under all others (useful when switching base
  /// tile layers).
  void addLayer(Layer layer) {
    _map.callMethod('addLayer', [layer.layer]);
  }

  void removeLayer(Layer layer) {
    _map.callMethod('removeLayer', [layer.layer]);
  }

  void eachLayer(f) {
    _map.callMethod('eachLayer', [allowInterop(f)]);
  }

  /// Returns the LatLngBounds of the current map view.
  LatLngBounds getBounds() {
    var llb = _map.callMethod('getBounds');
    return new LatLngBounds._(_L, llb);
  }

  /// Adds the given control to the map.
  void addControl(Control control) {
    _map.callMethod('addControl', [control.control]);
  }

  /// Removes the given control from the map.
  void removeControl(Control control) {
    _map.callMethod('removeControl', [control.control]);
  }

  Stream on(String type) {
    Function fn;
    var ctrl = new StreamController(onCancel: () {
      _map.callMethod('off', [type, fn]);
    });
    fn = (event) {
      ctrl.add(event);
    };
    _map.callMethod('on', [type, fn]);
    return ctrl.stream;
  }
}
