import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  bool loading = false;
  String error = "";

  void submit() async {
    String name = nameController.text.trim();
    double? price = double.tryParse(priceController.text.trim());

    if (name.isEmpty) {
      setState(() => error = "Enter product name");
      return;
    }

    if (price == null || price <= 0) {
      setState(() => error = "Enter valid price");
      return;
    }

    setState(() => loading = true);

    final res = await ApiService.addProduct(name, price);

    setState(() => loading = false);

    if (res["success"]) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res["message"])));

      Navigator.pop(context);
    } else {
      setState(() => error = res["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name", border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),),
              ),
            ),
            const SizedBox(height: 20),
            if (loading)
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 10),

            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text("Submit"),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}