import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Referral Details Screen
///
/// Pixel-accurate implementation of Figma Frame: Node `10:3572` (CAREID-AIO-FIGMA)
/// "Referral Details - Refined Navigation"
class ReferralDetailsScreen extends StatefulWidget {
  final ReferralItem? referralArg;

  const ReferralDetailsScreen({super.key, this.referralArg});

  @override
  State<ReferralDetailsScreen> createState() => _ReferralDetailsScreenState();
}

class _ReferralDetailsScreenState extends State<ReferralDetailsScreen> {
  late ReferralItem _referral;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _referral =
        widget.referralArg ??
        (ModalRoute.of(context)?.settings.arguments as ReferralItem?) ??
        MockData.referrals[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FE),
      body: Stack(
        children: [
          // Background Gradient (Figma linear-gradient(99.13deg, #FFF7ED 0%, #F5F3FF 50%))
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF), Colors.white],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // TopAppBar (Figma Node 10:3616 & 10:3611)
                  _buildTopAppBar(context),

                  // Scrollable Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24,
                        bottom: 180, // Space for Sticky Actions & Bottom Nav
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Status & Priority Banner (Node 10:3623)
                          _buildStatusAndPriorityBanner(),
                          const SizedBox(height: 24),

                          // 2. Patient Summary Card (Node 10:3639)
                          _buildPatientSummaryCard(context),
                          const SizedBox(height: 24),

                          // 3. Clinical Justification & Notes (Node 10:3668)
                          _buildClinicalNotesSection(context),
                          const SizedBox(height: 24),

                          // 4. Routing Network (Node 10:3707)
                          _buildRoutingNetworkSection(),
                          const SizedBox(height: 24),

