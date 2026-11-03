import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/prescriptions/prescription_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrescriptionHistoryScreen renders exact Figma node 10:4820 components',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.dashboard: (context) =>
              const Scaffold(body: Text('Dashboard View')),
          AppRoutes.prescriptionPreview: (context) =>
              const Scaffold(body: Text('Prescription Preview View')),
          AppRoutes.prescriptionBuilder: (context) =>
              const Scaffold(body: Text('Prescription Builder View')),
          AppRoutes.appointmentsOverview: (context) =>
              const Scaffold(body: Text('Appointments Overview View')),
          AppRoutes.doctorProfile: (context) =>
              const Scaffold(body: Text('Doctor Profile View')),
          AppRoutes.cameraPermission: (context) =>
              const Scaffold(body: Text('Camera Permission View')),
        },
        home: const PrescriptionHistoryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.text('Prescription History'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_outlined), findsOneWidget);

    // 2. Verify Search Bar
    expect(find.text('Search medications...'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    // 3. Verify Filter Pills
    expect(find.text('Active'), findsAtLeastNWidgets(1));
    expect(find.text('Completed'), findsAtLeastNWidgets(1));
    expect(find.text('Cancelled'), findsOneWidget);

    // 4. Verify Active Item (Lisinopril 10mg) is displayed initially
    expect(find.text('Lisinopril 10mg'), findsOneWidget);
    expect(find.text('Sep 12, 2023'), findsOneWidget);
    expect(find.textContaining('daily for blood pressure'), findsOneWidget);
    expect(find.textContaining('Dr. Sarah Jenkins (Cardiology)'), findsOneWidget);
    expect(find.text('Repeat'), findsAtLeastNWidgets(1));
    expect(find.text('View Details'), findsAtLeastNWidgets(1));

    // 5. Verify Bottom Navigation Shell
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);

    // 6. Test Filtering: Tap "Completed" filter
    await tester.tap(find.text('Completed').first);
    await tester.pumpAndSettle();

    // Now Amoxicillin 500mg should be visible
    expect(find.text('Amoxicillin 500mg'), findsOneWidget);
    expect(find.text('Jul 05, 2023'), findsOneWidget);
    expect(find.textContaining('three times daily for 7 days'), findsOneWidget);
    expect(find.textContaining('Dr. Mark Owen (Primary Care)'), findsOneWidget);

    // 7. Test Search Bar: Enter query
    await tester.enterText(find.byType(TextField), 'Amoxicillin');
    await tester.pumpAndSettle();
    expect(find.text('Amoxicillin 500mg'), findsOneWidget);

    // Clear search
    await tester.enterText(find.byType(TextField), 'NonExistentDrug');
    await tester.pumpAndSettle();
    expect(find.text('No prescriptions found'), findsOneWidget);

    // Clear text
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Active').first);
    await tester.pumpAndSettle();

    // 8. Test Navigation: Tap "View Details"
    await tester.tap(find.text('View Details').first);
    await tester.pumpAndSettle();
    expect(find.text('Prescription Preview View'), findsOneWidget);
  });
}
