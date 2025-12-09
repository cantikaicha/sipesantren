import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart'; // New import
import 'package:firebase_core/firebase_core.dart'; // New import
import 'package:sipesantren/core/repositories/santri_repository.dart'; // New import
import 'package:sipesantren/firebase_services.dart'; // New import
import 'package:sipesantren/features/santri/presentation/santri_list_page.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Required for Firebase
    await Firebase.initializeApp(); // Initialize a default Firebase app
  });
  testWidgets('SantriListPage renders without overflow', (WidgetTester tester) async {
    // Set up FakeFirestore with some dummy data
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('santri').add({
      'nis': '123',
      'nama': 'Test Santri',
      'kamar': 'A1',
      'angkatan': 2023,
    });

    // Set screen size to a common mobile width to test for overflow
    tester.view.physicalSize = const Size(400 * 3, 800 * 3); // 400 logical width
    tester.view.devicePixelRatio = 3.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override firebaseServicesProvider to use FakeFirestore
          firebaseServicesProvider.overrideWithValue(FirebaseServices(firestore: fakeFirestore)),
          // Override santriRepositoryProvider to use FakeFirestore
          santriRepositoryProvider.overrideWithValue(SantriRepository(firestore: fakeFirestore)),
        ],
        child: const MaterialApp(
          home: SantriListPage(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Wait for data to load and widgets to settle

    // Verify the page title
    expect(find.text('Daftar Santri'), findsOneWidget);

    // Verify Dropdowns exist
    expect(find.text('Semua Kamar'), findsOneWidget);
    expect(find.text('Semua Angkatan'), findsOneWidget);

    // Verify test santri is displayed
    expect(find.text('Test Santri'), findsOneWidget);

    // Check for overflow errors
    expect(tester.takeException(), isNull);

    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
