import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipesantren/core/repositories/mapel_repository.dart';
import 'package:sipesantren/core/models/mapel_model.dart';
import 'kelas_detail_page.dart';

class KelasListPage extends ConsumerWidget {
  const KelasListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kelas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<MapelModel>>(
        future: ref.read(mapelRepositoryProvider).getMapelList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final mapels = snapshot.data ?? [];
          
          if (mapels.isEmpty) {
            return const Center(child: Text('Belum ada kelas/mata pelajaran.'));
          }

          return ListView.builder(
            itemCount: mapels.length,
            itemBuilder: (context, index) {
              final mapel = mapels[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text(mapel.name),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KelasDetailPage(mapel: mapel),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
