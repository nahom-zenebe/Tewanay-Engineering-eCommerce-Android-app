import 'package:flutter/material.dart';
import 'package:mobile_app/cart_page.dart';
import 'package:mobile_app/favorite_page.dart';
import 'package:mobile_app/home_page.dart';
import 'package:mobile_app/profilepage.dart';

class ConvexNavWrapper extends StatefulWidget {
  const ConvexNavWrapper({super.key});

  @override
  State<ConvexNavWrapper> createState() => _ConvexNavWrapperState();
}

class _ConvexNavWrapperState extends State<ConvexNavWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    FavoritePage(),
    CartPage(),
    Profilepage(),
    const Center(child: Text("Profile")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Keeps all items visible
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
