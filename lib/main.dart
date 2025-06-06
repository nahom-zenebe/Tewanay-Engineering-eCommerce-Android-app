import 'package:flutter/material.dart';
import 'package:mobile_app/pages/landing_page.dart';
import 'package:mobile_app/provider/product_provider.dart';

import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  final productProvider = ProductProvider();
  await productProvider.loadCartFromPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),

      ],
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
      home: LandingPage(),
    );
  }
}
