import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/referrals/create_referral_screen.dart';

void main() {
  testWidgets('CreateReferralScreen renders exact Figma node 10:3409 components',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: CreateReferralScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. TopAppBar (Node 10:3439)
    expect(find.text('Create Referral'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_back_button')), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // 2. Patient Summary Card (Node 10:3452)
    expect(find.text('ET'), findsOneWidget);
    expect(find.text('Eleanor Thompson'), findsOneWidget);
    expect(find.text('HV-8829-4410-X'), findsOneWidget);
    expect(find.text('Active Patient'), findsOneWidget);

    // 3. Section - Doctor Selection / "Refer To" (Node 10:3468)
    expect(find.text('Refer To'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_search_doctor_input')), findsOneWidget);
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Cardiology • Mount Sinai Hospital'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_remove_doctor_button')), findsOneWidget);

    // 4. Section - Referral Details (Node 10:3489)
    expect(find.text('Referral Details'), findsOneWidget);
    expect(find.text('Reason for Referral'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_reason_dropdown')), findsOneWidget);
    expect(find.text('Clinical Summary'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_clinical_summary_input')), findsOneWidget);

    // 5. Section - Urgency Toggles (Node 10:3510)
    expect(find.text('Urgency'), findsOneWidget);
    expect(find.byKey(const Key('urgency_chip_routine')), findsOneWidget);
    expect(find.byKey(const Key('urgency_chip_priority')), findsOneWidget);
    expect(find.byKey(const Key('urgency_chip_urgent')), findsOneWidget);

    // 6. Section - Attachments (Node 10:3530)
    await tester.ensureVisible(find.text('Attachments'));
    expect(find.text('Attachments'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_add_file_button')), findsOneWidget);
    expect(find.text('Recent_ECG_Result.pdf'), findsOneWidget);
    expect(find.text('Comprehensive_Metabolic_Panel.pdf'), findsOneWidget);
    expect(find.text('Past_Clinical_Notes.docx'), findsOneWidget);

    // 7. Action Buttons (Node 10:3564)
    await tester.ensureVisible(find.byKey(const Key('create_referral_submit_button')));
    expect(find.text('Send Referral'), findsOneWidget);
    expect(find.byKey(const Key('create_referral_share_outside_button')), findsOneWidget);
    expect(find.text('Share Outside CareID'), findsOneWidget);

    // 8. Bottom Navigation Shell (Node 10:3410)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Interactive behaviors: urgency toggle, attachments, and referral submission',
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
          AppRoutes.referralSuccess: (ctx) => const Scaffold(body: Text('Referral Success Screen')),
        },
        home: const CreateReferralScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Toggle Urgency to "Urgent"
    await tester.ensureVisible(find.byKey(const Key('urgency_chip_urgent')));
    await tester.tap(find.byKey(const Key('urgency_chip_urgent')));
    await tester.pumpAndSettle();

    // 2. Add an attachment
    await tester.ensureVisible(find.byKey(const Key('create_referral_add_file_button')));
    await tester.tap(find.byKey(const Key('create_referral_add_file_button')));
    await tester.pumpAndSettle();
    expect(find.text('Lab_Report_4.pdf'), findsOneWidget);

    // Clear snackbars before submission
    ScaffoldMessenger.of(tester.element(find.byType(CreateReferralScreen))).clearSnackBars();
    await tester.pumpAndSettle();

    // 3. Remove first attachment
    await tester.ensureVisible(find.byKey(const Key('create_referral_remove_file_0')));
    await tester.tap(find.byKey(const Key('create_referral_remove_file_0')));
    await tester.pumpAndSettle();
    expect(find.text('Recent_ECG_Result.pdf'), findsNothing);

    // 4. Submit referral and verify navigation
    await tester.ensureVisible(find.byKey(const Key('create_referral_submit_button')));
    await tester.tap(find.byKey(const Key('create_referral_submit_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('created successfully'), findsOneWidget);

    // Advance clock to trigger route pushReplacement
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    expect(find.text('Referral Success Screen'), findsOneWidget);
  });
}
