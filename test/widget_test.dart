// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // New import
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart'; // New import
import 'package:firebase_core/firebase_core.dart'; // New import

import 'package:sipesantren/main.dart';
import 'package:sipesantren/firebase_services.dart'; // New import

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // Required for Firebase
    await Firebase.initializeApp(); // Initialize a default Firebase app
  });

  testWidgets('MyApp renders without errors', (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseServicesProvider.overrideWithValue(FirebaseServices(firestore: fakeFirestore)),
        ],
        child: const MyApp(),
      ),
    );

    // For now, let's just make it pump successfully.
    await tester.pumpAndSettle();

    // The MyApp now shows a loading indicator first, then either SantriListPage or LoginPage
    // based on session. Since this is a simple smoke test, let's verify it builds.
    expect(find.byType(MyApp), findsOneWidget); 
  });
}
