import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _picked;
  String? _address;
  bool _loadingAddress = false;

  Future<void> _onMapTap(LatLng pos) async {
    setState(() {
      _picked = pos;
      _loadingAddress = true;
      _address = null;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
              "${place.name ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
        });
      } else {
        setState(() => _address = "Unknown location");
      }
    } catch (e) {
      setState(() => _address = "Unable to get address");
    } finally {
      setState(() => _loadingAddress = false);
    }
  }

  void _confirmSelection() {
    if (_picked != null) {
      Get.back(
        result: {
          'lat': _picked!.latitude,
          'lng': _picked!.longitude,
          'address':
              _address ?? '(${_picked!.latitude}, ${_picked!.longitude})',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8859, 45.0792),
              zoom: 5.8,
            ),
            onTap: _onMapTap,
            markers: _picked == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _picked!,
                    ),
                  },
          ),

          if (_picked != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _loadingAddress
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text("Fetching address..."),
                        ],
                      )
                    : Text(
                        _address ?? "Tap to get location",
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _picked == null ? null : _confirmSelection,
        icon: const Icon(Icons.check),
        label: const Text('Confirm'),
      ),
    );
  }
}
