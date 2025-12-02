import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../location/view/widgets/maps/flutter_location_map.dart';

class PostDetailPropertyLocationLocationWidget extends StatefulWidget {
  const PostDetailPropertyLocationLocationWidget({
    required this.location, super.key,
  });
  final LocationEntity? location;

  @override
  State<PostDetailPropertyLocationLocationWidget> createState() =>
      _PostDetailPropertyLocationLocationWidgetState();
}

class _PostDetailPropertyLocationLocationWidgetState
    extends State<PostDetailPropertyLocationLocationWidget> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.location == null) return const SizedBox.shrink();
    final LatLng position =
        LatLng(widget.location!.latitude, widget.location!.longitude);

    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(
          widget.location!.url ?? 'https://www.google.com/maps',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        height: 200,
        child: FlutterLocationMap(
          mapController: _mapController,
          selectedLatLng: position,
          showMapCircle: false,
        ),
      ),
    );
  }
}
