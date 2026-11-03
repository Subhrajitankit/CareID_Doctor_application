import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Screen 4 — Report Upload Success
/// Pixel-accurate implementation of Figma Frame: Node `10:2811` (CAREID-AIO-FIGMA)
/// "Report Upload Success"
class ReportUploadSuccessScreen extends StatelessWidget {
  const ReportUploadSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Ambient Warm Gradient Background (Node 10:2811)
          // linear-gradient(113.8deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.85, -0.9),
                  end: Alignment(0.85, 0.9),
                  colors: [
                    Color(0xFFFFF7ED), // Warm peach rgb(255, 247, 237)
                    Color(0xFFF5F3FF), // Soft lavender rgb(245, 243, 255)
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),

          // Main Center Content Canvas (Node 10:2812)
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 448),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Space under TopAppBar (64px)
                        const SizedBox(height: 32),

                        // Illustration Area:margin (Node 10:2813 / 10:2814)
                        _buildSuccessIllustration(),
                        const SizedBox(height: 32),

                        // Success Text (Node 10:2827)
                        Container(
                          width: 336.44,
                          constraints: const BoxConstraints(maxWidth: 448),
                          child: Column(
                            children: const [
                              // Heading 2 (Node 10:2828 / 10:2829)
                              Text(
                                'Upload Successful',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF191C1D),
                                  height: 32 / 24,
                                ),
                              ),
                              SizedBox(height: 8),

                              // Subtitle Container (Node 10:2830 / 10:2831)
                              Text(
                                'Document successfully verified and saved to\nPatient Record.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF494552),
                                  height: 24 / 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action Buttons:margin (Node 10:2832 / 10:2833)
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Header - TopAppBar (Node 10:2838)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopAppBar(context),
          ),
        ],
      ),
    );
  }

  // --- HEADER - TOP APP BAR (Figma Node 10:2838) ---
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(bottom: BorderSide(color: Color(0xFFCBC4D4), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Button - Close:margin (Node 10:2840 / 10:2841 / 10:2842)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.dashboard,
                    (r) => false,
                  ),
                  child: Container(
                    width: 32.02,
                    height: 46,
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: const Size(14, 14),
                      painter: const _FigmaCloseIconPainter(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Heading 1: "Upload Complete" (Node 10:2844 / 10:2845)
              const Expanded(
                child: Text(
                  'Upload Complete',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF28006D),
                    height: 28 / 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ILLUSTRATION AREA (Figma Node 10:2814) ---
  Widget _buildSuccessIllustration() {
    return SizedBox(
      width: 280,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background Decoration Glow (Node 10:2815)
          // absolute bg-[rgba(207,189,255,0.2)] blur-[32px] inset-0 rounded-[9999px]
          Center(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x33CFBDFF), // rgba(207,189,255,0.2)
                ),
              ),
            ),
          ),

          // Document Icon Card (Node 10:2816)
          // w-[128px] h-[160px] bg-[#f8f9fa] border border-[#e1e3e4] rounded-[12px]
          Center(
            child: Container(
              width: 128,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Document Folded Vector Icon (Node 10:2817)
                  CustomPaint(
                    size: const Size(40, 50),
                    painter: const _FigmaDocIconPainter(),
                  ),
                  const SizedBox(height: 16),

                  // Subtle text lines: Line 1 (Node 10:2820)
                  Container(
                    width: 64,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E3E4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtle text lines: Line 2 (Node 10:2822)
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E3E4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Verification Badge Overlay (Node 10:2823)
          // size-[64px] bg-[#006971] border-4 border-[#f8f9fa] rounded-[9999px]
          // bottom-[32px] right-[-16px] relative to 128px doc card
          Positioned(
            right:
                48, // (280 - 128)/2 - 16 = 76 - 16 = 60 from center, or 48 from stack right
            bottom: 12,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF006971),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF8F9FA), width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    spreadRadius: -3,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    spreadRadius: -4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: CustomPaint(
                size: const Size(25, 25),
                painter: const _FigmaCheckBadgePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ACTION BUTTONS (Figma Node 10:2833) ---
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary Button: "Return to Patient Profile" (Node 10:2834 / 10:2835)
        // h-[44px] bg-gradient-to-b from-[#a44cff] to-[#5b14b8] rounded-[9999px]
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33A44CFF),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboard,
                  (r) => false,
                );
              },
              child: const Center(
                child: Text(
                  'Return to Patient Profile',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // Figma Medium
                    color: Colors.white,
                    letterSpacing: 0.1,
                    height: 20 / 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16), // Figma gap-[16px]
        // Secondary Button: "Upload Another" (Node 10:2836 / 10:2837)
        // border border-[#28006d] rounded-[9999px] px-[25px] py-[13px]
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.uploadCenter);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF28006D), width: 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            child: const Text(
              'Upload Another',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500, // Figma Medium
                color: Color(0xFF28006D),
                letterSpacing: 0.1,
                height: 20 / 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// EXACT FIGMA VECTOR PAINTERS
// ==========================================

/// Exact vector close icon from Figma Node `10:2842` (14x14px, fill #494552)
class _FigmaCloseIconPainter extends CustomPainter {
  const _FigmaCloseIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF494552)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 14.0, size.height / 14.0);
    // SVG path: M1.4 14L0 12.6L5.6 7L0 1.4L1.4 0L7 5.6L12.6 0L14 1.4L8.4 7L14 12.6L12.6 14L7 8.4L1.4 14V14
    final path = Path()
      ..moveTo(1.4, 14)
      ..lineTo(0, 12.6)
      ..lineTo(5.6, 7)
      ..lineTo(0, 1.4)
      ..lineTo(1.4, 0)
      ..lineTo(7, 5.6)
      ..lineTo(12.6, 0)
      ..lineTo(14, 1.4)
      ..lineTo(8.4, 7)
      ..lineTo(14, 12.6)
      ..lineTo(12.6, 14)
      ..lineTo(7, 8.4)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact vector folded document icon from Figma Node `10:2817` (40x50px, fill #7A7583)
class _FigmaDocIconPainter extends CustomPainter {
  const _FigmaDocIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7A7583)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 40.0, size.height / 50.0);

    // SVG path data from Figma Node 10:2817
    final path = Path();

    // Text bar 1: x=10..30, y=35..40
    path.addRect(const Rect.fromLTWH(10, 35, 20, 5));

    // Text bar 2: x=10..30, y=25..30
    path.addRect(const Rect.fromLTWH(10, 25, 20, 5));

    // Document outline with folded corner and rounded base:
    // Outer bounds: (0, 0) to (40, 50)
    final docOutline = Path()
      ..moveTo(5, 50)
      ..cubicTo(3.625, 50, 2.448, 49.51, 1.469, 48.531)
      ..cubicTo(0.49, 47.552, 0, 46.375, 0, 45)
      ..lineTo(0, 5)
      ..cubicTo(0, 3.625, 0.49, 2.448, 1.469, 1.469)
      ..cubicTo(2.448, 0.49, 3.625, 0, 5, 0)
      ..lineTo(25, 0)
      ..lineTo(40, 15)
      ..lineTo(40, 45)
      ..cubicTo(40, 46.375, 39.51, 47.552, 38.531, 48.531)
      ..cubicTo(37.552, 49.51, 36.375, 50, 35, 50)
      ..close();

    // Inner cutout to make it hollow / line style like Figma
    final innerCutout = Path()
      ..moveTo(5, 5)
      ..lineTo(22.5, 5)
      ..lineTo(22.5, 17.5)
      ..lineTo(35, 17.5)
      ..lineTo(35, 45)
      ..lineTo(5, 45)
      ..close();

    final paperFrame = Path.combine(
      PathOperation.difference,
      docOutline,
      innerCutout,
    );
    path.addPath(paperFrame, Offset.zero);

    // Corner fold flap
    final foldFlap = Path()
      ..moveTo(22.5, 5)
      ..lineTo(35, 17.5)
      ..lineTo(22.5, 17.5)
      ..close();
    path.addPath(foldFlap, Offset.zero);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Exact vector check badge icon from Figma Node `10:2825` (25x25px)
/// Draws a solid white circular disc with the checkmark cut out so the teal badge shows through.
class _FigmaCheckBadgePainter extends CustomPainter {
  const _FigmaCheckBadgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(size.width / 25.0, size.height / 25.0);

    // Using evenOdd rule to create the cut-out checkmark inside the white circle
    final path = Path()
      ..fillType = PathFillType.evenOdd
      // Outer circular disc of radius 12.5 centered at (12.5, 12.5)
      ..addOval(Rect.fromCircle(center: const Offset(12.5, 12.5), radius: 12.5))
      // Checkmark cutout from Figma path:
      // M10.75 18.25L19.5625 9.4375L17.8125 7.6875L10.75 14.75L7.1875 11.1875L5.4375 12.9375L10.75 18.25
      ..moveTo(10.75, 18.25)
      ..lineTo(19.5625, 9.4375)
      ..lineTo(17.8125, 7.6875)
      ..lineTo(10.75, 14.75)
      ..lineTo(7.1875, 11.1875)
      ..lineTo(5.4375, 12.9375)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
