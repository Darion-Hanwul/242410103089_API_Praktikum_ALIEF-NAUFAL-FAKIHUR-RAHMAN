import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _githubController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final task = SubmitTask(
      name: _nameController.text,
      price: int.parse(_priceController.text),
      description: _descController.text.isEmpty ? 'Dikirim dari aplikasi Flutter' : _descController.text,
      githubUrl: _githubController.text,
    );

    final success = await _apiService.submitTask(task);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Tugas berhasil disubmit!')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Gagal mengirim tugas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Tugas'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Produk', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Harga', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _githubController, decoration: const InputDecoration(labelText: 'Link Repository GitHub', border: OutlineInputBorder())),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: _isSubmitting ? const CircularProgressIndicator() : const Text('Submit Tugas', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}