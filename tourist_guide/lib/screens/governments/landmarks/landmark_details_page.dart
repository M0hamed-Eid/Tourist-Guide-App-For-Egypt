import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/landmark.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_themes.dart';

class LandmarkDetailsPage extends StatefulWidget {
  final Landmark landmark;

  const LandmarkDetailsPage({
    super.key,
    required this.landmark,
  });

  @override
  State<LandmarkDetailsPage> createState() => _LandmarkDetailsPageState();
}

class _LandmarkDetailsPageState extends State<LandmarkDetailsPage> {
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
          snippet: widget.landmark.location,
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetails(),
                _buildMap(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openInGoogleMaps,
        icon: const Icon(Icons.directions),
        label: const Text('Navigate'),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(widget.landmark.name),
        background: widget.landmark.image.image(  // Changed this line
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, size: 20, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                widget.landmark.rating.toString(),
                style: AppTextTheme.textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              const Icon(Icons.location_on, size: 20, color: Colors.blue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.landmark.location,
                  style: AppTextTheme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'About',
            style: AppTextTheme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.landmark.description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
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
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}