import 'package:flutter/material.dart';
import 'package:mobile_app/pages/cart_page.dart';
import 'package:mobile_app/pages/detail_page.dart';
import 'package:mobile_app/model/product_model.dart.dart';
import 'package:mobile_app/pages/favorite_page.dart';
import 'package:mobile_app/pages/landing_page.dart';
import 'package:mobile_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadAllProducts();
    });

    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    List<ProductModel> filtered = products;

    // Apply search filter
    if (_searchTerm.isNotEmpty) {
      filtered = filtered
          .where((p) => p.title.toLowerCase().contains(_searchTerm))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    return filtered;
  }

  List<String> _getAllCategories(List<ProductModel> products) {
    // Extract unique categories from products
    final categories = products.map((p) => p.category).toSet().toList();
    // Add "All" option at the beginning
    return ['All'] + categories;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<ProductProvider>(context);
    final filteredProducts = _filterProducts(provider.allProducts);
    final categories = _getAllCategories(provider.allProducts);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'ShopNest',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      drawer: _buildDrawer(theme),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _buildSearchField(theme),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category ||
                    (category == 'All' && _selectedCategory == null);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected
                            ? (category == 'All' ? null : category)
                            : null;
                      });
                    },
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Product Grid
          Expanded(
            child: _buildProductGrid(provider, filteredProducts, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(ThemeData theme) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Code Slayer'),
            accountEmail: const Text('slayer@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/583231?v=4'),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
          ),

          // Menu Items
          ListTile(
            leading: Icon(Icons.home, color: theme.colorScheme.primary),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: theme.colorScheme.primary),
            title: Text('Favorites'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),
          ListTile(
            leading:
                Icon(Icons.shopping_cart, color: theme.colorScheme.primary),
            title: Text('My Cart'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),

          const Spacer(),

          // Divider + Logout
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider provider,
      List<ProductModel> filteredProducts, ThemeData theme) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          provider.error!,
        ),
      );
    }

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No matching products found',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product, theme);
      },
    );
  }

  Widget _buildProductCard(ProductModel product, ThemeData theme) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final isFav = provider.isFavorite(product);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(productModel: product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: Colors.black12,
       child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    
    Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: () => provider.toggleFavorite(product),
          ),
        ),
      ],
    ),

   
   Flexible(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 1),

            // Rating
            Row(
              children: [
                _buildStarRating(product.rate, theme),
                const SizedBox(width: 4),
                Text(
                  '(${product.count})',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),

            
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),


    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          provider.addToCart(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to cart'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text("Add to Cart"),
      ),
    ),
  ],
),

      ),
    );
  }

  Widget _buildStarRating(double rating, ThemeData theme) {

    final roundedRating = (rating * 2).round() / 2;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (roundedRating - index >= 1) {
    
          return Icon(Icons.star, size: 16, color: Colors.amberAccent);
        } else if (roundedRating - index > 0) {
       
          return Icon(Icons.star_half,
              size: 16, color: theme.colorScheme.secondary);
        } else {
 
          return Icon(Icons.star_border,
              size: 16, color: theme.colorScheme.secondary);
        }
      }),
    );
  }
}
