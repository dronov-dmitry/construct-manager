import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../data/services/construction_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

// ---------------------------------------------------------------------------
// ПОЧЕМУ УБРАН пакет geocoding:
//   geocoding 4.0.0 поддерживает только Android и iOS.
//   На Windows GeocodingPlatform.instance == null, и вызов
//   locationFromAddress() сразу бросает:
//     "Null check operator used on a null value"
//   из geocoding.dart строка 16: GeocodingPlatform.instance!.locationFromAddress(...)
//
// ЗАМЕНА:
//   Используем Nominatim — бесплатный geocoding API от OpenStreetMap.
//   Тот же источник данных, что и тайлы карты. Работает на всех платформах
//   через обычный HTTP-запрос (пакет http уже есть в pubspec.yaml).
// ---------------------------------------------------------------------------

/// Геокодирует адрес через Nominatim (OpenStreetMap).
/// Возвращает [LatLng] или null если адрес не найден или сеть недоступна.
/// Бросает исключение только при сетевой/парсинг ошибке.
Future<LatLng?> _geocodeAddress(String address) async {
  final uri = Uri.https(
    'nominatim.openstreetmap.org',
    '/search',
    {
      'q': address,
      'format': 'json',
      'limit': '1',
    },
  );

  final response = await http.get(
    uri,
    headers: {
      // Nominatim требует User-Agent, иначе может заблокировать запросы.
      'User-Agent': 'ConstructManager/1.0 (contact: support@heron.com)',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Nominatim вернул статус ${response.statusCode}');
  }

  final List<dynamic> results = jsonDecode(response.body) as List<dynamic>;
  if (results.isEmpty) return null;

  final first = results.first as Map<String, dynamic>;
  final lat = double.tryParse(first['lat'] as String? ?? '');
  final lon = double.tryParse(first['lon'] as String? ?? '');

  if (lat == null || lon == null) return null;
  return LatLng(lat, lon);
}

// ---------------------------------------------------------------------------

class MapScreen extends StatefulWidget {
  final String constructionUid;

  const MapScreen({super.key, required this.constructionUid});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchController = TextEditingController();
  final _service = ConstructionService();

  // MapController получаем через _MapReadyLayer (см. ниже).
  // До монтирования FlutterMap это поле null.
  // В flutter_map 7 использование контроллера до монтирования бросает ошибку.
  MapController? _mapController;

  // Позиция маркера на карте. null — маркер не отображается.
  LatLng? _position;

  // Если geocoding отработал до того, как карта смонтировалась,
  // сохраняем цель здесь и двигаем камеру в _MapReadyLayer.onReady.
  LatLng? _pendingMoveTarget;

  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadMapAddress();
  }

  // Загружает сохранённый адрес из БД и геокодирует его.
  // Пока _isLoading == true, FlutterMap не в дереве → двигать камеру нельзя.
  Future<void> _loadMapAddress() async {
    try {
      final c = await _service.getConstruction(widget.constructionUid);
      if (c != null && c.mapAddress.isNotEmpty) {
        _searchController.text = c.mapAddress;
        // moveMap: false — только ставим маркер, камеру не трогаем.
        // Карта ещё не смонтирована в этот момент.
        await _searchAddress(c.mapAddress, moveMap: false);
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Геокодирует адрес через Nominatim и обновляет маркер/камеру.
  Future<void> _searchAddress(String address, {bool moveMap = true}) async {
    if (address.trim().isEmpty) return;
    if (!mounted) return;

    setState(() => _isSearching = true);
    try {
      final latLng = await _geocodeAddress(address);
      if (!mounted) return;

      if (latLng != null) {
        setState(() => _position = latLng);

        if (moveMap) {
          if (_mapController != null) {
            // Карта уже смонтирована — двигаем сразу.
            _mapController!.move(latLng, 15);
          } else {
            // Карта ещё не смонтирована — откладываем до onReady.
            _pendingMoveTarget = latLng;
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.address_not_found)),
          );
        }
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // Сохраняет адрес в БД и обновляет маркер.
  Future<void> _saveAddress() async {
    final address = _searchController.text.trim();
    if (address.isEmpty) return;

    setState(() => _isSearching = true);
    try {
      await _service.updateMapAddress(widget.constructionUid, address);
      if (!mounted) return;
      await _searchAddress(address);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.address_saved)),
        );
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController = null;
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
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) => _searchAddress(value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: _isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        onPressed: _isSearching ? null : _saveAddress,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _position ?? const LatLng(55.7558, 37.6173),
                      initialZoom: _position != null ? 15 : 10,
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
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      // Невидимый слой внутри FlutterMap для безопасного
                      // получения MapController после монтирования карты.
                      _MapReadyLayer(
                        onReady: (controller) {
                          _mapController = controller;
                          final target = _pendingMoveTarget;
                          if (target != null) {
                            _pendingMoveTarget = null;
                            controller.move(target, 15);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// Вспомогательный слой без визуального содержимого.
// Живёт внутри дерева FlutterMap — только отсюда можно безопасно
// получить MapController через MapController.of(context) в flutter_map 7.
class _MapReadyLayer extends StatefulWidget {
  const _MapReadyLayer({required this.onReady});
  final void Function(MapController controller) onReady;

  @override
  State<_MapReadyLayer> createState() => _MapReadyLayerState();
}

class _MapReadyLayerState extends State<_MapReadyLayer> {
  bool _notified = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_notified) {
      _notified = true;
      final controller = MapController.of(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onReady(controller);
      });
    }
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
