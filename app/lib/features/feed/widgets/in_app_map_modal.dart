import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppMapModal extends StatefulWidget {
  final String title;
  final String referencePoint;
  final LatLng? initialLocation;

  const InAppMapModal({
    super.key,
    required this.title,
    required this.referencePoint,
    this.initialLocation,
  });

  /// Abre o modal interativo de mapa
  static void show(
    BuildContext context, {
    required String title,
    required String referencePoint,
    LatLng? location,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InAppMapModal(
        title: title,
        referencePoint: referencePoint,
        initialLocation: location,
      ),
    );
  }

  @override
  State<InAppMapModal> createState() => _InAppMapModalState();
}

class _InAppMapModalState extends State<InAppMapModal> {
  late final MapController _mapController;
  late final LatLng _targetCoordinates;
  double _currentZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _targetCoordinates = widget.initialLocation ?? _resolveCoordinates(widget.referencePoint, widget.title);
  }

  /// Gera coordenadas coerentes e fixas baseadas no nome ou referência caso não venham do GPS
  LatLng _resolveCoordinates(String refPoint, String seed) {
    // Ponto central padrão: Polo gastronômico urbano (-23.5505, -46.6333)
    const baseLat = -23.55052;
    const baseLng = -46.63330;

    // Dispersão determinística suave para cada barraca ter um local único no mapa
    final hash = (refPoint + seed).hashCode.abs();
    final latOffset = ((hash % 100) - 50) * 0.00015;
    final lngOffset = (((hash ~/ 100) % 100) - 50) * 0.00015;

    return LatLng(baseLat + latOffset, baseLng + lngOffset);
  }

  Future<void> _openExternalMaps() async {
    final query = widget.referencePoint.isNotEmpty ? widget.referencePoint : widget.title;
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${_targetCoordinates.latitude},${_targetCoordinates.longitude}+(${Uri.encodeComponent(query)})',
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o Google Maps: $e')),
        );
      }
    }
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(3.0, 19.0);
      _mapController.move(_targetCoordinates, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(3.0, 19.0);
      _mapController.move(_targetCoordinates, _currentZoom);
    });
  }

  void _recenter() {
    _mapController.move(_targetCoordinates, 16.0);
    setState(() => _currentZoom = 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Barra de arraste
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Cabeçalho do Mapa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.referencePoint.isNotEmpty ? widget.referencePoint : 'Ponto comercial ambulante',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Área do Mapa Interativo
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _targetCoordinates,
                    initialZoom: _currentZoom,
                    minZoom: 4.0,
                    maxZoom: 19.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.pegabode.pa2.pa2',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _targetCoordinates,
                          width: 80,
                          height: 80,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                                ),
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.location_on,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Controles Flutuantes de Zoom e Recentralizar
                Positioned(
                  right: 16,
                  bottom: 24,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'map_recenter',
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        onPressed: _recenter,
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'map_zoom_in',
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        onPressed: _zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'map_zoom_out',
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        onPressed: _zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),

                // Card Informativo Superior
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.touch_app_outlined, size: 18, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Arraste com os dedos ou use os botões para explorar o mapa.',
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rodapé com Ações
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _openExternalMaps,
                      icon: const Icon(Icons.directions, color: Colors.white),
                      label: const Text('Rota no Google Maps', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
