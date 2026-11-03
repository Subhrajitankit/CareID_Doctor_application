import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Screen 3 — OCR Review
/// Pixel-accurate implementation of Figma Frame: Node `10:2728` (CAREID-AIO-FIGMA)
/// "OCR Review & Field Verification"
class OcrReviewScreen extends StatefulWidget {
  const OcrReviewScreen({super.key});

  @override
  State<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends State<OcrReviewScreen> {
  late TextEditingController _patientNameController;
  late TextEditingController _vaultIdController;
  late TextEditingController _labNameController;
  late TextEditingController _testDateController;
  late TextEditingController _notesController;

  bool _isEditingEnabled = true;
  double _zoomScale = 1.0;

  @override
  void initState() {
    super.initState();
    _patientNameController = TextEditingController(text: 'Jane Doe');
    _vaultIdController = TextEditingController(text: 'HV-992-841-B');
    _labNameController = TextEditingController(text: 'Quest Diagnostics');
    _testDateController = TextEditingController(text: '2023-10-24');
    _notesController = TextEditingController(
      text:
          'Elevated LDL cholesterol levels noted. Patient advised to modify diet and repeat lipid panel in 6 months.',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      if (args['patientName'] != null) {
        _patientNameController.text = args['patientName'];
      }
      if (args['vaultId'] != null) {
        _vaultIdController.text = args['vaultId'];
      }
      if (args['labName'] != null) {
        _labNameController.text = args['labName'];
      }
      if (args['testDate'] != null) {
        _testDateController.text = args['testDate'];
      }
      if (args['notes'] != null) {
        _notesController.text = args['notes'];
      }
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _vaultIdController.dispose();
    _labNameController.dispose();
    _testDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onApproveAll() {
    Navigator.pushNamed(
      context,
      AppRoutes.uploadSuccess,
      arguments: {
        'patientName': _patientNameController.text,
        'vaultId': _vaultIdController.text,
        'labName': _labNameController.text,
        'testDate': _testDateController.text,
        'notes': _notesController.text,
      },
    );
  }

  void _onEditFields() {
    setState(() {
      _isEditingEnabled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Field editing enabled. You can modify any extracted value.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      if (_zoomScale < 2.0) _zoomScale += 0.25;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomScale > 0.75) _zoomScale -= 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Content Layout
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Spacer for Top App Bar
                  const SizedBox(height: 64),

                  // Top Half: Scanned Document Preview (Node 10:2730)
                  _buildDocumentPreviewSection(),

                  // Bottom Half: Scrollable Extracted Data Form (Node 10:2741)
                  Expanded(child: _buildExtractedDataFormSection()),

                  // Action Buttons Footer (Node 10:2795)
                  _buildActionButtonsFooter(),
                ],
              ),
            ),
          ),

          // Top App Bar (Node 10:2801)
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

  // --- TOP APP BAR (Figma Node 10:2801) ---
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
              // Back Button (Node 10:2803)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () => Navigator.maybePop(context),
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

              // Title: "Review Extraction" (Node 10:2807)
              const Expanded(
                child: Center(
                  child: Text(
                    'Review Extraction',
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

              // Notifications Icon (Node 10:2808)
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

  // --- TOP HALF: DOCUMENT PREVIEW (Figma Node 10:2730) ---
  Widget _buildDocumentPreviewSection() {
    return Container(
      height: 240,
      width: double.infinity,
      color: const Color(0xFFEDEEEF),
      child: Stack(
        children: [
          // Document Preview Card Container (Node 10:2731)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 2.5,
                    child: Transform.scale(
                      scale: _zoomScale,
                      child: Center(
                        child: Image.asset(
                          'assets/images/ocr_document_preview.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  size: 48,
                                  color: Color(0xFF7A7583),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Scanned Lab Document Preview',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 13,
                                    color: const Color(
                                      0xFF494552,
                                    ).withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Zoom In / Zoom Out Floating Controls (Node 10:2734)
          Positioned(
            top: 24,
            right: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildZoomButton(icon: Icons.zoom_in_rounded, onTap: _zoomIn),
                const SizedBox(width: 8),
                _buildZoomButton(icon: Icons.zoom_out_rounded, onTap: _zoomOut),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: onTap,
          child: Icon(icon, size: 18, color: const Color(0xFF28006D)),
        ),
      ),
    );
  }

  // --- BOTTOM HALF: EXTRACTED DATA FORM (Figma Node 10:2741) ---
  Widget _buildExtractedDataFormSection() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header: "Extracted Data" + "Auto-extracted" pill badge (Node 10:2743)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Extracted Data',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                      height: 28 / 20,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F1D8B),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 13,
                        color: Color(0xFFAB8EFD),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Auto-extracted',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFAB8EFD),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Field 1: Patient Name (Node 10:2751) - High confidence
            _buildExtractedField(
              label: 'Patient Name',
              matchText: '98% Match',
              matchColor: const Color(0xFF006971),
              controller: _patientNameController,
            ),
            const SizedBox(height: 18),

            // Field 2: CareID Vault (Node 10:2759) - High confidence
            _buildExtractedField(
              label: 'CareID Vault',
              matchText: '99% Match',
              matchColor: const Color(0xFF006971),
              controller: _vaultIdController,
            ),
            const SizedBox(height: 18),

            // Field 3: Laboratory Name (Node 10:2767) - Low confidence warning
            _buildExtractedField(
              label: 'Laboratory Name',
              matchText: '65% Match',
              matchColor: const Color(0xFFB3261E),
              controller: _labNameController,
              isWarning: true,
            ),
            const SizedBox(height: 18),

            // Field 4: Test Date (Node 10:2779) - Medium confidence
            _buildExtractedField(
              label: 'Test Date',
              matchText: '82% Match',
              matchColor: const Color(0xFFA46000),
              controller: _testDateController,
              borderColor: const Color(0xFFA46000),
            ),
            const SizedBox(height: 18),

            // Field 5: Extracted Diagnosis / Notes (Node 10:2787)
            _buildExtractedField(
              label: 'Extracted Diagnosis/Notes',
              matchText: '91% Match',
              matchColor: const Color(0xFF006971),
              controller: _notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedField({
    required String label,
    required String matchText,
    required Color matchColor,
    required TextEditingController controller,
    bool isWarning = false,
    Color? borderColor,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label & Match Confidence Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF494552),
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isWarning) ...[
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: Color(0xFFB3261E),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  matchText,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: matchColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Text Input Field Container
        Container(
          decoration: BoxDecoration(
            color: isWarning ? const Color(0xFFFCEDEC) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isWarning
                  ? const Color(0xFFB3261E)
                  : (borderColor ?? const Color(0xFF7A7583)),
              width: isWarning ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: _isEditingEnabled,
                  maxLines: maxLines,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF191C1D),
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (isWarning)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 20,
                    color: Color(0xFFB3261E),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // --- ACTION BUTTONS FOOTER (Figma Node 10:2795) ---
  Widget _buildActionButtonsFooter() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(top: BorderSide(color: Color(0xFFCBC4D4), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Button 1: Edit Fields (Node 10:2797)
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _onEditFields,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF7A7583)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Edit Fields',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF28006D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Button 2: Approve All (Node 10:2799)
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onApproveAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28006D),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Approve All',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
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
}
