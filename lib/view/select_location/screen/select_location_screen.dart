// lib/view/admin_manage_heritage/widget/map_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});
  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _picked;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick location')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(23.8859, 45.0792), zoom: 5.8),
        onTap: (pos) => setState(() => _picked = pos),
        markers: _picked == null ? {} : { Marker(markerId: const MarkerId('picked'), position: _picked!) },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _picked == null ? null : () => Get.back(result: _picked),
        icon: const Icon(Icons.check),
        label: const Text('Confirm'),
      ),
    );
  }
}
