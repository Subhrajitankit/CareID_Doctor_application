import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/referrals/referral_success_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget buildTestWidget({Widget? child}) {
    return MaterialApp(
      routes: {
        AppRoutes.referralDashboard: (context) =>
            const Scaffold(body: Text('Referral Dashboard Destination')),
        AppRoutes.referralDetails: (context) =>
            const Scaffold(body: Text('Referral Details Destination')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Destination')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patients Destination')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Profile Destination')),
      },
      home: child ?? const ReferralSuccessScreen(),
    );
  }

  group('ReferralSuccessScreen Widget Tests', () {
    testWidgets('renders heading, description, and action buttons accurately', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Heading
      expect(find.text('Referral Sent\nSuccessfully'), findsOneWidget);

      // Description
      expect(find.textContaining('receiving doctor has been'), findsOneWidget);

      // Action Buttons
      expect(find.text('Return to Referrals'), findsOneWidget);
      expect(find.text('View Referral Details'), findsOneWidget);

      // Bottom Navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('tapping Return to Referrals navigates to Referral Dashboard', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final returnButton = find.byKey(
        const Key('referral_success_return_button'),
      );
      expect(returnButton, findsOneWidget);
      await tester.ensureVisible(returnButton);

      await tester.tap(returnButton);
      await tester.pumpAndSettle();

      expect(find.text('Referral Dashboard Destination'), findsOneWidget);
    });

    testWidgets('tapping View Referral Details navigates to Referral Details', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final detailsButton = find.byKey(
        const Key('referral_success_details_button'),
      );
      expect(detailsButton, findsOneWidget);
      await tester.ensureVisible(detailsButton);

      await tester.tap(detailsButton);
      await tester.pumpAndSettle();

      expect(find.text('Referral Details Destination'), findsOneWidget);
    });
  });
}
