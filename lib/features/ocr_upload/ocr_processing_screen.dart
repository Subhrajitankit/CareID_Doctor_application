import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Screen 2 — OCR Processing
/// Pixel-accurate implementation of Figma Frame: Node `10:2505` (CAREID-AIO-FIGMA)
/// "OCR Processing - AI Extraction"
class OcrProcessingScreen extends StatefulWidget {
  const OcrProcessingScreen({super.key});

  @override
  State<OcrProcessingScreen> createState() => _OcrProcessingScreenState();
}

class _OcrProcessingScreenState extends State<OcrProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  int _currentStep =
      2; // 0: detecting, 1: enhancing, 2: extracting, 3: identifying
  Timer? _stepTimer;
  Timer? _completeTimer;

  @override
  void initState() {
    super.initState();

    // 1. Scan Line vertical sweeping animation
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // 2. Real progression through OCR stages
    _stepTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          if (_currentStep < 3) {
            _currentStep++;
          }
        });
      }
    });

    // 3. Complete OCR and navigate to OCR Review
    _completeTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        _stepTimer?.cancel();
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.ocrReview,
          arguments: {
            'patientName': 'Jane Doe',
            'vaultId': 'HV-992-841-B',
            'labName': 'Quest Diagnostics',
            'testDate': '2023-10-24',
            'notes':
                'Elevated LDL cholesterol levels noted. Patient advised to modify diet and repeat lipid panel in 6 months.',
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _stepTimer?.cancel();
    _completeTimer?.cancel();
    super.dispose();
  }

  void _cancelProcessing() {
    _stepTimer?.cancel();
    _completeTimer?.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Ambient Warm Gradient Background (Node 10:2505)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.85, -0.9),
                  end: Alignment(0.85, 0.9),
                  colors: [
                    Color(0xFFFFF7ED), // Warm peach
                    Color(0xFFF5F3FF), // Soft lavender
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),

          // Main Center Content Canvas (Node 10:2506)
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
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Heading and Subtitle (Node 10:2509)
                        const Text(
                          'OCR Processing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191C1D),
                            height: 32 / 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Analyzing medical document data',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494552),
                            height: 20 / 14,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Thumbnail & Scanning Animation (Node 10:2514)
                        _buildScanningThumbnail(),
                        const SizedBox(height: 28),

                        // Progress Indicator & Steps (Node 10:2523)
                        _buildProgressIndicatorAndSteps(),
                        const SizedBox(height: 24),

                        // Cancel Action Button (Node 10:2557)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _cancelProcessing,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF7A7583)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel Processing',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF191C1D),
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top App Bar (Node 10:2560)
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

  // --- TOP APP BAR (Figma Node 10:2560) ---
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button (Node 10:2562)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: _cancelProcessing,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Color(0xFF28006D),
                    ),
                  ),
                ),
              ),

              // Title: "Care ID Scanner" (Node 10:2566)
              const Expanded(
                child: Center(
                  child: Text(
                    'Care ID Scanner',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF28006D),
                      height: 28 / 18,
                    ),
                  ),
                ),
              ),

              // Notifications Icon (Node 10:2567)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.notificationCenter,
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: 22,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- THUMBNAIL & SCANNING ANIMATION (Figma Node 10:2514) ---
  Widget _buildScanningThumbnail() {
    return Container(
      width: 192,
      height: 256,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBC4D4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Document Image (Node 10:2516)
            Image.asset(
              'assets/images/ocr_thumbnail.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFF3F4F5),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: const Color(0xFF494552).withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBC4D4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBC4D4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Purple Tint Overlay (Node 10:2517)
            Container(color: const Color(0xFF28006D).withValues(alpha: 0.1)),

            // Reticle Corners: 4 purple corner brackets (Node 10:2518 - 10:2521)
            const Positioned(
              left: 8,
              top: 8,
              child: _ReticleCorner(isTop: true, isLeft: true),
            ),
            const Positioned(
              right: 8,
              top: 8,
              child: _ReticleCorner(isTop: true, isLeft: false),
            ),
            const Positioned(
              left: 8,
              bottom: 8,
              child: _ReticleCorner(isTop: false, isLeft: true),
            ),
            const Positioned(
              right: 8,
              bottom: 8,
              child: _ReticleCorner(isTop: false, isLeft: false),
            ),

            // Animated Laser Scan Line (Node 10:2522)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Positioned(
                  top: _scanAnimation.value * (256 - 4),
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      color: Color(0xFF28006D),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xCC28006D),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- PROGRESS INDICATOR & STEPS (Figma Node 10:2523) ---
  Widget _buildProgressIndicatorAndSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular Progress Ring (Node 10:2525)
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF28006D)),
                  backgroundColor: Color(0xFFE1E3E4),
                ),
              ),
              const Icon(
                Icons.auto_awesome_rounded,
                size: 22,
                color: Color(0xFF28006D),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Steps Checklist (Node 10:2533)
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepRow(
                text: 'Detecting document',
                state: _currentStep >= 1
                    ? _StepState.completed
                    : _StepState.active,
              ),
              const SizedBox(height: 8),
              _buildStepRow(
                text: 'Enhancing image',
                state: _currentStep >= 2
                    ? _StepState.completed
                    : (_currentStep == 1
                          ? _StepState.active
                          : _StepState.pending),
              ),
              const SizedBox(height: 8),
              _buildStepRow(
                text: 'Extracting text...',
                state: _currentStep >= 3
                    ? _StepState.completed
                    : (_currentStep == 2
                          ? _StepState.active
                          : _StepState.pending),
              ),
              const SizedBox(height: 8),
              _buildStepRow(
                text: 'Identifying fields',
                state: _currentStep >= 3
                    ? _StepState.active
                    : _StepState.pending,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow({required String text, required _StepState state}) {
    Widget iconWidget;
    TextStyle textStyle;

    switch (state) {
      case _StepState.completed:
        iconWidget = const Icon(
          Icons.check_circle_rounded,
          size: 16,
          color: Color(0xFF28006D),
        );
        textStyle = const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF28006D),
          letterSpacing: 0.1,
        );
        break;
      case _StepState.active:
        iconWidget = const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF28006D)),
          ),
        );
        textStyle = const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191C1D),
          letterSpacing: 0.1,
        );
        break;
      case _StepState.pending:
        iconWidget = const Icon(
          Icons.radio_button_unchecked_rounded,
          size: 16,
          color: Color(0xFFCBC4D4),
        );
        textStyle = const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFCBC4D4),
          letterSpacing: 0.1,
        );
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 18, child: Center(child: iconWidget)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text, style: textStyle, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

enum _StepState { completed, active, pending }

class _ReticleCorner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _ReticleCorner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Color(0xFF28006D), width: 2)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Color(0xFF28006D), width: 2)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Color(0xFF28006D), width: 2)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Color(0xFF28006D), width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}
