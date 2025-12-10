import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipesantren/core/models/mapel_model.dart';
import 'package:sipesantren/core/repositories/mapel_repository.dart';
import 'package:sipesantren/features/master_data/presentation/mapel_form_page.dart';

class MapelListPage extends ConsumerStatefulWidget {
  const MapelListPage({super.key});

  @override
  ConsumerState<MapelListPage> createState() => _MapelListPageState();
}

class _MapelListPageState extends ConsumerState<MapelListPage> {
  List<MapelModel> _mapelList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(mapelRepositoryProvider);
      final list = await repository.getMapelList();
      if (mounted) {
        setState(() {
          _mapelList = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _repository = ref.read(mapelRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mata Pelajaran'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mapelList.isEmpty
              ? const Center(child: Text('Belum ada mata pelajaran.'))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: _mapelList.length,
                    itemBuilder: (context, index) {
                      final mapel = _mapelList[index];
                      return Dismissible(
                        key: Key(mapel.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Konfirmasi Hapus"),
                                content: Text("Anda yakin ingin menghapus '${mapel.name}'?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("BATAL"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("HAPUS"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) async {
                          await _repository.deleteMapel(mapel.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${mapel.name} berhasil dihapus')),
                            );
                            _loadData();
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            title: Text(mapel.name),
                            trailing: const Icon(Icons.edit),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapelFormPage(mapel: mapel),
                                ),
                              );
                              _loadData();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapelFormPage()),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
