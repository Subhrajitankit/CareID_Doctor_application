import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';

/// Drug Interaction Review screen matching exact Figma Node 10:4604.
class DrugInteractionReviewScreen extends StatelessWidget {
  final String prescribingDrug;
  final String currentDrug;
  final String duplicateDrug;
  final String allergen;
  final String severity;
  final String allergySeverity;

  const DrugInteractionReviewScreen({
    super.key,
    this.prescribingDrug = 'Aspirin',
    this.currentDrug = 'Warfarin',
    this.duplicateDrug = 'Metformin 500mg',
    this.allergen = 'Penicillin',
    this.severity = 'Moderate',
    this.allergySeverity = 'Severe',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.8, -0.6),
            end: Alignment(0.8, 0.6),
            stops: [0.0, 0.5, 1.0],
            colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF), Color(0xFFF5F3FF)],
          ),
        ),
        child: Stack(
          children: [
            // Scrollable Content Area
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 96,
                  bottom: 128,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Alert Header Section (Node 10:4606)
                        _buildAlertHeaderSection(),
                        const SizedBox(height: 16),

                        // Interaction Details Card (Node 10:4616)
                        _buildInteractionDetailsCard(),
                        const SizedBox(height: 16),

                        // Duplicate Warning Card (Node 10:4646)
                        _buildDuplicateWarningCard(),
                        const SizedBox(height: 16),

                        // Allergy Conflict Card (Node 10:4656)
                        _buildAllergyConflictCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Top App Bar (Node 10:4669)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopAppBar(context),
            ),

            // Bottom Actions & Navigation Area (Node 10:4679)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomActionsArea(context),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP APP BAR (Node 10:4669)
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Button - Go back (Node 10:4671)
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              child: InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ),
            ),

            // Heading 1 (Node 10:4674)
            Expanded(
              child: Center(
                child: Text(
                  'Interaction Review',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF28006D),
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),

            // Button - Notifications (Node 10:4676)
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              child: InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTap: () {},
                child: const SizedBox(
                  width: 32,
                  height: 36,
                  child: Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ALERT HEADER SECTION (Node 10:4606)
  // ==========================================
  Widget _buildAlertHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Yellow Circle with Amber Warning Triangle (Node 10:4608)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(44, 38),
                painter: _AlertTrianglePainter(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Heading 2 (Node 10:4611)
          Text(
            'Potential Interaction\nDetected',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191C1D),
              height: 32 / 24,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle Container (Node 10:4614)
          Text(
            'Please review the conflicts below before\nproceeding with the prescription.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF494552),
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 1: INTERACTION DETAILS CARD (Node 10:4616)
  // ==========================================
  Widget _buildInteractionDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF), // 85% opacity white
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 21, 21, 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Icon + Drug-Drug Interaction + Moderate Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomPaint(
                      size: const Size(14, 18),
                      painter: _PillBottlePainter(),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Drug-Drug Interaction',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF191C1D),
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  severity,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF92400E),
                    letterSpacing: 0.5,
                    height: 16 / 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Background+Border (Node 10:4625)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            padding: const EdgeInsets.all(13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Prescribing Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRESCRIBING',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF494552),
                          letterSpacing: 0.6,
                          height: 16 / 12,
                        ),
                      ),
                      Text(
                        prescribingDrug,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF191C1D),
                          height: 24 / 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Interaction Arrows (Node 10:4631)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomPaint(
                    size: const Size(34, 16),
                    painter: _InteractionArrowsPainter(),
                  ),
                ),

                // Current Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'CURRENT',
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF494552),
                          letterSpacing: 0.6,
                          height: 16 / 12,
                        ),
                      ),
                      Text(
                        currentDrug,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF191C1D),
                          height: 24 / 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recommendation Box (Node 10:4638)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: CustomPaint(
                    size: const Size(20, 20),
                    painter: _InfoCirclePainter(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendation',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF191C1D),
                          letterSpacing: 0.1,
                          height: 20 / 14,
                        ),
                      ),
                      Text(
                        'Monitor INR closely. Increased risk of bleeding when concurrent use of antiplatelet agents and anticoagulants.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF494552),
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 2: DUPLICATE WARNING CARD (Node 10:4646)
  // ==========================================
  Widget _buildDuplicateWarningCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Left Accent Border (4px #0EA5E9)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: const Color(0xFF0EA5E9)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 21, 21, 21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Pill Badge (Node 10:4648)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      width: 33,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(16.5),
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(17, 20),
                          painter: _DuplicateDocumentPainter(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Content Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duplicate Medication',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF191C1D),
                            height: 24 / 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: const Color(0xFF494552),
                              height: 20 / 14,
                            ),
                            children: [
                              TextSpan(
                                text: '$duplicateDrug ',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF494552),
                                ),
                              ),
                              const TextSpan(
                                text:
                                    'already exists in patient history. Consider adjusting dosage instead of creating a new prescription.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CARD 3: ALLERGY CONFLICT CARD (Node 10:4656)
  // ==========================================
  Widget _buildAllergyConflictCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xD9FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Left Accent Border (4px #BA1A1A)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 4, color: const Color(0xFFBA1A1A)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 21, 21, 21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Pill Badge (Node 10:4658)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      width: 36,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(20, 20),
                          painter: _AllergyHazardPainter(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Content Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Allergy Alert + Severe badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Allergy Alert',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF191C1D),
                                  height: 24 / 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDAD6),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                allergySeverity,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF93000A),
                                  letterSpacing: 0.5,
                                  height: 16 / 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: const Color(0xFF494552),
                              height: 20 / 14,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'Patient has a documented severe allergy to ',
                              ),
                              TextSpan(
                                text: allergen,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF494552),
                                ),
                              ),
                              const TextSpan(
                                text:
                                    '. Ensure cross-reactivity is checked if prescribing cephalosporins.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM ACTIONS AREA (Node 10:4679)
  // ==========================================
  Widget _buildBottomActionsArea(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE6F8F9FA), // 90% opacity #F8F9FA
        border: const Border(
          top: BorderSide(color: Color(0xFFCBC4D4), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 17, 24, 16),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Button 1: Ignore & Proceed (Node 10:4681)
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              child: InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.prescriptionPreview);
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Ignore &\nProceed',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF28006D),
                      letterSpacing: 0.1,
                      height: 20 / 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Button 2: Edit Prescription (Node 10:4683)
            Container(
              width: 167.33,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                ),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pencil Edit Icon (Node 10:4684)
                      CustomPaint(
                        size: const Size(13.5, 13.5),
                        painter: _EditPencilPainter(),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Edit\nPrescription',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.1,
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// CUSTOM PAINTERS MATCHING EXACT FIGMA VECTORS
// =========================================================================

/// Exact amber warning triangle from Node 10:4610 (44x38)
class _AlertTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 44.0, size.height / 38.0);

    // M0 38L22 0L44 38H0V38
    final triangle = Path()
      ..moveTo(0, 38)
      ..lineTo(22, 0)
      ..lineTo(44, 38)
      ..close();

    // Inner cutout to make it hollow
    final innerCutout = Path()
      ..moveTo(6, 34)
      ..lineTo(22, 6)
      ..lineTo(38, 34)
      ..close();

    final hollowPath = Path.combine(
      PathOperation.difference,
      triangle,
      innerCutout,
    );
    canvas.drawPath(hollowPath, paint);

    // Exclamation point stem: M20 26H24V16H20V26
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(20, 16, 4, 10),
        const Radius.circular(1),
      ),
      paint,
    );

    // Exclamation point dot: circle at (22, 30) radius 2
    canvas.drawCircle(const Offset(22, 30), 2, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact pill bottle with cross icon from Node 10:4620 (14x18)
class _PillBottlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 14.0, size.height / 18.0);

    // Cap: M1 2V0H13V2H1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 0, 12, 2),
        const Radius.circular(0.5),
      ),
      paint,
    );

    // Bottle outline: M2 18 ...
    final bottle = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(0, 3, 14, 15),
          const Radius.circular(2),
        ),
      );

    // Cross: M5.5 14.5H8.5V12H11V9H8.5V6.5H5.5V9H3V12H5.5V14.5
    final cross = Path()
      ..moveTo(5.5, 14.5)
      ..lineTo(8.5, 14.5)
      ..lineTo(8.5, 12)
      ..lineTo(11, 12)
      ..lineTo(11, 9)
      ..lineTo(8.5, 9)
      ..lineTo(8.5, 6.5)
      ..lineTo(5.5, 6.5)
      ..lineTo(5.5, 9)
      ..lineTo(3, 9)
      ..lineTo(3, 12)
      ..lineTo(5.5, 12)
      ..close();

    final innerBottle = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(1.5, 4.5, 11, 12),
          const Radius.circular(1),
        ),
      );

    final hollowBottle = Path.combine(
      PathOperation.difference,
      bottle,
      innerBottle,
    );

    canvas.drawPath(hollowBottle, paint);
    canvas.drawPath(cross, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact interaction exchange arrows with exclamation mark from Node 10:4632 (34x16)
class _InteractionArrowsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF494552)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF494552)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 34.0, size.height / 16.0);

    // Left curved arrow (top left to bottom right)
    final topArrow = Path()
      ..moveTo(12, 14)
      ..arcToPoint(
        const Offset(12, 2),
        radius: const Radius.circular(6),
        clockwise: false,
      );
    canvas.drawPath(topArrow, strokePaint);

    // Arrowhead for top left: pointing down at (8, 14)
    final topHead = Path()
      ..moveTo(8, 11)
      ..lineTo(12, 15)
      ..lineTo(14, 11)
      ..close();
    canvas.drawPath(topHead, fillPaint);

    // Right curved arrow (bottom right to top left)
    final bottomArrow = Path()
      ..moveTo(22, 2)
      ..arcToPoint(
        const Offset(22, 14),
        radius: const Radius.circular(6),
        clockwise: false,
      );
    canvas.drawPath(bottomArrow, strokePaint);

    // Arrowhead for bottom right: pointing up at (26, 2)
    final bottomHead = Path()
      ..moveTo(20, 5)
      ..lineTo(22, 1)
      ..lineTo(26, 5)
      ..close();
    canvas.drawPath(bottomHead, fillPaint);

    // Center exclamation mark:
    // Stem: (17, 3) to (17, 9)
    canvas.drawLine(const Offset(17, 3), const Offset(17, 9), strokePaint);
    // Dot at (17, 12)
    canvas.drawCircle(const Offset(17, 12), 1.2, fillPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact blue recommendation info icon from Node 10:4640 (20x22)
class _InfoCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0EA5E9)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 20.0, size.height / 22.0);

    // Outer circle ring
    final outer = Path()..addOval(const Rect.fromLTWH(0, 2, 20, 20));
    final inner = Path()..addOval(const Rect.fromLTWH(2, 4, 16, 16));
    final ring = Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(ring, paint);

    // Center 'i' dot: (10, 8) radius 1.2
    canvas.drawCircle(const Offset(10, 8), 1.2, paint);

    // Center 'i' stem: (9, 11) to (11, 17)
    canvas.drawRect(const Rect.fromLTWH(9, 11, 2, 6), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact duplicate document icon from Node 10:4649 (17x20)
class _DuplicateDocumentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF0369A1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.scale(size.width / 17.0, size.height / 20.0);

    // Back document corner/lines:
    final backDoc = Path()
      ..moveTo(2, 14)
      ..lineTo(2, 2)
      ..lineTo(11, 2);
    canvas.drawPath(backDoc, strokePaint);

    // Front document rectangle with rounded corner:
    final frontDoc = RRect.fromRectAndRadius(
      const Rect.fromLTWH(5, 5, 11, 14),
      const Radius.circular(2),
    );
    canvas.drawRRect(frontDoc, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact allergy hazard biohazard/snowflake icon from Node 10:4659 (20x20)
class _AllergyHazardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF93000A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = const Color(0xFF93000A)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 20.0, size.height / 20.0);

    // 8-pointed star / cross
    final center = const Offset(10, 10);
    // Vertical line
    canvas.drawLine(const Offset(10, 2), const Offset(10, 18), paint);
    // Horizontal line
    canvas.drawLine(const Offset(2, 10), const Offset(18, 10), paint);
    // Diagonal 1
    canvas.drawLine(
      const Offset(4.34, 4.34),
      const Offset(15.66, 15.66),
      paint,
    );
    // Diagonal 2
    canvas.drawLine(
      const Offset(15.66, 4.34),
      const Offset(4.34, 15.66),
      paint,
    );

    // Center circular dot
    canvas.drawCircle(center, 1.8, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact edit pencil icon from Node 10:4685 (13.5x13.5)
class _EditPencilPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 13.5, size.height / 13.5);

    final path = Path()
      ..moveTo(1.5, 12)
      ..lineTo(2.57, 12)
      ..lineTo(9.9, 4.67)
      ..lineTo(8.83, 3.6)
      ..lineTo(1.5, 10.93)
      ..close()
      ..moveTo(0, 13.5)
      ..lineTo(0, 10.31)
      ..lineTo(9.9, 0.43)
      ..cubicTo(10.2, 0.15, 10.58, 0, 10.97, 0)
      ..cubicTo(11.36, 0, 11.74, 0.15, 12.04, 0.45)
      ..lineTo(13.07, 1.5)
      ..cubicTo(13.37, 1.8, 13.5, 2.18, 13.5, 2.55)
      ..cubicTo(13.5, 2.94, 13.33, 3.3, 13.07, 3.62)
      ..lineTo(3.19, 13.5)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
