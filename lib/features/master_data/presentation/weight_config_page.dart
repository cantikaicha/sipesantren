import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // New import
import 'package:sipesantren/core/models/weight_config_model.dart';
import 'package:sipesantren/core/repositories/weight_config_repository.dart';

class WeightConfigPage extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  const WeightConfigPage({super.key});

  @override
  ConsumerState<WeightConfigPage> createState() => _WeightConfigPageState(); // Changed to ConsumerState
}

class _WeightConfigPageState extends ConsumerState<WeightConfigPage> { // Changed to ConsumerState
  // Removed direct instantiation, now obtained from provider
  final _formKey = GlobalKey<FormState>();

  final _tahfidzController = TextEditingController();
  final _fiqhController = TextEditingController();
  final _bahasaArabController = TextEditingController();
  final _akhlakController = TextEditingController();
  final _kehadiranController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  @override
  void dispose() {
    _tahfidzController.dispose();
    _fiqhController.dispose();
    _bahasaArabController.dispose();
    _akhlakController.dispose();
    _kehadiranController.dispose();
    super.dispose();
  }

  Future<void> _loadWeights() async {
    final _repository = ref.read(weightConfigRepositoryProvider); // Get from provider
    // Ensure default weights exist if not already in Firestore
    await _repository.initializeWeightConfig();

    _repository.getWeightConfig().listen((config) {
      setState(() {
        _tahfidzController.text = (config.tahfidz * 100).toStringAsFixed(0);
        _fiqhController.text = (config.fiqh * 100).toStringAsFixed(0);
        _bahasaArabController.text = (config.bahasaArab * 100).toStringAsFixed(0);
        _akhlakController.text = (config.akhlak * 100).toStringAsFixed(0);
        _kehadiranController.text = (config.kehadiran * 100).toStringAsFixed(0);
        _isLoading = false;
      });
    });
  }

  Future<void> _saveWeights() async {
    final _repository = ref.read(weightConfigRepositoryProvider); // Get from provider
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newConfig = WeightConfigModel(
          id: 'grading_weights', // Fixed ID
          tahfidz: (double.tryParse(_tahfidzController.text) ?? 0) / 100,
          fiqh: (double.tryParse(_fiqhController.text) ?? 0) / 100,
          bahasaArab: (double.tryParse(_bahasaArabController.text) ?? 0) / 100,
          akhlak: (double.tryParse(_akhlakController.text) ?? 0) / 100,
          kehadiran: (double.tryParse(_kehadiranController.text) ?? 0) / 100,
        );
        await _repository.updateWeightConfig(newConfig);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bobot penilaian berhasil diperbarui')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui bobot: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bobot tidak boleh kosong';
    }
    final double? weight = double.tryParse(value);
    if (weight == null || weight < 0 || weight > 100) {
      return 'Masukkan angka antara 0-100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bobot Penilaian')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bobot Penilaian'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Atur Bobot Penilaian (dalam persen)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildWeightInputField('Tahfidz', _tahfidzController),
              _buildWeightInputField('Fiqh', _fiqhController),
              _buildWeightInputField('Bahasa Arab', _bahasaArabController),
              _buildWeightInputField('Akhlak', _akhlakController),
              _buildWeightInputField('Kehadiran', _kehadiranController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveWeights,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text('SIMPAN BOBOT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: '$label (%)',
          border: const OutlineInputBorder(),
        ),
        validator: _weightValidator,
      ),
    );
  }
}
