import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/ocr_upload/upload_center_screen.dart';
import 'package:careid_doctor/features/ocr_upload/ocr_processing_screen.dart';
import 'package:careid_doctor/features/ocr_upload/ocr_review_screen.dart';
import 'package:careid_doctor/features/ocr_upload/report_upload_success_screen.dart';

void main() {
  group('Screen 1 — Upload Center (Figma Node 10:2570) Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2570', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.ocrProcessing: (context) =>
                const Scaffold(body: Text('OCR_PROCESSING_DESTINATION')),
            AppRoutes.notificationCenter: (context) =>
                const Scaffold(body: Text('NOTIFICATIONS')),
            AppRoutes.medicalRecords: (context) =>
                const Scaffold(body: Text('RECORDS')),
            AppRoutes.dashboard: (context) =>
                const Scaffold(body: Text('DASHBOARD')),
            AppRoutes.patientDirectory: (context) =>
                const Scaffold(body: Text('PATIENTS')),
            AppRoutes.appointmentsOverview: (context) =>
                const Scaffold(body: Text('SCHEDULE')),
            AppRoutes.doctorProfile: (context) =>
                const Scaffold(body: Text('PROFILE')),
          },
          home: const UploadCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top App Bar
      expect(find.text('Upload Health Report'), findsOneWidget);

      // Patient Context Card
      expect(find.text('JD'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('ID: HV-9824 • DOB: 12/05/1980'), findsOneWidget);
      expect(find.text('Change\nPatient'), findsOneWidget);

      // Upload Methods
      expect(find.text('Select Upload Method'), findsOneWidget);
      expect(find.text('Scan with Camera'), findsOneWidget);
      expect(find.text('Best for physical documents'), findsOneWidget);
      expect(find.text('Upload from Gallery'), findsOneWidget);
      expect(find.text('JPG, PNG images'), findsOneWidget);
      expect(find.text('Import PDF'), findsOneWidget);
      expect(find.text('Digital reports & files'), findsOneWidget);

      // Supported Formats Info
      expect(find.text('Supported Document Types'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('JPG, PNG, and PDF'),
        ),
        findsOneWidget,
      );

      // Recent Uploads
      expect(find.text('Recent Uploads'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.text('CBC Blood Test Panel'), findsOneWidget);
      expect(find.text('Chest X-Ray Scan'), findsOneWidget);
      expect(find.text('External Prescription'), findsOneWidget);
      expect(find.text('Verified'), findsNWidgets(2));
      expect(find.text('Processing'), findsOneWidget);

      // Floating Bottom Navigation Shell
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Test tapping an upload method triggers navigation
      await tester.tap(find.text('Scan with Camera'));
      await tester.pumpAndSettle();
      expect(find.text('OCR_PROCESSING_DESTINATION'), findsOneWidget);
    });
  });

  group('Screen 2 — OCR Processing (Figma Node 10:2505) Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2505', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.ocrReview: (context) =>
                const Scaffold(body: Text('OCR_REVIEW_DESTINATION')),
            AppRoutes.notificationCenter: (context) =>
                const Scaffold(body: Text('NOTIFICATIONS')),
          },
          home: const OcrProcessingScreen(),
        ),
      );
      await tester.pump(); // Start animations

      // Top App Bar
      expect(find.text('Care ID Scanner'), findsOneWidget);

      // Heading and Subtitle
      expect(find.text('OCR Processing'), findsOneWidget);
      expect(find.text('Analyzing medical document data'), findsOneWidget);

      // Step List
      expect(find.text('Detecting document'), findsOneWidget);
      expect(find.text('Enhancing image'), findsOneWidget);
      expect(find.text('Extracting text...'), findsOneWidget);
      expect(find.text('Identifying fields'), findsOneWidget);

      // Cancel button
      expect(find.text('Cancel Processing'), findsOneWidget);

      // Fast forward timer to verify transition to OCR Review
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();
      expect(find.text('OCR_REVIEW_DESTINATION'), findsOneWidget);
    });
  });

  group('Screen 3 — OCR Review (Figma Node 10:2728) Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2728', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.uploadSuccess: (context) =>
                const Scaffold(body: Text('UPLOAD_SUCCESS_DESTINATION')),
            AppRoutes.notificationCenter: (context) =>
                const Scaffold(body: Text('NOTIFICATIONS')),
          },
          home: const OcrReviewScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top App Bar
      expect(find.text('Review Extraction'), findsOneWidget);

      // Header row
      expect(find.text('Extracted Data'), findsOneWidget);
      expect(find.text('Auto-extracted'), findsOneWidget);

      // Form Labels and Match Confidence
      expect(find.text('Patient Name'), findsOneWidget);
      expect(find.text('98% Match'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);

      expect(find.text('CareID Vault'), findsOneWidget);
      expect(find.text('99% Match'), findsOneWidget);
      expect(find.text('HV-992-841-B'), findsOneWidget);

      expect(find.text('Laboratory Name'), findsOneWidget);
      expect(find.text('65% Match'), findsOneWidget);
      expect(find.text('Quest Diagnostics'), findsOneWidget);

      expect(find.text('Test Date'), findsOneWidget);
      expect(find.text('82% Match'), findsOneWidget);
      expect(find.text('2023-10-24'), findsOneWidget);

      expect(find.text('Extracted Diagnosis/Notes'), findsOneWidget);
      expect(find.text('91% Match'), findsOneWidget);
      expect(
        find.textContaining('Elevated LDL cholesterol levels noted'),
        findsOneWidget,
      );

      // Action Buttons
      expect(find.text('Edit Fields'), findsOneWidget);
      expect(find.text('Approve All'), findsOneWidget);

      // Test Edit Fields tap
      await tester.tap(find.text('Edit Fields'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Field editing enabled'), findsOneWidget);

      // Dismiss SnackBar before tapping Approve All
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Test Approve All tap
      await tester.tap(find.text('Approve All'));
      await tester.pumpAndSettle();
      expect(find.text('UPLOAD_SUCCESS_DESTINATION'), findsOneWidget);
    });
  });

  group(
    'Screen 4 — Report Upload Success (Figma Node 10:2811) Verification',
    () {
      testWidgets('renders all core UI elements matching Figma node 10:2811', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MaterialApp(
            routes: {
              AppRoutes.dashboard: (context) =>
                  const Scaffold(body: Text('DASHBOARD_DESTINATION')),
              AppRoutes.uploadCenter: (context) =>
                  const Scaffold(body: Text('UPLOAD_CENTER_DESTINATION')),
            },
            home: const ReportUploadSuccessScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Top App Bar
        expect(find.text('Upload Complete'), findsOneWidget);

        // Success Heading and Subtitle
        expect(find.text('Upload Successful'), findsOneWidget);
        expect(
          find.text(
            'Document successfully verified and saved to\nPatient Record.',
          ),
          findsOneWidget,
        );

        // Buttons
        expect(find.text('Return to Patient Profile'), findsOneWidget);
        expect(find.text('Upload Another'), findsOneWidget);

        // Test Upload Another tap
        await tester.tap(find.text('Upload Another'));
        await tester.pumpAndSettle();
        expect(find.text('UPLOAD_CENTER_DESTINATION'), findsOneWidget);
      });
    },
  );
}
