import 'package:flutter/material.dart';
import 'package:yadunandanks_harivara/harivara_app.dart/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harivara',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return const HarivaraApp();
                      },
                    ),
                  );
                },
                child: const Text("Start")),
          ),
          appBar: AppBar(
            title: const Text("yadunandan_KS_Harivar"),
          ),
        );
      }),
    );
  }
}
