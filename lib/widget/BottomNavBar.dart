import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ConvexNavWrapper extends StatefulWidget {
  const ConvexNavWrapper({super.key});

  @override
  State<ConvexNavWrapper> createState() => _ConvexNavWrapperState();
}

class _ConvexNavWrapperState extends State<ConvexNavWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Home Page")),
    const Center(child: Text("Favorites")),
    const Center(child: Text("Cart")),
    const Center(child: Text("Saved Items")),
    const Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.white,
        activeColor: Colors.blueAccent,
        color: Colors.grey,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.favorite_border, title: 'Fav'),
          TabItem(icon: Icons.shopping_cart, title: 'Cart'),
          TabItem(icon: Icons.bookmark_border, title: 'Saved'),
          TabItem(icon: Icons.person_outline, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int i) => setState(() => _selectedIndex = i),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add product / quick action
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
