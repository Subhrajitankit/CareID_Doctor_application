import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/referrals/referral_dashboard_screen.dart';

void main() {
  testWidgets('ReferralDashboardScreen renders exact Figma node 10:3238 elements',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ReferralDashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. TopAppBar
    expect(find.byKey(const Key('referral_dashboard_menu_button')), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // 2. Title & Tabs
    expect(find.text('Referrals'), findsOneWidget);
    expect(find.byKey(const Key('referral_tab_outgoing')), findsOneWidget);
    expect(find.byKey(const Key('referral_tab_incoming')), findsOneWidget);
    expect(find.byKey(const Key('referral_tab_completed')), findsOneWidget);

    // 3. Summary Metric Cards
    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('ACCEPTED'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('COMPLETED'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('URGENT'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // 4. Referral Cards
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('ID: PT-8924'), findsOneWidget);
    expect(find.text('Urgent'), findsOneWidget);
    expect(find.text('Dr. Emily Chen (Cardiology)'), findsOneWidget);
    expect(find.text('Mercy General Hospital'), findsOneWidget);
    expect(find.text('Pending Review'), findsOneWidget);

    expect(find.text('Robert Fox'), findsOneWidget);
    expect(find.text('ID: PT-1045'), findsOneWidget);
    expect(find.text('Dr. Michael Chang (Neurology)'), findsOneWidget);
    expect(find.text('City Medical Center'), findsOneWidget);
    expect(find.text('Accepted'), findsOneWidget);

    // 5. FAB & Bottom Navigation
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Tab switching and metric card filtering update displayed referrals',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ReferralDashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Incoming tab
    await tester.ensureVisible(find.byKey(const Key('referral_tab_incoming')));
    await tester.tap(find.byKey(const Key('referral_tab_incoming')));
    await tester.pumpAndSettle();
    expect(find.text('Robert Fox'), findsOneWidget);

    // Switch to Completed tab
    await tester.ensureVisible(find.byKey(const Key('referral_tab_completed')));
    await tester.tap(find.byKey(const Key('referral_tab_completed')));
    await tester.pumpAndSettle();
    expect(find.text('Amanda Waller'), findsOneWidget);

    // Switch back to Outgoing tab
    await tester.ensureVisible(find.byKey(const Key('referral_tab_outgoing')));
    await tester.tap(find.byKey(const Key('referral_tab_outgoing')));
    await tester.pumpAndSettle();
    expect(find.text('Sarah Jenkins'), findsOneWidget);

    // Tap URGENT metric card to filter
    await tester.ensureVisible(find.text('URGENT'));
    await tester.tap(find.text('URGENT'));
    await tester.pumpAndSettle();
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('Robert Fox'), findsNothing);
  });
}
