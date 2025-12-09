import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // New import
import 'package:sipesantren/firebase_services.dart'; // New import for firestoreProvider
import '../models/penilaian_model.dart';

class PenilaianRepository {
  final FirebaseFirestore _db;

  PenilaianRepository({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  // --- Tahfidz ---
  Future<void> addPenilaianTahfidz(PenilaianTahfidz data) async {
    await _db.collection('penilaian_tahfidz').add(data.toFirestore());
  }

  Stream<List<PenilaianTahfidz>> getTahfidzBySantri(String santriId) {
    return _db.collection('penilaian_tahfidz')
        .where('santriId', isEqualTo: santriId)
        .orderBy('minggu', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => PenilaianTahfidz.fromFirestore(d)).toList());
  }

  // --- Mapel ---
  Future<void> addPenilaianMapel(PenilaianMapel data) async {
    await _db.collection('penilaian_mapel').add(data.toFirestore());
  }

  Stream<List<PenilaianMapel>> getMapelBySantri(String santriId) {
    return _db.collection('penilaian_mapel')
        .where('santriId', isEqualTo: santriId)
        .snapshots()
        .map((s) => s.docs.map((d) => PenilaianMapel.fromFirestore(d)).toList());
  }

  // --- Akhlak ---
  Future<void> addPenilaianAkhlak(PenilaianAkhlak data) async {
    await _db.collection('penilaian_akhlak').add(data.toFirestore());
  }

  Stream<List<PenilaianAkhlak>> getAkhlakBySantri(String santriId) {
    return _db.collection('penilaian_akhlak')
        .where('santriId', isEqualTo: santriId)
        .snapshots()
        .map((s) => s.docs.map((d) => PenilaianAkhlak.fromFirestore(d)).toList());
  }

  // --- Kehadiran ---
  Future<void> addKehadiran(Kehadiran data) async {
    await _db.collection('kehadiran').add(data.toFirestore());
  }

  Stream<List<Kehadiran>> getKehadiranBySantri(String santriId) {
    return _db.collection('kehadiran')
        .where('santriId', isEqualTo: santriId)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Kehadiran.fromFirestore(d)).toList());
  }
}

final penilaianRepositoryProvider = Provider((ref) => PenilaianRepository(firestore: ref.watch(firestoreProvider)));
