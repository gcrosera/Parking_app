import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class ParkingSpot {
  final String id;
  final String name;
  final LatLng location;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.location,
  });
}

class ParkingSpotsProvider with ChangeNotifier {
  List<ParkingSpot> _spots = [];

  List<ParkingSpot> get spots => _spots;

  void addSpot(ParkingSpot spot) {
    _spots.add(spot);
    notifyListeners();
  }

  void setSpots(List<ParkingSpot> spots) {
    _spots = spots;
    notifyListeners();
  }
}
