import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sipesantren/core/models/mapel_model.dart';
import 'package:sipesantren/core/models/santri_model.dart';
import 'package:sipesantren/core/models/penilaian_model.dart';
import 'package:sipesantren/core/repositories/santri_repository.dart';
import 'package:sipesantren/core/repositories/penilaian_repository.dart';

class KelasDetailPage extends ConsumerStatefulWidget {
  final MapelModel mapel;

  const KelasDetailPage({super.key, required this.mapel});

  @override
  ConsumerState<KelasDetailPage> createState() => _KelasDetailPageState();
}

class _KelasDetailPageState extends ConsumerState<KelasDetailPage> {
  DateTime _selectedDate = DateTime.now();
  List<SantriModel> _santris = [];
  bool _isLoading = true;

  // State for inputs
  final Map<String, String> _attendanceMap = {}; // santriId -> H/S/I/A
  final Map<String, TextEditingController> _formatifControllers = {};
  final Map<String, TextEditingController> _sumatifControllers = {};

  @override
  void initState() {
    super.initState();
    _loadSantris();
  }

  Future<void> _loadSantris() async {
    setState(() => _isLoading = true);
    final santriRepo = ref.read(santriRepositoryProvider);
    final list = await santriRepo.getSantriList();
    
    if (mounted) {
      setState(() {
        _santris = list;
        // Initialize controllers
        for (var s in _santris) {
          _attendanceMap[s.id] = 'H'; // Default present
          _formatifControllers[s.id] = TextEditingController();
          _sumatifControllers[s.id] = TextEditingController();
        }
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var c in _formatifControllers.values) c.dispose();
    for (var c in _sumatifControllers.values) c.dispose();
    super.dispose();
  }

  Future<void> _saveBatch() async {
    setState(() => _isLoading = true);
    final penilaianRepo = ref.read(penilaianRepositoryProvider);

    try {
      for (var santri in _santris) {
        // Save Attendance
        final status = _attendanceMap[santri.id] ?? 'H';
        await penilaianRepo.addKehadiran(Kehadiran(
          id: '',
          santriId: santri.id,
          tanggal: _selectedDate,
          status: status,
        ));

        // Save Score if entered
        final formatifText = _formatifControllers[santri.id]?.text ?? '';
        final sumatifText = _sumatifControllers[santri.id]?.text ?? '';

        if (formatifText.isNotEmpty || sumatifText.isNotEmpty) {
          final formatif = int.tryParse(formatifText) ?? 0;
          final sumatif = int.tryParse(sumatifText) ?? 0;
          
          await penilaianRepo.addPenilaianMapel(PenilaianMapel(
            id: '',
            santriId: santri.id,
            mapel: widget.mapel.name,
            formatif: formatif,
            sumatif: sumatif,
          ));
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelas ${widget.mapel.name}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveBatch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Picker
          ListTile(
            title: Text(DateFormat('EEEE, d MMMM yyyy').format(_selectedDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
          const Divider(),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text('Santri', style: TextStyle(fontWeight: FontWeight.bold))),
                const Expanded(flex: 2, child: Text('Hadir', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                if (MediaQuery.of(context).size.width > 600) ...[
                   const Expanded(flex: 2, child: Text('Formatif', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                   const Expanded(flex: 2, child: Text('Sumatif', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                ]
              ],
            ),
          ),

          // List
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _santris.length,
                  itemBuilder: (context, index) {
                    final santri = _santris[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ExpansionTile(
                        title: Text(santri.nama),
                        subtitle: Text(santri.nis),
                        leading: CircleAvatar(child: Text(santri.nama[0])),
                        trailing: DropdownButton<String>(
                          value: _attendanceMap[santri.id],
                          items: ['H', 'S', 'I', 'A'].map((s) => DropdownMenuItem(
                            value: s, 
                            child: Text(s, style: TextStyle(
                              color: s == 'H' ? Colors.green : (s == 'A' ? Colors.red : Colors.orange)
                            ))
                          )).toList(),
                          onChanged: (val) {
                            setState(() {
                              _attendanceMap[santri.id] = val!;
                            });
                          },
                          underline: Container(),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _formatifControllers[santri.id],
                                    decoration: const InputDecoration(labelText: 'Nilai Formatif', border: OutlineInputBorder()),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _sumatifControllers[santri.id],
                                    decoration: const InputDecoration(labelText: 'Nilai Sumatif', border: OutlineInputBorder()),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
