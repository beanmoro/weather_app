import 'package:flutter/material.dart';

abstract class GeolocationService {
  Future<int> handleLocationPermission();
}
