import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/clinical_models.dart';

/// Create Referral Screen
///
/// Pixel-accurate implementation of Figma Frame: Node `10:3409` (CAREID-AIO-FIGMA)
/// "Create Referral - Refined UI & Chips"
class CreateReferralScreen extends StatefulWidget {
  final Patient? patientArg;

  const CreateReferralScreen({super.key, this.patientArg});

  @override
  State<CreateReferralScreen> createState() => _CreateReferralScreenState();
}

class _CreateReferralScreenState extends State<CreateReferralScreen> {
  late Patient _patient;

  // Selected Doctor
  bool _hasSelectedDoctor = true;
  String _doctorName = 'Dr. Sarah Jenkins';
  String _doctorSpecialty = 'Cardiology • Mount Sinai Hospital';

  // Referral Details
  String _selectedReason = 'Pre-consultation cardiac assessment';
  final List<String> _reasonOptions = [
    'Pre-consultation cardiac assessment',
    'Specialist evaluation & management',
    'Diagnostic workup / Second opinion',
    'Post-procedure follow-up',
    'Surgical consultation',
    'Other / Custom reason',
  ];

  final TextEditingController _searchDoctorController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  // Urgency: 'Routine', 'Priority', 'Urgent'
  String _selectedUrgency = 'Routine';

  // Attachments
  final List<Map<String, dynamic>> _attachments = [
    {
      'name': 'Recent_ECG_Result.pdf',
      'icon': Icons.description_outlined,
    },
    {
      'name': 'Comprehensive_Metabolic_Panel.pdf',
      'icon': Icons.science_outlined,
    },
    {
      'name': 'Past_Clinical_Notes.docx',
      'icon': Icons.article_outlined,
    },
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _patient = widget.patientArg ??
        const Patient(
          id: 'p-eleanor-thompson',
          name: 'Eleanor Thompson',
          age: 48,
          gender: 'Female',
          bloodGroup: 'A+',
          careId: 'HV-8829-4410-X',
          primaryComplaint: 'Persistent palpitations and shortness of breath',
        );
    _summaryController.text =
        'Provide brief medical history and specific questions for the specialist...';
  }

