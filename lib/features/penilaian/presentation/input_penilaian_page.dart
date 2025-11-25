// features/penilaian/presentation/input_penilaian_page.dart
import 'package:flutter/material.dart';

class InputPenilaianPage extends StatefulWidget {
  const InputPenilaianPage({super.key});

  @override
  State<InputPenilaianPage> createState() => _InputPenilaianPageState();
}

class _InputPenilaianPageState extends State<InputPenilaianPage> {
  int _selectedIndex = 0;
  final List<String> _jenisPenilaian = ['Tahfidz', 'Fiqh', 'Bahasa Arab', 'Akhlak', 'Kehadiran'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Penilaian'),
      ),
      body: Column(
        children: [
          // Jenis Penilaian Selection
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _jenisPenilaian.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _jenisPenilaian[index],
                      style: TextStyle(
                        color: _selectedIndex == index ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Form Input berdasarkan jenis
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildFormByType(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormByType() {
    switch (_selectedIndex) {
      case 0: // Tahfidz
        return _buildTahfidzForm();
      case 1: // Fiqh
        return _buildMapelForm('Fiqh');
      case 2: // Bahasa Arab
        return _buildMapelForm('Bahasa Arab');
      case 3: // Akhlak
        return _buildAkhlakForm();
      case 4: // Kehadiran
        return _buildKehadiranForm();
      default:
        return Container();
    }
  }

  Widget _buildTahfidzForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Input Nilai Tahfidz',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Surah',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Target Ayat (Mingguan)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Ayat Setoran',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Nilai Tajwid (0-100)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Tahfidz berhasil disimpan')),
              );
            },
            child: const Text('SIMPAN NILAI TAHFIDZ'),
          ),
        ),
      ],
    );
  }

  Widget _buildMapelForm(String mapel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Input Nilai $mapel',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Nilai Formatif (0-100)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Nilai Sumatif (0-100)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data $mapel berhasil disimpan')),
              );
            },
            child: Text('SIMPAN NILAI $mapel'),
          ),
        ),
      ],
    );
  }

  Widget _buildAkhlakForm() {
    int disiplin = 3;
    int adab = 3;
    int kebersihan = 3;
    int kerjasama = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Input Nilai Akhlak',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildAkhlakSlider('Disiplin', disiplin, (value) {}),
        _buildAkhlakSlider('Adab pada Guru', adab, (value) {}),
        _buildAkhlakSlider('Kebersihan', kebersihan, (value) {}),
        _buildAkhlakSlider('Kerja Sama', kerjasama, (value) {}),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Catatan',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Akhlak berhasil disimpan')),
              );
            },
            child: const Text('SIMPAN NILAI AKHLAK'),
          ),
        ),
      ],
    );
  }

  Widget _buildAkhlakSlider(String label, int value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: _getAkhlakLabel(value),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Kurang (1)'),
            Text('Cukup (2)'),
            Text('Baik (3)'),
            Text('Sangat Baik (4)'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _getAkhlakLabel(int value) {
    switch (value) {
      case 1: return 'Kurang';
      case 2: return 'Cukup';
      case 3: return 'Baik';
      case 4: return 'Sangat Baik';
      default: return '';
    }
  }

  Widget _buildKehadiranForm() {
    String selectedStatus = 'H';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Input Kehadiran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Tanggal',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Status Kehadiran:'),
        Wrap(
          spacing: 8,
          children: [
            _buildStatusChip('H', 'Hadir', selectedStatus == 'H', () {
              setState(() {
                selectedStatus = 'H';
              });
            }),
            _buildStatusChip('S', 'Sakit', selectedStatus == 'S', () {
              setState(() {
                selectedStatus = 'S';
              });
            }),
            _buildStatusChip('I', 'Izin', selectedStatus == 'I', () {
              setState(() {
                selectedStatus = 'I';
              });
            }),
            _buildStatusChip('A', 'Alpa', selectedStatus == 'A', () {
              setState(() {
                selectedStatus = 'A';
              });
            }),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Kehadiran berhasil disimpan')),
              );
            },
            child: const Text('SIMPAN KEHADIRAN'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String value, String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool selected) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
    );
  }
}
