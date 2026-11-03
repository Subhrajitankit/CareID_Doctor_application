import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/prescriptions/drug_interaction_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({Widget? child}) {
    return MaterialApp(
      initialRoute: AppRoutes.drugInteractionReview,
      routes: {
        AppRoutes.drugInteractionReview: (context) =>
            child ?? const DrugInteractionReviewScreen(),
        AppRoutes.prescriptionPreview: (context) => const Scaffold(
          body: Center(child: Text('Prescription Preview Screen')),
        ),
      },
    );
  }

  group('DrugInteractionReviewScreen Widget Tests', () {
    testWidgets('renders all core UI elements matching Figma node 10:4604', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Top App Bar
      expect(find.text('Interaction Review'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // Alert Header Section
      expect(find.text('Potential Interaction\nDetected'), findsOneWidget);
      expect(
        find.text(
          'Please review the conflicts below before\nproceeding with the prescription.',
        ),
        findsOneWidget,
      );

      // Interaction Details Card (Card 1)
      expect(find.text('Drug-Drug Interaction'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);
      expect(find.text('PRESCRIBING'), findsOneWidget);
      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('CURRENT'), findsOneWidget);
      expect(find.text('Warfarin'), findsOneWidget);
      expect(find.text('Recommendation'), findsOneWidget);
      expect(
        find.text(
          'Monitor INR closely. Increased risk of bleeding when concurrent use of antiplatelet agents and anticoagulants.',
        ),
        findsOneWidget,
      );

      // Duplicate Warning Card (Card 2)
      expect(find.text('Duplicate Medication'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('Metformin 500mg'),
        ),
        findsOneWidget,
      );

      // Allergy Alert Card (Card 3)
      expect(find.text('Allergy Alert'), findsOneWidget);
      expect(find.text('Severe'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('Penicillin'),
        ),
        findsOneWidget,
      );

      // Bottom Action Buttons
      expect(find.text('Ignore &\nProceed'), findsOneWidget);
      expect(find.text('Edit\nPrescription'), findsOneWidget);
    });

    testWidgets('tapping Ignore & Proceed navigates to Prescription Preview', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final ignoreButton = find.text('Ignore &\nProceed');
      expect(ignoreButton, findsOneWidget);

      await tester.tap(ignoreButton);
      await tester.pumpAndSettle();

      expect(find.text('Prescription Preview Screen'), findsOneWidget);
    });

    testWidgets('tapping Edit Prescription pops back', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));

      final rootWidget = MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DrugInteractionReviewScreen(),
                  ),
                );
              },
              child: const Text('Open Review'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(rootWidget);
      await tester.pumpAndSettle();

      // Open screen
      await tester.tap(find.text('Open Review'));
      await tester.pumpAndSettle();

      expect(find.text('Interaction Review'), findsOneWidget);

      // Tap Edit Prescription
      await tester.tap(find.text('Edit\nPrescription'));
      await tester.pumpAndSettle();

      // Should be back to root
      expect(find.text('Open Review'), findsOneWidget);
      expect(find.text('Interaction Review'), findsNothing);
    });

    testWidgets('tapping Go Back button in TopAppBar pops back', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));

      final rootWidget = MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DrugInteractionReviewScreen(),
                  ),
                );
              },
              child: const Text('Open Review'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(rootWidget);
      await tester.pumpAndSettle();

      // Open screen
      await tester.tap(find.text('Open Review'));
      await tester.pumpAndSettle();

      expect(find.text('Interaction Review'), findsOneWidget);

      // Tap Go Back arrow
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Open Review'), findsOneWidget);
      expect(find.text('Interaction Review'), findsNothing);
    });
  });
}
