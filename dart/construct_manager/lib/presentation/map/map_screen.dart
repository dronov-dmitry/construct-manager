import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/services/construction_service.dart';
import '../../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  final String constructionUid;

  const MapScreen({super.key, required this.constructionUid});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchController = TextEditingController();
  final _service = ConstructionService();
  LatLng? _position;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMapAddress();
  }

  Future<void> _loadMapAddress() async {
    try {
      final c = await _service.getConstruction(widget.constructionUid);
      if (c != null && c.mapAddress.isNotEmpty) {
        _searchController.text = c.mapAddress;
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveAddress() async {
    try {
      await _service.updateMapAddress(
        widget.constructionUid,
        _searchController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.map)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: s.search_address,
                            prefixIcon: const Icon(Icons.search),
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: _saveAddress,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _position ?? const LatLng(55.7558, 37.6173),
                      initialZoom: 10,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.heron.construct_manager',
                      ),
                      if (_position != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _position!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
