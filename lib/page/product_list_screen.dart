import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import 'submit_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _apiService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
    }
  }

  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Produk Draft'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Produk')),
            const SizedBox(height: 8),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Deskripsi')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final product = Product(
                name: nameController.text,
                price: int.parse(priceController.text),
                description: descController.text,
              );
              await _apiService.createProduct(product);
              Navigator.pop(context, true);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result == true) {
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Produk berhasil ditambahkan!')),
      );
    }
  }

  Future<void> _deleteProduct(Product product) async {
    if (product.id != null) {
      await _apiService.deleteProduct(product.id!);
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🗑️ Produk telah dihapus (soft delete)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmitScreen())),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('Belum ada produk draft. Tekan tombol + untuk menambah'))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.inventory),
                        title: Text(product.name),
                        subtitle: Text('Rp ${product.price} - ${product.description}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}