  @override
  void dispose() {
    _searchDoctorController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _submitReferral() {
    if (!_hasSelectedDoctor) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a specialist before sending the referral.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral for ${_patient.name} created successfully.'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF5B14B8),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.referralSuccess,
        );
      }
    });
  }

  void _addAttachment() {
    setState(() {
      _attachments.add({
        'name': 'Lab_Report_${_attachments.length + 1}.pdf',
        'icon': Icons.description_outlined,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document attached successfully.'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF28006D),
      ),
    );
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: Stack(
        children: [
          // Background Gradient (Figma linear-gradient(104.39deg, #FFF7ED 0%, #F5F3FF 50%))
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF7ED),
                    Color(0xFFF5F3FF),
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),

          // Main Scrollable Area
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header - TopAppBar (Figma Node 10:3439)
                _buildTopAppBar(context),

                // Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: 110, // Spacing for floating Bottom Nav
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Patient Summary Card (Node 10:3452)
                        _buildPatientSummaryCard(),
                        const SizedBox(height: 24),

                        // Section - Doctor Selection / "Refer To" (Node 10:3468)
                        _buildDoctorSelectionSection(),
                        const SizedBox(height: 24),

                        // Section - Referral Details (Node 10:3489)
                        _buildReferralDetailsSection(),
                        const SizedBox(height: 24),

                        // Section - Urgency Toggles (Node 10:3510)
                        _buildUrgencySection(),
                        const SizedBox(height: 24),

                        // Section - Attachments (Node 10:3530)
                        _buildAttachmentsSection(),
                        const SizedBox(height: 24),

                        // Action Buttons Area (Node 10:3564)
                        _buildActionButtons(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Shell (Figma Node 10:3410)
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
  // TopAppBar (Figma Node 10:3439)
  // Shared Header:
  //   - Top bar: CareID logo in center, Doctor Avatar on right
  //   - Sub-bar: Back button + "Create Referral" (24px Bold #191C1D)
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
          // Top Row: Logo & Avatar (Node 10:3441)
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: const Color(0xFFF8F9FA),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Balance doctor avatar

                // Center: CareID Logo (Node 10:3443) - 98px x 22.05px
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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

                // Right: Doctor Profile Avatar (Node 10:3444) - 40px circle
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
                        'assets/images/doctor_sarah_jenkins.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFFEADDFF),
                          child: const Center(
                            child: Text(
                              'DR',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF28006D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sub-Bar: Back button + Title "Create Referral" (Node 10:3446)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  key: const Key('create_referral_back_button'),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.referralDashboard,
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Create Referral',
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
  // Patient Summary Card (Figma Node 10:3452)
  // Background: white, 20px radius, 21px padding, 1px border rgba(203,196,212,0.3)
  // Monogram circle "ET" (#3F1D8B bg, #AB8EFD text)
  // Name "Eleanor Thompson" (20px SemiBold #191C1D)
  // ID "HV-8829-4410-X" with badge icon (14px Regular #494552)
  // Capsule "Active Patient" with teal dot (#006971)
  // ---------------------------------------------------------------------------
  Widget _buildPatientSummaryCard() {
    final initials = _patient.name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monogram Avatar (Node 10:3453)
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3F1D8B),
            ),
            alignment: Alignment.center,
            child: Text(
              initials.isNotEmpty ? initials : 'ET',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFFAB8EFD),
                height: 1.33,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Patient Name & ID
          Text(
            _patient.name,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 16,
                color: Color(0xFF494552),
              ),
              const SizedBox(width: 6),
              Text(
                _patient.careId.isNotEmpty
                    ? _patient.careId
                    : 'HV-8829-4410-X',
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
          const SizedBox(height: 12),

          // Status Capsule (Node 10:3464)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006971),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Active Patient',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF191C1D),
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
  // Section - Doctor Selection / "Refer To" (Figma Node 10:3468)
  // Heading: "Refer To" (16px SemiBold #191C1D)
  // Search bar input with search icon
  // Selected Doctor Bento Card:
  //   - Left border 4px solid #006971
  //   - 48x48 cyan circle (#76F1FF) with stethoscope icon
  //   - "Dr. Sarah Jenkins", "Cardiology • Mount Sinai Hospital"
  //   - Close 'x' icon button
  // ---------------------------------------------------------------------------
  Widget _buildDoctorSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Refer To',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),

        // Search Bar (Node 10:3472)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF7A7583),
              width: 1,
            ),
          ),
          child: TextField(
            key: const Key('create_referral_search_doctor_input'),
            controller: _searchDoctorController,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Color(0xFF191C1D),
            ),
            decoration: const InputDecoration(
              hintText: 'Search by name, specialty, or hospital...',
              hintStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: Color(0xFF494552),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                setState(() {
                  _hasSelectedDoctor = true;
                  _doctorName = query;
                  _doctorSpecialty = 'Specialist Consultation';
                });
              }
            },
          ),
        ),
        const SizedBox(height: 12),

        // Selected Doctor Card (Node 10:3477)
        if (_hasSelectedDoctor)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: const Border(
                left: BorderSide(
                  color: Color(0xFF006971), // Teal vertical accent
                  width: 4,
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000), // rgba(0,0,0,0.05)
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                // Stethoscope Icon Badge (Node 10:3478)
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF76F1FF), // Cyan circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    size: 20,
                    color: Color(0xFF006971),
                  ),
                ),
                const SizedBox(width: 16),

                // Doctor Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _doctorName,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _doctorSpecialty,
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

                // Close / Remove Button (Node 10:3486)
                GestureDetector(
                  key: const Key('create_referral_remove_doctor_button'),
                  onTap: () {
                    setState(() {
                      _hasSelectedDoctor = false;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          GestureDetector(
            key: const Key('create_referral_select_default_doctor_button'),
            onTap: () {
              setState(() {
                _hasSelectedDoctor = true;
                _doctorName = 'Dr. Sarah Jenkins';
                _doctorSpecialty = 'Cardiology • Mount Sinai Hospital';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0x4DCBC4D4),
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color(0xFF28006D),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Tap to re-select Dr. Sarah Jenkins',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF28006D),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Section - Referral Details (Figma Node 10:3489)
  // Heading: "Referral Details" (16px SemiBold #191C1D)
  // 1. "Reason for Referral" (14px Medium #494552) -> Dropdown options
  // 2. "Clinical Summary" (14px Medium #494552) -> Multiline textarea
  // ---------------------------------------------------------------------------
  Widget _buildReferralDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Referral Details',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),

        // Field 1: Reason for Referral
        const Text(
          'Reason for Referral',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF494552),
            letterSpacing: 0.1,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF7A7583),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              key: const Key('create_referral_reason_dropdown'),
              value: _selectedReason,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF494552),
                size: 22,
              ),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF191C1D),
              ),
              items: _reasonOptions.map((reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(
                    reason,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedReason = val;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Field 2: Clinical Summary
        const Text(
          'Clinical Summary',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF494552),
            letterSpacing: 0.1,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF7A7583),
              width: 1,
            ),
          ),
          child: TextField(
            key: const Key('create_referral_clinical_summary_input'),
            controller: _summaryController,
            maxLines: 4,
            minLines: 3,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF191C1D),
              height: 1.43,
            ),
            decoration: const InputDecoration(
              hintText:
                  'Provide brief medical history and specific questions for the specialist...',
              hintStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
                height: 1.43,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Section - Urgency Toggles (Figma Node 10:3510)
  // Heading: "Urgency" (16px SemiBold #191C1D)
  // 3 Chips: Routine (selected #76F1FF), Priority, Urgent
  // ---------------------------------------------------------------------------
  Widget _buildUrgencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Urgency',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),

        // Urgency Chips (Wrap prevents overflow on narrow screens)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildUrgencyChip(
              keyName: 'urgency_chip_routine',
              label: 'Routine',
              icon: Icons.calendar_today_outlined,
              isSelected: _selectedUrgency == 'Routine',
              selectedBg: const Color(0xFF76F1FF),
              selectedBorder: const Color(0xFF006971),
              selectedColor: const Color(0xFF006D76),
            ),
            _buildUrgencyChip(
              keyName: 'urgency_chip_priority',
              label: 'Priority',
              icon: Icons.priority_high_rounded,
              isSelected: _selectedUrgency == 'Priority',
              selectedBg: const Color(0xFFCFBDFF),
              selectedBorder: const Color(0xFF5B14B8),
              selectedColor: const Color(0xFF28006D),
            ),
            _buildUrgencyChip(
              keyName: 'urgency_chip_urgent',
              label: 'Urgent',
              icon: Icons.warning_amber_rounded,
              isSelected: _selectedUrgency == 'Urgent',
              selectedBg: const Color(0xFFFFDAD6),
              selectedBorder: const Color(0xFFBA1A1A),
              selectedColor: const Color(0xFFBA1A1A),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUrgencyChip({
    required String keyName,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color selectedBg,
    required Color selectedBorder,
    required Color selectedColor,
  }) {
    return GestureDetector(
      key: Key(keyName),
      onTap: () {
        setState(() {
          _selectedUrgency = label;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? selectedBorder : const Color(0xFF7A7583),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? selectedColor : const Color(0xFF494552),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? selectedColor : const Color(0xFF494552),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section - Attachments (Figma Node 10:3530)
  // Heading: "Attachments"
  // "+ Add File" button (pill, border rgba(122,117,131,0.3))
  // List of attached files:
  //   - Recent_ECG_Result.pdf
  //   - Comprehensive_Metabolic_Panel.pdf
  //   - Past_Clinical_Notes.docx
  // ---------------------------------------------------------------------------
  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Attachments + "+ Add File" Button (Node 10:3531)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Attachments',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1D),
                height: 1.5,
              ),
            ),
            GestureDetector(
              key: const Key('create_referral_add_file_button'),
              onTap: _addAttachment,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: const Color(0x4D7A7583), // rgba(122,117,131,0.3)
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: Color(0xFF28006D),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add File',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF28006D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // List of attached file chips (Node 10:3539)
        Column(
          children: _attachments.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE1E3E4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0x80CBC4D4), // rgba(203,196,212,0.5)
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    file['icon'] as IconData,
                    size: 18,
                    color: const Color(0xFF191C1D),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      file['name'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF191C1D),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    key: Key('create_referral_remove_file_$index'),
                    onTap: () => _removeAttachment(index),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Action Buttons (Figma Node 10:3564)
  // Top divider border: 1px rgba(203,196,212,0.3)
  // 1. Primary Button: "Send Referral" (pill, purple gradient, paper-plane icon)
  // 2. Secondary Button: "Share Outside CareID" (pill, border 2px #CBC4D4)
  // ---------------------------------------------------------------------------
  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 17),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Primary "Send Referral" Button (Node 10:3565)
          GestureDetector(
            key: const Key('create_referral_submit_button'),
            onTap: _isSubmitting ? null : _submitReferral,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFA44CFF),
                    Color(0xFF5B14B8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000), // rgba(0,0,0,0.1)
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.send_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isSubmitting ? 'Sending...' : 'Send Referral',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Secondary "Share Outside CareID" Button (Node 10:3570)
          GestureDetector(
            key: const Key('create_referral_share_outside_button'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Exporting secure referral package for external clinician...',
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF28006D),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: const Color(0xFFCBC4D4),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  'Share Outside CareID',
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation Shell (Figma Node 10:3410)
  // Frosted shell: Home, Patients, Scan QR, Schedule, Profile
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
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.patientDirectory,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
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

              // Spacer for center elevated Scan QR button
              const SizedBox(width: 72),

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

              // 4. Profile - Active cyan pill
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.doctorProfile,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
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
                            color: Color(0xFF006D76),
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF006D76),
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

          // Center Elevated Scan QR Button - 64x64 circle
          Positioned(
            top: -24,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.cameraPermission,
              ),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B14B8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF8F9FF),
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000), // rgba(0,0,0,0.25)
                      blurRadius: 25,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
