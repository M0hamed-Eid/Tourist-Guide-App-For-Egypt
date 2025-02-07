import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/landmark.dart';

class LandmarkCard extends StatefulWidget {
  final Landmark landmark;

  const LandmarkCard({
    super.key,
    required this.landmark,
  });

  @override
  State<LandmarkCard> createState() => _LandmarkCardState();
}

class _LandmarkCardState extends State<LandmarkCard> {
  late GoogleMapController _mapController;
  late final Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = {
      Marker(
        markerId: MarkerId(widget.landmark.id),
        position: LatLng(
          widget.landmark.latitude,
          widget.landmark.longitude,
        ),
        infoWindow: InfoWindow(
          title: widget.landmark.name,
          snippet: widget.landmark.governorate,
        ),
      ),
    };
  }

  Future<void> _openInGoogleMaps() async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.landmark.latitude},${widget.landmark.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: widget.landmark.image.image(
              fit: BoxFit.cover,
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.landmark.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.landmark.governorate,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _openInGoogleMaps,
                      icon: const Icon(Icons.directions),
                      tooltip: 'Get directions',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.landmark.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Map
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.landmark.latitude,
                    widget.landmark.longitude,
                  ),
                  zoom: 15,
                ),
                markers: _markers,
                onMapCreated: (controller) => _mapController = controller,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onTap: (_) => _openInGoogleMaps(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}