import 'package:flutter/material.dart';
import 'package:oriotv/src/screens/home_screen.dart';
import 'package:oriotv/src/data_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, dynamic> data;
  try {
    data = await loadData();
  } catch (e) {
    print('Error al cargar datos: $e');
    return;
  }

  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> data;

  const MyApp({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrioTV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(data: data),
    );
  }
}
