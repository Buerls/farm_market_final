// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../controllers/order_controller.dart';
import '../controllers/auth_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final OrderController orderController = Get.put(OrderController());
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController quantityController =
      TextEditingController(text: "1");

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              product.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '\$${product.price}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 20),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  int quantity = int.parse(quantityController.text);
                  double totalPrice = quantity * product.price;
                  OrderModel newOrder = OrderModel(
                    id: '',
                    productId: product.id,
                    farmerId: product.farmerId,
                    customerId: authController.userId.value,
                    quantity: quantity,
                    totalPrice: totalPrice,
                    shippingAddress:
                        '123 Customer Address', // Kullanıcı adresini buradan alabilirsiniz
                    customerPoint: -1,
                    orderStatus: OrderStatus.pending,
                  );
                  orderController.placeOrder(newOrder);
                },
                child: Text('Order Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
