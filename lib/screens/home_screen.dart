// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/farmer_controller.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final FarmerController farmerController = Get.put(FarmerController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                String query = searchController.text;
                productController.searchProducts(query);
                farmerController.searchFarmers(query);
              },
              decoration: InputDecoration(
                labelText: 'Search for products or farmers',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String query = searchController.text;
                    productController.searchProducts(query);
                    farmerController.searchFarmers(query);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (productController.searchResults.isEmpty &&
                    farmerController.searchResults.isEmpty) {
                  return Center(child: Text('No results found.'));
                } else {
                  return ListView(
                    children: [
                      ...productController.searchResults
                          .map((product) => ListTile(
                                title: Text(product.name),
                                subtitle: Text(product.description),
                                onTap: () {
                                  Get.to(() =>
                                      ProductDetailScreen(product: product));
                                },
                              )),
                      ...farmerController.searchResults
                          .map((farmer) => ListTile(
                                title: Text(farmer.name),
                                subtitle: Text(farmer.shopName),
                              )),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