                          // 5. Activity Timeline (Node 10:3735)
                          _buildActivityTimelineSection(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Actions (Figma Node 10:3602)
          Positioned(
            left: 0,
            right: 0,
            bottom: 80, // Sits directly above bottom navigation bar
            child: _buildStickyActions(context),
          ),

          // Floating Bottom Navigation Shell (Figma Node 10:3573)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavShell(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TopAppBar (Figma Nodes 10:3616 and 10:3611)
  // Shared Header:
  //   - Top bar: CareID logo in center, Doctor Avatar on right
  //   - Sub-bar: Back button + "Referral Details" (24px Bold #191C1D)
  // ---------------------------------------------------------------------------
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Logo & Avatar (Node 10:3616)
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: const Color(0xFFF8F9FA),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Balance doctor avatar
                // Center: CareID Logo - 98px x 22.05px
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'assets/images/careid_appbar_clean.png',
                    width: 98,
                    height: 22.05,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Text(
                      'CAREiD',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF28006D),
                      ),
                    ),
                  ),
                ),

                // Right: Doctor Profile Avatar - 40px circle
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.doctorProfile);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0x4DCBC4D4),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/doctor_avatar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFFE1E3E4),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person,
                            size: 24,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sub-bar: Back Arrow + "Referral Details" (Node 10:3611)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  key: const Key('referral_details_back_button'),
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.only(right: 12),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Referral Details',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                      height: 1.33,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Status & Priority Banner (Figma Node 10:3623)
  // White card, border #E1E3E4, radius 12px, shadow 0px 2px 4px rgba(0,0,0,0.05)
  //   - REFERRAL STATUS: "Accepted - Awaiting Scheduling" with teal check icon
  //   - CLINICAL PRIORITY: Maroon capsule (#74001E) + coral text "HIGH - Urgent Consult"
  // ---------------------------------------------------------------------------
  Widget _buildStatusAndPriorityBanner() {
    final statusText = _referral.status.toLowerCase().contains('accept')
        ? 'Accepted - Awaiting Scheduling'
        : _referral.status.toLowerCase().contains('complete')
        ? 'Completed - Visit Concluded'
        : '${_referral.status} - Awaiting Scheduling';

    final isHighPriority =
        _referral.urgency == 'Critical' ||
        _referral.urgency == 'Urgent' ||
        _referral.urgency.isEmpty;

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Referral Status
          const Text(
            'REFERRAL STATUS',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF494552),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: Color(0xFF006971),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusText,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006971),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Clinical Priority
          const Text(
            'CLINICAL PRIORITY',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF494552),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isHighPriority
                  ? const Color(0xFF74001E)
                  : const Color(0xFF00373C),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isHighPriority
                      ? Icons.warning_amber_rounded
                      : Icons.calendar_today_rounded,
                  size: 13,
                  color: isHighPriority
                      ? const Color(0xFFFF7380)
                      : const Color(0xFF76F1FF),
                ),
                const SizedBox(width: 4),
                Text(
                  isHighPriority
                      ? 'HIGH - Urgent Consult'
                      : 'ROUTINE - Standard Consult',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isHighPriority
                        ? const Color(0xFFFF7380)
                        : const Color(0xFF76F1FF),
                    letterSpacing: 0.5,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Patient Summary Card (Figma Node 10:3639)
  // Header: Patient Icon + "Patient Summary" (20px SemiBold #28006D)
  // Body:
  //   - 64x64 Circle Avatar
  //   - Full Name: Robert J. Thorne (or dynamic referral patient name)
  //   - MRN / Patient ID: HV-8849-201A (or dynamic careId)
  //   - DOB & Age: 14 Mar 1954 (69 yo) (or dynamic age)
  //   - Primary Contact: +1 (555) 234-9988
  // ---------------------------------------------------------------------------
  Widget _buildPatientSummaryCard(BuildContext context) {
    final patient = _referral.patient;
    final patientName = patient.name.isNotEmpty
        ? patient.name
        : 'Robert J. Thorne';
    final patientId = patient.careId.isNotEmpty
        ? patient.careId
        : 'HV-8849-201A';
    final patientAgeText = patient.age > 0
        ? '14 Mar 1954 (${patient.age} yo)'
        : '14 Mar 1954 (69 yo)';

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bottom divider
          Container(
            padding: const EdgeInsets.only(bottom: 9),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEDEEEF), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: Color(0xFF28006D),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Patient Summary',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF28006D),
                      height: 1.4,
                    ),
                  ),
                ),
                // Preserving navigation to Patient Medical Chart
                GestureDetector(
                  key: const Key('referral_details_view_chart_button'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.patientProfile,
                      arguments: _referral.patient,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'View Chart',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5B14B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Patient Avatar (64x64 Circle)
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE1E3E4),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/doctor_avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFF3F1D8B),
                  alignment: Alignment.center,
                  child: Text(
                    patientName.isNotEmpty
                        ? patientName.substring(0, 1).toUpperCase()
                        : 'P',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFAB8EFD),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Details List
          _buildInfoItem('Full Name', patientName, isMedium: true),
          const SizedBox(height: 16),
          _buildInfoItem('MRN / Patient ID', patientId),
          const SizedBox(height: 16),
          _buildInfoItem('DOB & Age', patientAgeText),
          const SizedBox(height: 16),
          _buildInfoItem('Primary Contact', '+1 (555) 234-9988'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isMedium = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7A7583),
            letterSpacing: 0.5,
            height: 1.33,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: isMedium ? FontWeight.w500 : FontWeight.w400,
            color: const Color(0xFF191C1D),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Clinical Justification & Notes (Figma Node 10:3668)
  // Header: Document Icon + "Clinical Justification & Notes" (20px SemiBold #28006D)
  //   - Diagnosis / Reason
  //   - Referring Physician Notes (box with #F8F9FA, border #EDEEEF)
  //   - Attached Clinical Documents (Doc Card 1 & Doc Card 2)
  // ---------------------------------------------------------------------------
  Widget _buildClinicalNotesSection(BuildContext context) {
    final reasonText = _referral.reason.isNotEmpty
        ? _referral.reason
        : 'Suspected Coronary Artery Disease - Exertional Angina';

    final notesText =
        _referral.clinicalNotes.isNotEmpty &&
            _referral.clinicalNotes.length > 50
        ? _referral.clinicalNotes
        : 'Patient presents with increasing frequency of chest tightness upon exertion, radiating to the left jaw. Symptoms are relieved by rest within 5 minutes.\n\nRecent ECG showed non-specific ST-T wave changes. Stress test indicated possible ischemia in the inferior wall.\n\nRequesting formal cardiology consult and possible angiography evaluation. Patient has history of hypertension and hyperlipidemia, currently managed on Amlodipine and Atorvastatin.';

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bottom divider
          Container(
            padding: const EdgeInsets.only(bottom: 9),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEDEEEF), width: 1),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 20,
                  color: Color(0xFF28006D),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Clinical Justification &\nNotes',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF28006D),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Diagnosis / Reason
          const Text(
            'Diagnosis / Reason',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7583),
              letterSpacing: 0.5,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reasonText,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Referring Physician Notes
          const Text(
            'Referring Physician Notes',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7583),
              letterSpacing: 0.5,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEDEEEF), width: 1),
            ),
            child: Text(
              notesText,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
                height: 1.625,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Attached Clinical Documents
          const Text(
            'Attached Clinical Documents',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7583),
              letterSpacing: 0.5,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 12),

          // Doc Card 1: Recent_ECG_Results.pdf (Node 10:3688)
          _buildDocumentCard(
            context,
            icon: Icons.description_outlined,
            iconBg: const Color(0x1A28006D), // rgba(40,0,109,0.1)
            iconColor: const Color(0xFF28006D),
            fileName: 'Recent_ECG_Results.pdf',
            fileMeta: 'Oct 12, 2023 • 1.2 MB',
          ),
          const SizedBox(height: 12),

          // Doc Card 2: Lipid_Panel_Sep.pdf (Node 10:3697)
          _buildDocumentCard(
            context,
            icon: Icons.science_outlined,
            iconBg: const Color(0x1A006971), // rgba(0,105,113,0.1)
            iconColor: const Color(0xFF006971),
            fileName: 'Lipid_Panel_Sep.pdf',
            fileMeta: 'Sep 28, 2023 • 0.8 MB',
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String fileName,
    required String fileMeta,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $fileName in secure document viewer...'),
            duration: const Duration(seconds: 1),
            backgroundColor: const Color(0xFF28006D),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEDEEEF), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF191C1D),
                      letterSpacing: 0.1,
                      height: 1.43,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fileMeta,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A7583),
                      letterSpacing: 0.5,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF7A7583),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Routing Network (Figma Node 10:3707)
  // Header: Network icon + "Routing Network" (16px SemiBold #28006D)
  //   - REFERRED BY: Dr. Sarah Jenkins, Primary Care Physician, Valley Health Clinic
  //   - REFERRED TO: Dr. Michael Chang, Cardiology Specialist, Memorial General Hospital
  // ---------------------------------------------------------------------------
  Widget _buildRoutingNetworkSection() {
    final targetDoctorName = _referral.targetDoctor.isNotEmpty
        ? _referral.targetDoctor
        : 'Dr. Michael Chang';
    final specialtyName = _referral.specialty.isNotEmpty
        ? '${_referral.specialty} Specialist'
        : 'Cardiology Specialist';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bottom divider
          Container(
            padding: const EdgeInsets.only(bottom: 9),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEDEEEF), width: 1),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.alt_route_rounded,
                  size: 18,
                  color: Color(0xFF28006D),
                ),
                SizedBox(width: 8),
                Text(
                  'Routing Network',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stepper / Routing nodes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Markers & Vertical Line column
              Column(
                children: [
                  // Dot 1: Referred By
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFCBC4D4),
                    ),
                  ),
                  // Connecting line
                  Container(
                    width: 2,
                    height: 90,
                    color: const Color(0xFFCBC4D4),
                  ),
                  // Dot 2: Referred To (Deep Purple with Lavender Halo)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF28006D),
                      border: Border.all(
                        color: const Color(0xFFE8DDFF),
                        width: 3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),

              // Labels and Details column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Node 1: REFERRED BY
                    const Text(
                      'REFERRED BY',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7A7583),
                        letterSpacing: 0.6,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Dr. Sarah Jenkins',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF191C1D),
                        height: 1.5,
                      ),
                    ),
                    const Text(
                      'Primary Care Physician',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494552),
                        height: 1.43,
                      ),
                    ),
                    const Text(
                      'Valley Health Clinic',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494552),
                        height: 1.43,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Node 2: REFERRED TO
                    const Text(
                      'REFERRED TO',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF28006D),
                        letterSpacing: 0.6,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      targetDoctorName,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF191C1D),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      specialtyName,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494552),
                        height: 1.43,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(
                          Icons.apartment_rounded,
                          size: 14,
                          color: Color(0xFF006971),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Memorial General Hospital',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF006971),
                              height: 1.43,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Activity Timeline (Figma Node 10:3735)
  // Header: Clock icon + "Activity Timeline" (16px SemiBold #28006D)
  //   - Event 1: Today, 09:42 AM - Patient Contacted - Admin team left voicemail
  //   - Event 2: Yesterday, 14:15 PM - Referral Accepted - Accepted by Dr. Chang's office
  //   - Event 3: Oct 12, 2023, 11:30 AM - Referral Submitted - Created by Dr. Jenkins
  // ---------------------------------------------------------------------------
  Widget _buildActivityTimelineSection() {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bottom divider
          Container(
            padding: const EdgeInsets.only(bottom: 9),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEDEEEF), width: 1),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.history_rounded, size: 18, color: Color(0xFF28006D)),
                SizedBox(width: 8),
                Text(
                  'Activity Timeline',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Event 1
          _buildTimelineEvent(
            badgeBg: const Color(0xFFEDEEEF),
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFF494552),
            timestamp: 'Today, 09:42 AM',
            title: 'Patient Contacted',
            description: 'Admin team left voicemail for scheduling.',
            showDivider: true,
          ),

          // Event 2
          _buildTimelineEvent(
            badgeBg: const Color(0xFF76F1FF),
            icon: Icons.check_rounded,
            iconColor: const Color(0xFF004F55),
            timestamp: 'Yesterday, 14:15 PM',
            title: 'Referral Accepted',
            description: "Accepted by Dr. Chang's office.",
            showDivider: true,
          ),

          // Event 3
          _buildTimelineEvent(
            badgeBg: const Color(0xFF3F1D8B),
            icon: Icons.send_rounded,
            iconColor: Colors.white,
            timestamp: '${_referral.date}, 11:30 AM',
            title: 'Referral Submitted',
            description: 'Created by Dr. Jenkins.',
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineEvent({
    required Color badgeBg,
    required IconData icon,
    required Color iconColor,
    required String timestamp,
    required String title,
    required String description,
    required bool showDivider,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge & vertical divider
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (showDivider)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: const Color(0xFFEDEEEF),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Text details
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showDivider ? 20 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A7583),
                      letterSpacing: 0.5,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF191C1D),
                      height: 1.43,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF494552),
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mobile Sticky Actions (Figma Node 10:3602)
  // Background white, border-top #E1E3E4, drop shadow 0px -4px 5px rgba(0,0,0,0.05)
  //   - Share Button (176px / flex 1, rounded 20px, #F8F9FA, border #7A7583)
  //   - Edit Button (174px / flex 1, rounded 9999px, gradient #A44CFF to #5B14B8)
  // ---------------------------------------------------------------------------
  Widget _buildStickyActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE1E3E4), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, -4),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Share Button (Node 10:3603)
          Expanded(
            child: GestureDetector(
              key: const Key('referral_details_share_button'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Referral packet exported for external sharing.',
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color(0xFF28006D),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF7A7583), width: 1),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: Color(0xFF494552),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.1,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Edit Button (Node 10:3607)
          Expanded(
            child: GestureDetector(
              key: const Key('referral_details_edit_button'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening referral update editor...'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color(0xFF5B14B8),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.1,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation Shell (Figma Node 10:3573)
  //   - Home (active purple #28006D)
  //   - Patients (#494552)
  //   - Scan QR Floating Circular Button (64x64, #5B14B8)
  //   - Schedule (#494552)
  //   - Profile (Cyan Capsule #76F1FF)
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavShell(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA).withValues(alpha: 0.95),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              // 1. Home
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.dashboard,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 20,
                        color: Color(0xFF28006D),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF28006D),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients
              Expanded(
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.patientDirectory),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Patients',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Spacer for Floating Scan QR Button
              const SizedBox(width: 68),

              // 3. Schedule
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.appointmentsOverview,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Profile (Cyan Pill)
              Expanded(
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.doctorProfile),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF76F1FF),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 16,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating Scan QR Button (64x64 Circle)
          Positioned(
            top: -20,
            child: GestureDetector(
              key: const Key('referral_details_scan_qr_button'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF5B14B8),
                  border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000), // rgba(0,0,0,0.25)
                      offset: Offset(0, 10),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
