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
        title: Text('Polygon'),
        actions: [
          TextButton(
            onPressed: context.read<HomeViewModel>().onClear,
            child: Text('Clear Polygons',style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
      body: Stack(
        children: [
          const MapScreen(),
          Positioned(
            left: 10,
            top: 10,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    context.read<HomeViewModel>().addPolygon();
                  },
                  child: Text('Add Polygon',style: TextStyle(color: Colors.blue),),
                ),
                PopupMenuButton(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text('${context.watch<HomeViewModel>().mapType}')),
                  ),
                  itemBuilder: (context) => [MapType.normal,MapType.terrain,MapType.hybrid,MapType.satellite].map((e) => PopupMenuItem(
                    onTap: () => context.read<HomeViewModel>().setMapType(e),
                    child: Text('${e==MapType.normal?'Normal':e==MapType.hybrid?'Hybrid':e==MapType.satellite?'Satellite':'Terrain'}',),
                  ),).toList(),
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: FloatingActionButton(
              onPressed: () {
                context.read<HomeViewModel>().getUserLocation().then((value) async {
                  context.read<HomeViewModel>().setMyLocation(value);
                },);
              },
              child: Icon(Icons.location_disabled),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 100,
            right: 100,
            child: context.watch<HomeViewModel>().userPoints.isNotEmpty
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: context.read<HomeViewModel>().savePolygon,
              child: Text('Save Polygon',style: TextStyle(color: Colors.blue),),
            )
                : Container(),
          ),
        ],
      ),
    );
  }
}
