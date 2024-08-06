import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/home_view_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: context.watch<HomeViewModel>().mapType,
      initialCameraPosition: context.watch<HomeViewModel>().bukhara,
      markers: context.watch<HomeViewModel>().markers,
      polygons: context.watch<HomeViewModel>().polygons,
      onTap: (LatLng point) {
        context.read<HomeViewModel>().clickMap(point);//
      },
      onMapCreated: (GoogleMapController ctn) {
        context.read<HomeViewModel>().controller.complete(ctn);
      },
    );
  }
}
