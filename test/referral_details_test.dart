import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/features/referrals/referral_details_screen.dart';

void main() {
  group('ReferralDetailsScreen Widget Tests', () {
    testWidgets('renders all Figma sections with referral data', (tester) async {
      final referral = MockData.referrals[0];

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.patientProfile: (context) =>
                const Scaffold(body: Text('Patient Profile Screen')),
            AppRoutes.doctorProfile: (context) =>
                const Scaffold(body: Text('Doctor Profile Screen')),
            AppRoutes.dashboard: (context) =>
                const Scaffold(body: Text('Dashboard Screen')),
          },
          home: ReferralDetailsScreen(referralArg: referral),
        ),
      );

      await tester.pumpAndSettle();

      // TopAppBar & Header
      expect(find.text('Referral Details'), findsOneWidget);
      expect(find.byKey(const Key('referral_details_back_button')), findsOneWidget);

      // Section 1: Status & Priority Banner
      expect(find.text('REFERRAL STATUS'), findsOneWidget);
      expect(find.text('CLINICAL PRIORITY'), findsOneWidget);

      // Section 2: Patient Summary Card
      expect(find.text('Patient Summary'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('MRN / Patient ID'), findsOneWidget);
      expect(find.text('DOB & Age'), findsOneWidget);
      expect(find.text('Primary Contact'), findsOneWidget);
      expect(find.text(referral.patient.name), findsOneWidget);

      // Section 3: Clinical Justification & Notes
      expect(find.textContaining('Clinical Justification'), findsOneWidget);
      expect(find.text('Diagnosis / Reason'), findsOneWidget);
      expect(find.text('Referring Physician Notes'), findsOneWidget);
      expect(find.text('Attached Clinical Documents'), findsOneWidget);
      expect(find.text('Recent_ECG_Results.pdf'), findsOneWidget);
      expect(find.text('Lipid_Panel_Sep.pdf'), findsOneWidget);

      // Section 4: Routing Network
      expect(find.text('Routing Network'), findsOneWidget);
      expect(find.text('REFERRED BY'), findsOneWidget);
      expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
      expect(find.text('REFERRED TO'), findsOneWidget);
      expect(find.text(referral.targetDoctor), findsOneWidget);
      expect(find.text('Memorial General Hospital'), findsOneWidget);

      // Section 5: Activity Timeline
      expect(find.text('Activity Timeline'), findsOneWidget);
      expect(find.text('Patient Contacted'), findsOneWidget);
      expect(find.text('Referral Accepted'), findsOneWidget);
      expect(find.text('Referral Submitted'), findsOneWidget);

      // Sticky Actions
      expect(find.byKey(const Key('referral_details_share_button')), findsOneWidget);
      expect(find.byKey(const Key('referral_details_edit_button')), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('interacts with action buttons and navigates to chart', (tester) async {
      final referral = MockData.referrals[0];

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.patientProfile: (context) =>
                const Scaffold(body: Text('Patient Profile Screen')),
          },
          home: ReferralDetailsScreen(referralArg: referral),
        ),
      );

      await tester.pumpAndSettle();

      // Test tapping Share button
      final shareBtn = find.byKey(const Key('referral_details_share_button'));
      await tester.tap(shareBtn);
      await tester.pump();
      expect(find.textContaining('Referral packet exported'), findsOneWidget);

      // Clear SnackBars
      ScaffoldMessenger.of(tester.element(shareBtn)).clearSnackBars();
      await tester.pumpAndSettle();

      // Test tapping Edit button
      final editBtn = find.byKey(const Key('referral_details_edit_button'));
      await tester.tap(editBtn);
      await tester.pump();
      expect(find.textContaining('Opening referral update editor'), findsOneWidget);

      // Clear SnackBars
      ScaffoldMessenger.of(tester.element(editBtn)).clearSnackBars();
      await tester.pumpAndSettle();

      // Test tapping View Chart
      final viewChartBtn = find.byKey(const Key('referral_details_view_chart_button'));
      await tester.tap(viewChartBtn);
      await tester.pumpAndSettle();

      expect(find.text('Patient Profile Screen'), findsOneWidget);
    });
  });
}
