import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/prescriptions/prescription_builder_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget buildTestableWidget({Widget? child}) {
    return MaterialApp(
      initialRoute: AppRoutes.prescriptionBuilder,
      routes: {
        AppRoutes.prescriptionBuilder: (context) =>
            child ?? const PrescriptionBuilderScreen(),
        AppRoutes.drugInteractionReview: (context) => const Scaffold(
              body: Text('Drug Interaction Review Screen'),
            ),
        AppRoutes.notificationCenter: (context) => const Scaffold(
              body: Text('Notification Center Screen'),
            ),
      },
    );
  }

  group('PrescriptionBuilderScreen Widget Tests', () {
    testWidgets('renders all Figma header, patient summary, and form sections accurately',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Prescription Builder'), findsOneWidget);
      expect(find.text('Drafting new medication order'), findsOneWidget);

      // Verify Patient Summary Card
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('HV-99214'), findsOneWidget);
      expect(find.text('PRIMARY DIAGNOSIS'), findsOneWidget);
      expect(
        find.text('Essential (primary) hypertension'),
        findsOneWidget,
      );
      expect(find.text('KNOWN ALLERGIES'), findsOneWidget);
      expect(find.text('Penicillin'), findsOneWidget);
      expect(find.text('Latex (Mild)'), findsOneWidget);

      // Verify Clinical Insights
      expect(find.text('Clinical Insights'), findsOneWidget);

      // Verify Add Medication Section
      expect(find.text('Add Medication'), findsOneWidget);
      expect(find.text('Search drug database...'), findsOneWidget);
      expect(find.text('Medicine Name'), findsOneWidget);
      expect(find.text('Dosage'), findsOneWidget);
      expect(find.text('Frequency'), findsOneWidget);
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('Route'), findsOneWidget);
      expect(find.text('Patient Instructions'), findsOneWidget);
      expect(find.text('Add to Order'), findsOneWidget);

      // Verify Current Prescription Section
      expect(find.text('Current Prescription'), findsOneWidget);
      expect(find.text('No interaction alerts detected'), findsOneWidget);

      // Verify Bottom Action Buttons
      expect(find.text('Save Draft'), findsOneWidget);
      expect(find.text('Review\nInteractions'), findsOneWidget);
    });

    testWidgets('can add a new medicine to the order list dynamically',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Initial count should show the initial medication
      expect(find.text('Lisinopril 10mg'), findsWidgets);

      // Tap Add to Order
      final addBtn = find.byKey(
        const Key('prescription_builder_add_to_order_button'),
      );
      await tester.ensureVisible(addBtn);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // Should show SnackBar confirmation
      expect(
        find.text('Lisinopril 10mg added to prescription order.'),
        findsOneWidget,
      );
    });

    testWidgets('tapping Review Interactions navigates to DrugInteractionReview screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final reviewBtn = find.byKey(
        const Key('prescription_builder_review_interactions_button'),
      );
      await tester.tap(reviewBtn);
      await tester.pumpAndSettle();

      expect(find.text('Drug Interaction Review Screen'), findsOneWidget);
    });

    testWidgets('tapping Save Draft displays confirmation snackbar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.625;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final saveDraftBtn = find.byKey(
        const Key('prescription_builder_save_draft_button'),
      );
      await tester.tap(saveDraftBtn);
      await tester.pump();

      expect(
        find.text('Prescription draft saved successfully.'),
        findsOneWidget,
      );
    });
  });
}

