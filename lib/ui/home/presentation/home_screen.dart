import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_map/ui/home/provider/home_view_model.dart';
import 'package:my_map/ui/map/map_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polygon'),
        actions: [
          context.watch<HomeViewModel>().userPoints.isNotEmpty?
          TextButton(
            onPressed: context.read<HomeViewModel>().savePolygon,
            child: const Text('Save Polygon',style: TextStyle(color: Colors.blue),),
          ):
          const SizedBox.shrink(),
          TextButton(
            onPressed: context.read<HomeViewModel>().onClear,
            child: const Text('Clear Polygons',style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
      body: const MapScreen(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                context.read<HomeViewModel>().addPolygon();
              },
              child: const Text('Add Polygon',style: TextStyle(color: Colors.blue),),
            ),
            PopupMenuButton(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1,0)
                    )
                  ]
                ),
                child: Center(child: Text('${context.watch<HomeViewModel>().mapType}')),
              ),
              itemBuilder: (context) => [MapType.normal,MapType.terrain,MapType.hybrid,MapType.satellite].map((e) => PopupMenuItem(
                onTap: () => context.read<HomeViewModel>().setMapType(e),
                child: Text(e==MapType.normal?'Normal':e==MapType.hybrid?'Hybrid':e==MapType.satellite?'Satellite':'Terrain',),
              ),).toList(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                context.read<HomeViewModel>().getUserLocation().then((value) async {
                  context.read<HomeViewModel>().setMyLocation(value);
                },);
              },
              child: const Text('Me',style: TextStyle(color: Colors.blue),),
            ),
          ],
        ),
      ),
    );
  }
}
