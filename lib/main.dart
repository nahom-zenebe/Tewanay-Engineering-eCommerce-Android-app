import 'package:flutter/material.dart';
import 'package:mobile_app/landing_page.dart';
import 'package:mobile_app/product_provider.dart';
import 'package:mobile_app/widget/BottomNavBar.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
     home: ConvexNavWrapper(),
    );
  }
}
