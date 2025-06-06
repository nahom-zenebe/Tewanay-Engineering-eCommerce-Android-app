import 'package:flutter/material.dart';
import 'package:mobile_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<String, int> _quantities = {}; 
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final cartItems = provider.cartProducts;

  
    for (var item in cartItems) {
      _quantities[item.title] ??= 1;
    }

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * _quantities[item.title]!),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.deepPurple,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty', style: TextStyle(fontSize: 18)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(item.image),
                        ),
                        title: Text(item.title,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${item.price.toStringAsFixed(2)} x ${_quantities[item.title]}',
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    if (_quantities[item.title]! > 1) {
                                      setState(() => _quantities[item.title] =
                                          _quantities[item.title]! - 1);
                                    }
                                  },
                                ),
                                Text('${_quantities[item.title]}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() => _quantities[item.title] =
                                        _quantities[item.title]! + 1);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => provider.removeFromCart(item),
                        ),
                      );
                    },
                  ),
                ),
                _buildCartSummary(context, total, provider),
              ],
            ),
    );
  }

  Widget _buildCartSummary(
      BuildContext context, double total, ProductProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              if (provider.cartProducts.isEmpty) return;
              provider.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout successful!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.payment),
            label: const Text('Checkout'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
