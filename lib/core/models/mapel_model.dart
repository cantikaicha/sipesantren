import 'package:cloud_firestore/cloud_firestore.dart';

class MapelModel {
  final String id;
  final String name;
  final int? syncStatus;

  MapelModel({
    required this.id,
    required this.name,
    this.syncStatus,
  });

  factory MapelModel.fromMap(Map<String, dynamic> map) {
    return MapelModel(
      id: map['id'],
      name: map['name'],
      syncStatus: map['syncStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      if (syncStatus != null) 'syncStatus': syncStatus,
    };
  }

  factory MapelModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MapelModel(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }

  MapelModel copyWith({
    String? id,
    String? name,
    int? syncStatus,
  }) {
    return MapelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
