import 'package:flutter/material.dart';
import 'package:my_camera_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Camera Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
