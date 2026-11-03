import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/referrals/incoming_referral_screen.dart';

void main() {
  testWidgets('IncomingReferralScreen renders exact Figma node 10:5719 elements',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: IncomingReferralScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. TopAppBar (Node 10:5750)
    expect(find.byKey(const Key('incoming_referral_back_button')), findsOneWidget);
    expect(find.byKey(const Key('incoming_referral_bell_button')), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // 2. Header Section (Node 10:5765)
    expect(find.text('INCOMING REFERRAL'), findsOneWidget);
    expect(find.text('Review Patient'), findsOneWidget);
    expect(find.text('Received 2 hours ago'), findsOneWidget);

    // 3. Card 1: Patient Summary Card (Node 10:5776)
    expect(find.text('Robert Caldwell'), findsOneWidget);
    expect(find.text('Male, 58 yrs • DOB: 12/04/1965'), findsOneWidget);
    expect(find.text('ID: HV-883-921'), findsOneWidget);
    expect(find.text('Urgent'), findsOneWidget);
    expect(find.text('Reason for Referral'), findsOneWidget);
    expect(
      find.textContaining('Evaluation of persistent, unexplained tachycardia'),
      findsOneWidget,
    );

    // 4. Card 2: Referring Physician Card (Node 10:5799)
    expect(find.text('Referring Physician'), findsOneWidget);
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('General Practice, City Health'), findsOneWidget);
    expect(find.text('Message Dr. Jenkins'), findsOneWidget);

    // 5. Card 3: Recent Vitals Card (Node 10:5819)
    expect(find.text('Recent Vitals'), findsOneWidget);
    expect(find.text('Blood Pressure'), findsOneWidget);
    expect(find.text('145/90'), findsOneWidget);
    expect(find.text('Heart Rate'), findsOneWidget);
    expect(find.textContaining('112'), findsOneWidget);
    expect(find.textContaining('bpm'), findsOneWidget);
    expect(find.text('SpO2'), findsOneWidget);
    expect(find.textContaining('96 %'), findsOneWidget);
    expect(find.text('Temp'), findsOneWidget);
    expect(find.textContaining('98.4'), findsOneWidget);
    expect(find.textContaining('°F'), findsOneWidget);

    // 6. Card 4: Attached Medical Records Card (Node 10:5849)
    await tester.ensureVisible(find.text('Attached Medical Records'));
    expect(find.text('Attached Medical Records'), findsOneWidget);
    expect(find.text('Initial Consultation Notes.pdf'), findsOneWidget);
    expect(find.text('1.2 MB • Uploaded Today'), findsOneWidget);
    expect(find.text('Chest X-Ray (AP View).dcm'), findsOneWidget);
    expect(find.text('15 MB • Uploaded Yesterday'), findsOneWidget);
    expect(find.text('Comprehensive Metabolic Panel.pdf'), findsOneWidget);
    expect(find.text('340 KB • Uploaded Yesterday'), findsOneWidget);

    // 7. Action Area Card (Node 10:5896)
    await tester.ensureVisible(find.byKey(const Key('incoming_referral_request_info_button')));
    expect(find.text('Request More Information'), findsOneWidget);
    expect(find.byKey(const Key('incoming_referral_decline_button')), findsOneWidget);
    expect(find.byKey(const Key('incoming_referral_accept_button')), findsOneWidget);

    // 8. Bottom Navigation Shell (Node 10:5720)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Interactive actions trigger expected feedback and state changes',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.patientMessages: (ctx) => const Scaffold(body: Text('Messages Screen')),
          AppRoutes.referralDashboard: (ctx) => const Scaffold(body: Text('Referral Dashboard')),
        },
        home: const IncomingReferralScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Test "Request More Information"
    await tester.ensureVisible(find.byKey(const Key('incoming_referral_request_info_button')));
    await tester.tap(find.byKey(const Key('incoming_referral_request_info_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Information request sent to Dr. Sarah Jenkins.'), findsOneWidget);

    // Clear current snackbar before triggering file click
    ScaffoldMessenger.of(tester.element(find.byType(IncomingReferralScreen))).clearSnackBars();
    await tester.pumpAndSettle();

    // 2. Test file row click
    await tester.ensureVisible(find.byKey(const Key('file_consultation_notes')));
    await tester.tap(find.byKey(const Key('file_consultation_notes')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Opening Initial Consultation Notes.pdf'), findsOneWidget);

    // Clear current snackbar before accepting referral
    ScaffoldMessenger.of(tester.element(find.byType(IncomingReferralScreen))).clearSnackBars();
    await tester.pumpAndSettle();

    // 3. Test "Accept Referral"
    await tester.ensureVisible(find.byKey(const Key('incoming_referral_accept_button')));
    await tester.tap(find.byKey(const Key('incoming_referral_accept_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Referral accepted! Patient added to clinical queue.'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
  });
}
