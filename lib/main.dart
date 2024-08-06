import 'package:flutter/material.dart';
import 'package:my_map/ui/home/presentation/home_screen.dart';
import 'package:my_map/ui/home/provider/home_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(create: (context) => HomeViewModel(),)
      ],
      child: MaterialApp(
        title: 'My Map',
        debugShowCheckedModeBanner: false,
        home:HomeScreen(),
      ),
    );
  }
}
