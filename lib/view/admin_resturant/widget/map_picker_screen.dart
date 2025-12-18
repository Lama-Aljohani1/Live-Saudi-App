import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _picked;
  bool _loadingAddress = false;
  String? _addressPreview;

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
            onTap: (pos) async {
              setState(() {
                _picked = pos;
                _addressPreview = null;
              });
              await _fetchAddressPreview(pos);
            },
            markers: _picked == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _picked!,
                    ),
                  },
          ),
          if (_addressPreview != null)
            Positioned(
              left: 16,
              right: 16,
              top: 16,
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _addressPreview!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          if (_loadingAddress) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _picked == null ? null : _confirmAndReturn,
        icon: const Icon(Icons.check),
        label: const Text('Confirm'),
      ),
    );
  }

  Future<void> _fetchAddressPreview(LatLng pos) async {
    setState(() => _loadingAddress = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address =
            '${p.locality ?? p.subAdministrativeArea ?? ''} ${p.administrativeArea ?? ''}'
                .trim();
        setState(() {
          _addressPreview = address.isNotEmpty
              ? address
              : (p.name ?? 'Selected location');
        });
      }
    } catch (_) {
      setState(() => _addressPreview = 'Could not resolve address');
    } finally {
      setState(() => _loadingAddress = false);
    }
  }

  Future<void> _confirmAndReturn() async {
    if (_picked == null) return;
    setState(() => _loadingAddress = true);
    String address = '';
    try {
      final placemarks = await placemarkFromCoordinates(
        _picked!.latitude,
        _picked!.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        address = [
          p.name,
          p.subLocality,
          p.locality,
          p.subAdministrativeArea,
          p.administrativeArea,
          p.country,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
      }
    } catch (_) {}
    setState(() => _loadingAddress = false);

    Get.back(
      result: {
        'lat': _picked!.latitude,
        'lng': _picked!.longitude,
        'address': address,
      },
    );
  }
}
