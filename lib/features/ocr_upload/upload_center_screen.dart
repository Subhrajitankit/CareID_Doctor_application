import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Screen 1 — Upload Center
/// Pixel-accurate implementation of Figma Frame: Node `10:2570` (CAREID-AIO-FIGMA)
/// "Upload Center - Medical Reports"
class UploadCenterScreen extends StatefulWidget {
  const UploadCenterScreen({super.key});

  @override
  State<UploadCenterScreen> createState() => _UploadCenterScreenState();
}

class _UploadCenterScreenState extends State<UploadCenterScreen> {
  final String _patientName = 'John Doe';
  final String _patientId = 'ID: HV-9824 • DOB: 12/05/1980';
  final String _patientInitials = 'JD';

  void _startOcrWorkflow(String documentType) {
    Navigator.pushNamed(
      context,
      AppRoutes.ocrProcessing,
      arguments: {
        'documentType': documentType,
        'patientName': _patientName,
        'patientId': _patientId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Ambient Background Gradient (Node 10:2570)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.85, -0.9),
                  end: Alignment(0.85, 0.9),
                  colors: [
                    Color(0xFFFFF7ED), // rgb(255, 247, 237)
                    Color(0xFFF5F3FF), // rgb(245, 243, 255)
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),

          // Scrollable Content Canvas
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 72, // Below TopAppBar
                  bottom: 110, // Above floating bottom nav
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Patient Context Card (Node 10:2573)
                    _buildPatientContextCard(),
                    const SizedBox(height: 24),

                    // 2. Select Upload Method Section (Node 10:2584)
                    _buildUploadMethodsSection(),
                    const SizedBox(height: 24),

                    // 3. Supported Document Types Info Box (Node 10:2621)
                    _buildSupportedFormatsInfoBox(),
                    const SizedBox(height: 24),

                    // 4. Recent Uploads Section (Node 10:2633)
                    _buildRecentUploadsSection(),
                  ],
                ),
              ),
            ),
          ),

          // Top App Bar (Node 10:2694)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopAppBar(context),
          ),

          // Bottom Navigation Shell (Node 10:2703)
          Positioned(
            bottom: 22,
            left: 20,
            right: 20,
            child: _buildBottomNavShell(context),
          ),
        ],
      ),
    );
  }

  // --- TOP APP BAR (Figma Node 10:2694) ---
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
              // Back Button (Node 10:2695)
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

              // Title: "Upload Health Report" (Node 10:2699)
              const Expanded(
                child: Center(
                  child: Text(
                    'Upload Health Report',
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

              // Notifications Icon (Node 10:2700)
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

  // --- PATIENT CONTEXT CARD (Figma Node 10:2573) ---
  Widget _buildPatientContextCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFCBC4D4).withValues(alpha: 0.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Initials circle (Node 10:2575)
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF3F1D8B),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _patientInitials,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFAB8EFD),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name and ID details (Node 10:2577)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _patientName,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 24 / 16,
                  ),
                ),
                Text(
                  _patientId,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 18 / 13,
                  ),
                ),
              ],
            ),
          ),

          // Change Patient Button (Node 10:2582)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient context: John Doe (HV-9824)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Change\nPatient',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF28006D),
                  height: 16 / 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UPLOAD METHODS SECTION (Figma Node 10:2584) ---
  Widget _buildUploadMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Upload Method',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 14),

        // Method 1: Scan with Camera (Node 10:2588)
        _buildUploadMethodCard(
          title: 'Scan with Camera',
          subtitle: 'Best for physical documents',
          icon: Icons.camera_alt_outlined,
          onTap: () => _startOcrWorkflow('Camera Scan'),
        ),
        const SizedBox(height: 12),

        // Method 2: Upload from Gallery (Node 10:2599)
        _buildUploadMethodCard(
          title: 'Upload from Gallery',
          subtitle: 'JPG, PNG images',
          icon: Icons.photo_library_outlined,
          onTap: () => _startOcrWorkflow('Gallery Image'),
        ),
        const SizedBox(height: 12),

        // Method 3: Import PDF (Node 10:2610)
        _buildUploadMethodCard(
          title: 'Import PDF',
          subtitle: 'Digital reports & files',
          icon: Icons.picture_as_pdf_outlined,
          onTap: () => _startOcrWorkflow('PDF Document'),
        ),
      ],
    );
  }

  Widget _buildUploadMethodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBC4D4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular icon background (Node 10:2590)
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE1E3E4),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 28, color: const Color(0xFF28006D)),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 24 / 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 18 / 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- SUPPORTED FORMATS INFO BOX (Figma Node 10:2621) ---
  Widget _buildSupportedFormatsInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFCBC4D4).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 22,
            color: Color(0xFF494552),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Supported Document Types',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    letterSpacing: 0.1,
                    height: 20 / 14,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF494552),
                      height: 18 / 13,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'We accept Lab Reports, Radiology findings, and Prescriptions in ',
                      ),
                      TextSpan(
                        text: 'JPG, PNG, and PDF',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ' formats (Max 10MB per file).'),
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

  // --- RECENT UPLOADS SECTION (Figma Node 10:2633) ---
  Widget _buildRecentUploadsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Uploads',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1D),
                height: 24 / 16,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.medicalRecords);
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF28006D),
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // List Container (Node 10:2639)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFCBC4D4).withValues(alpha: 0.5),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Item 1: CBC Blood Test Panel (Node 10:2640)
              _buildRecentUploadItem(
                title: 'CBC Blood Test Panel',
                subtitle: 'Today, 09:42 AM • PDF (2.4 MB)',
                icon: Icons.biotech_outlined,
                iconBg: const Color(0xFF006971).withValues(alpha: 0.1),
                iconColor: const Color(0xFF006971),
                isVerified: true,
                isProcessing: false,
                isLast: false,
              ),

              // Item 2: Chest X-Ray Scan (Node 10:2658)
              _buildRecentUploadItem(
                title: 'Chest X-Ray Scan',
                subtitle: 'Yesterday, 14:15 PM • JPG (4.1 MB)',
                icon: Icons.personal_injury_outlined,
                iconBg: const Color(0xFF28006D).withValues(alpha: 0.1),
                iconColor: const Color(0xFF28006D),
                isVerified: false,
                isProcessing: true,
                isLast: false,
              ),

              // Item 3: External Prescription (Node 10:2676)
              _buildRecentUploadItem(
                title: 'External Prescription',
                subtitle: 'Oct 12, 11:30 AM • PNG (1.2 MB)',
                icon: Icons.medication_outlined,
                iconBg: const Color(0xFFE1E3E4),
                iconColor: const Color(0xFF494552),
                isVerified: true,
                isProcessing: false,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentUploadItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required bool isVerified,
    required bool isProcessing,
    required bool isLast,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: const Color(0xFFCBC4D4).withValues(alpha: 0.5),
                ),
              ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon Container (Node 10:2642)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),

          // Titles (Node 10:2645)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          if (isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 13,
                    color: Color(0xFF1B5E20),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1B5E20),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          if (isProcessing)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timelapse_rounded,
                    size: 13,
                    color: Color(0xFFE65100),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Processing',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE65100),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(width: 6),
          // 3-dots Menu
          const Icon(
            Icons.more_vert_rounded,
            size: 18,
            color: Color(0xFF7A7583),
          ),
        ],
      ),
    );
  }

  // --- FLOATING BOTTOM NAVIGATION SHELL (Figma Node 10:2703) ---
  Widget _buildBottomNavShell(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: const Color(0xFFCBC4D4).withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home
          _buildBottomNavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: false,
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.dashboard,
              (r) => false,
            ),
          ),

          // Patients
          _buildBottomNavItem(
            icon: Icons.people_outline_rounded,
            label: 'Patients',
            isActive: false,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.patientDirectory),
          ),

          // Center Scan / Action Button (Node 10:2715)
          GestureDetector(
            onTap: () => _startOcrWorkflow('Camera Scan'),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF5B14B8),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF8F9FF), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x335B14B8),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.document_scanner_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),

          // Schedule
          _buildBottomNavItem(
            icon: Icons.calendar_today_outlined,
            label: 'Schedule',
            isActive: false,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.appointmentsOverview),
          ),

          // Profile
          _buildBottomNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: false,
            onTap: () => Navigator.pushNamed(context, AppRoutes.doctorProfile),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? const Color(0xFF006D76) : const Color(0xFF494552);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(9999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
