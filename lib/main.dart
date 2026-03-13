import 'package:flutter/material.dart';
import 'core/storage/hive_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Movie Browser Setup Complete')),
      ),
    );
  }
}
