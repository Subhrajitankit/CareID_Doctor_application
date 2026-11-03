import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/prescriptions/prescription_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrescriptionPreviewScreen renders exact Figma elements',
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
        },
        home: const PrescriptionPreviewScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title in App Bar
    expect(find.text('Prescription Preview'), findsOneWidget);

    // Verify Hospital and Doctor Header
    expect(find.text('Metro General\nHospital'), findsOneWidget);
    expect(find.text('123 Clinical Way, Medical\nDistrict, NY 10001'),
        findsOneWidget);
    expect(find.text('Phone: (555) 019-8273'), findsOneWidget);
    expect(find.text('Dr. Sarah\nJenkins'), findsOneWidget);
    expect(find.text('MD, Internal\nMedicine'), findsOneWidget);
    expect(find.text('Reg. No:\nMED-7492-X'), findsOneWidget);

    // Verify Patient Info Card
    expect(find.text('PATIENT NAME'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('AGE / SEX'), findsOneWidget);
    expect(find.text('44 / M'), findsOneWidget);
    expect(find.text('DATE'), findsOneWidget);
    expect(find.text('Oct 24, 2023'), findsOneWidget);
    expect(find.text('WEIGHT'), findsOneWidget);
    expect(find.text('82 kg'), findsOneWidget);

    // Verify Rx Section & Medications
    expect(find.text('℞'), findsOneWidget);
    expect(find.text('Medications'), findsOneWidget);
    expect(find.text('1. Lisinopril 10mg'), findsOneWidget);
    expect(find.text('Take 1 tablet by mouth daily in the morning.'),
        findsOneWidget);
    expect(find.text('30 Tablets'), findsOneWidget);
    expect(find.text('0 Refills'), findsOneWidget);

    expect(find.text('2. Metformin 500mg'), findsOneWidget);
    expect(find.text('Take 1 tablet by mouth twice daily with meals.'),
        findsOneWidget);
    expect(find.text('60 Tablets'), findsOneWidget);
    expect(find.text('2 Refills'), findsOneWidget);
    expect(find.text('Oral'), findsNWidgets(2));

    // Verify Footer
    expect(find.text('Scan to\nverify'), findsOneWidget);
    expect(find.text('S. Jenkins'), findsOneWidget);
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Digitally Signed'), findsOneWidget);

    // Verify Document Actions
    expect(find.text('Document Actions'), findsOneWidget);
    expect(find.text('Share PDF'), findsOneWidget);
    expect(find.text('Print'), findsOneWidget);
    expect(find.text('Send to Patient'), findsOneWidget);
    expect(find.text('Save to Records'), findsOneWidget);

    // Verify Primary Action Button
    expect(find.text('Finalize & Sign'), findsOneWidget);

    // Tap on Action Button (Share PDF) and verify snackbar
    await tester.ensureVisible(find.text('Share PDF'));
    await tester.tap(find.text('Share PDF'));
    await tester.pump();
    expect(find.text('Generating and sharing encrypted PDF...'), findsOneWidget);

    // Tap Finalize & Sign and verify navigation
    await tester.ensureVisible(find.text('Finalize & Sign'));
    await tester.tap(find.text('Finalize & Sign'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard View'), findsOneWidget);
  });
}
