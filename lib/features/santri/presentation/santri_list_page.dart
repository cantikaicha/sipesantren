// features/santri/presentation/santri_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipesantren/features/penilaian/presentation/input_penilaian_page.dart';
import 'package:sipesantren/features/rapor/presentation/rapor_page.dart';

class Santri {
  final String id;
  final String nis;
  final String nama;
  final String kamar;
  final int angkatan;
  final String statusSinkron;

  Santri({
    required this.id,
    required this.nis,
    required this.nama,
    required this.kamar,
    required this.angkatan,
    required this.statusSinkron,
  });
}

class SantriListPage extends ConsumerStatefulWidget {
  const SantriListPage({super.key});

  @override
  ConsumerState<SantriListPage> createState() => _SantriListPageState();
}

class _SantriListPageState extends ConsumerState<SantriListPage> {
  final List<Santri> _santriList = [
    Santri(id: 's1', nis: '2025-001', nama: 'Ahmad Fauzi', kamar: 'A3', angkatan: 2023, statusSinkron: 'Tersinkron'),
    Santri(id: 's2', nis: '2025-002', nama: 'Bilal Syahid', kamar: 'B1', angkatan: 2022, statusSinkron: 'Belum Sinkron'),
    Santri(id: 's3', nis: '2025-003', nama: 'Chandra Wijaya', kamar: 'A3', angkatan: 2023, statusSinkron: 'Tersinkron'),
    Santri(id: 's4', nis: '2025-004', nama: 'Daffa Rahman', kamar: 'C2', angkatan: 2022, statusSinkron: 'Tersinkron'),
  ];

  String _selectedKamar = 'Semua';
  String _selectedAngkatan = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Santri'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              _showSyncDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _showAddSantriDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari santri...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),

                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedKamar,
                            items: const [
                              DropdownMenuItem(value: 'Semua', child: Text('Semua Kamar')),
                              DropdownMenuItem(value: 'A3', child: Text('Kamar A3')),
                              DropdownMenuItem(value: 'B1', child: Text('Kamar B1')),
                              DropdownMenuItem(value: 'C2', child: Text('Kamar C2')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedKamar = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedAngkatan,
                            items: const [
                              DropdownMenuItem(value: 'Semua', child: Text('Semua Angkatan')),
                              DropdownMenuItem(value: '2023', child: Text('2023')),
                              DropdownMenuItem(value: '2022', child: Text('2022')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedAngkatan = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Santri List
          Expanded(
            child: ListView.builder(
              itemCount: _santriList.length,
              itemBuilder: (context, index) {
                final santri = _santriList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person, color: Colors.blue),
                    ),
                    title: Text(santri.nama),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIS: ${santri.nis} | Kamar: ${santri.kamar}'),
                        Row(
                          children: [
                            Icon(
                              santri.statusSinkron == 'Tersinkron'
                                ? Icons.cloud_done
                                : Icons.cloud_off,
                              size: 14,
                              color: santri.statusSinkron == 'Tersinkron'
                                ? Colors.green
                                : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              santri.statusSinkron,
                              style: TextStyle(
                                color: santri.statusSinkron == 'Tersinkron'
                                  ? Colors.green
                                  : Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SantriDetailPage(santri: santri),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sinkronisasi Data'),
        content: const Text('Data akan disinkronkan dengan server. Pastikan koneksi internet tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sinkronisasi berhasil!')),
              );
            },
            child: const Text('SINKRON'),
          ),
        ],
      ),
    );
  }

  void _showAddSantriDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Santri Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'NIS')),
            TextField(decoration: const InputDecoration(labelText: 'Nama')),
            TextField(decoration: const InputDecoration(labelText: 'Kamar')),
            TextField(decoration: const InputDecoration(labelText: 'Angkatan')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Santri berhasil ditambahkan')),
              );
            },
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}

class SantriDetailPage extends StatelessWidget {
  final Santri santri;

  const SantriDetailPage({super.key, required this.santri});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(santri.nama),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Penilaian'),
              Tab(text: 'Kehadiran'),
              Tab(text: 'Grafik'),
              Tab(text: 'Rapor'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Penilaian
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildNilaiCard('Tahfidz', '93', Colors.green, Icons.book),
                  _buildNilaiCard('Fiqh', '86', Colors.blue, Icons.balance),
                  _buildNilaiCard('Bahasa Arab', '78', Colors.orange, Icons.language),
                  _buildNilaiCard('Akhlak', '94', Colors.purple, Icons.emoji_people),
                  _buildNilaiCard('Kehadiran', '90', Colors.red, Icons.calendar_today),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InputPenilaianPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Input Penilaian Baru'),
                  ),
                ],
              ),
            ),

            // Tab Kehadiran
            const Center(child: Text('Data Kehadiran akan ditampilkan di sini')),

            // Tab Grafik
            const Center(child: Text('Grafik perkembangan Tahfidz')),

            // Tab Rapor
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'RAPOR SANTRI',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildRaporItem('Nilai Akhir', '89'),
                          _buildRaporItem('Predikat', 'A'),
                          _buildRaporItem('Peringkat', '5 dari 40'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RaporPage(),
                                ),
                              );
                            },
                            child: const Text('Lihat Rapor Lengkap'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNilaiCard(String mataPelajaran, String nilai, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(mataPelajaran),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            nilai,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRaporItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
