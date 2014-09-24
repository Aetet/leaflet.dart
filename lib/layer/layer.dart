library leaflet.layer;

import 'dart:html' show Element, CanvasElement, ImageElement, Event;
import 'dart:html' as html;
import 'dart:math' as math show min, max;
import 'dart:async' show Stream, StreamController, StreamSubscription;

import 'package:simple_features/simple_features.dart' as sfs;

import '../core/core.dart' show EventType, Browser, Action, stamp, Events, MapEvent, LayerEvent, ZoomEvent, PopupEvent, MouseEvent;
import '../dom/dom.dart' as dom;
import '../map/map.dart';
import '../geo/geo.dart';
import '../geometry/geometry.dart' show Point2D;
import './marker/marker.dart';
import './tile/tile.dart' show TileLayer;
import './vector/vector.dart' show Polygon, PathOptions, Polyline, MultiPolyline, MultiPolygon, Path;

part 'feature_group.dart';
part 'geo_json.dart';
part 'image_overlay.dart';
part 'layer_group.dart';
part 'popup.dart';

/**
 * Represents an object attached to a particular location (or a set of
 * locations) on a map.
 */
abstract class Layer {
  /**
   * Should contain code that creates DOM elements for the overlay, adds them
   * to map panes where they should belong and puts listeners on relevant map
   * events. Called on map.addLayer(layer).
   */
  onAdd(LeafletMap map);

  /**
   * Should contain all clean up code that removes the overlay's elements from
   * the DOM and removes listeners previously added in onAdd. Called on
   * map.removeLayer(layer).
   */
  onRemove(LeafletMap map);

  String getAttribution() {
    return null;
  }

  void setZIndex(int idx) {}
}
