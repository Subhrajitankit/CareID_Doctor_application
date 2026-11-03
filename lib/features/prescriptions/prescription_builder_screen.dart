import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/clinical_models.dart';

/// Prescription Item data model representing a prescribed medication.
class PrescriptionItem {
  final String id;
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final String route;
  final String instructions;

  const PrescriptionItem({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.route,
    required this.instructions,
  });

  PrescriptionItem copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    String? frequency,
    String? duration,
    String? route,
    String? instructions,
  }) {
    return PrescriptionItem(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      route: route ?? this.route,
      instructions: instructions ?? this.instructions,
    );
  }
}

/// Pixel-accurate implementation of Prescription Builder matching Figma Node 10:4440.
class PrescriptionBuilderScreen extends StatefulWidget {
  const PrescriptionBuilderScreen({super.key});

  @override
  State<PrescriptionBuilderScreen> createState() =>
      _PrescriptionBuilderScreenState();
}

class _PrescriptionBuilderScreenState extends State<PrescriptionBuilderScreen> {
  // Form input controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController(
    text: 'Lisinopril 10mg',
  );
  final TextEditingController _dosageController = TextEditingController(
    text: '25 mg',
  );
  final TextEditingController _frequencyController = TextEditingController(
    text: 'Once Daily (OD)',
  );
  final TextEditingController _durationController = TextEditingController(
    text: '30 Days',
  );
  final TextEditingController _routeController = TextEditingController(
    text: 'Oral (PO)',
  );
  final TextEditingController _instructionsController = TextEditingController(
    text: 'Take in the morning with water.',
  );

  // Active prescription items list
  final List<PrescriptionItem> _prescriptionItems = [
    const PrescriptionItem(
      id: 'rx_1',
      medicineName: 'Lisinopril 10mg',
      dosage: '25 mg',
      frequency: 'Once Daily (OD)',
      duration: '30 Days',
      route: 'Oral (PO)',
      instructions: 'Take in the morning with water.',
    ),
  ];

  // Frequency and Route dropdown options
  static const List<String> _frequencyOptions = [
    'Once Daily (OD)',
    'Twice Daily (BID)',
    'Three Times Daily (TID)',
    'Four Times Daily (QID)',
    'Every 8 Hours (q8h)',
    'As Needed (PRN)',
  ];

  static const List<String> _routeOptions = [
    'Oral (PO)',
    'Sublingual (SL)',
    'Intravenous (IV)',
    'Intramuscular (IM)',
    'Subcutaneous (SC)',
    'Topical',
    'Inhalation',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _medicineNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _routeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addMedicationToOrder() {
    final name = _medicineNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a medicine name.'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    setState(() {
      _prescriptionItems.add(
        PrescriptionItem(
          id: 'rx_${DateTime.now().millisecondsSinceEpoch}',
          medicineName: name,
          dosage: _dosageController.text.trim().isEmpty
              ? 'Standard'
              : _dosageController.text.trim(),
          frequency: _frequencyController.text,
          duration: _durationController.text.trim().isEmpty
              ? '30 Days'
              : _durationController.text.trim(),
          route: _routeController.text,
          instructions: _instructionsController.text.trim().isEmpty
              ? 'As directed by physician.'
              : _instructionsController.text.trim(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to prescription order.'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF5B14B8),
      ),
    );
  }

  void _removeMedication(int index) {
    final removed = _prescriptionItems[index];
    setState(() {
      _prescriptionItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.medicineName} removed.'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF494552),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFF76F1FF),
          onPressed: () {
            setState(() {
              _prescriptionItems.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  void _editMedication(int index) {
    final item = _prescriptionItems[index];
    setState(() {
      _medicineNameController.text = item.medicineName;
      _dosageController.text = item.dosage;
      _frequencyController.text = item.frequency;
      _durationController.text = item.duration;
      _routeController.text = item.route;
      _instructionsController.text = item.instructions;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded ${item.medicineName} into form for editing.'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF28006D),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolve patient context from route arguments or fallback to Figma reference patient (John Doe, HV-99214)
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final Patient patient = (routeArgs is Patient)
        ? routeArgs
        : const Patient(
            id: 'p_john_doe',
            name: 'John Doe',
            age: 52,
            gender: 'Male',
            bloodGroup: 'O+',
            careId: 'HV-99214',
            allergies: ['Penicillin', 'Latex (Mild)'],
            chronicConditions: ['Essential (primary) hypertension'],
            queueStatus: 'waiting',
            scheduledTime: '09:00 AM',
            primaryComplaint: 'Hypertension follow-up',
            isCritical: false,
          );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: Stack(
        children: [
          // 1. Ambient Background Gradient (102.68deg #FFF7ED 0% to #F5F3FF 50%)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.85, -0.22),
                  end: Alignment(0.85, 0.22),
                  stops: [0.0, 0.50],
                  colors: [
                    Color(0xFFFFF7ED), // rgb(255, 247, 237)
                    Color(0xFFF5F3FF), // rgb(245, 243, 255)
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Scrollable Content Canvas (Node 10:4441)
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // TopAppBar (Node 10:4593) - Height 64px
                _buildTopAppBar(context),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: 88, // Clearance for pinned bottom action bar
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Header (Node 10:4442)
                        _buildPageHeader(),
                        const SizedBox(height: 24),

                        // Bento Grid Layout (Node 10:4448)
                        // Left Column: Patient Summary & Clinical Insights
                        _buildPatientSummaryCard(patient),
                        const SizedBox(height: 16),
                        _buildClinicalDecisionSupportWidget(),
                        const SizedBox(height: 16),

                        // Right Column: Search & Add Section
                        _buildSearchAndAddSection(),
                        const SizedBox(height: 16),

                        // Added Medicines List: Current Prescription
                        _buildCurrentPrescriptionList(),
                        const SizedBox(height: 16),

                        // Bottom Action Area: Interaction Alert Indicator
                        _buildInteractionAlertIndicator(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Pinned Actions Bar (Node 10:4586) - Height 64px
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionsBar(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TopAppBar (Figma Node 10:4593, 10:4594)
  // Height 64px, background #F8F9FA, CareID Logo Center, Back & Bell Right
  // ---------------------------------------------------------------------------
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: Button - Back (Node 10:4595)
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              key: const Key('prescription_builder_back_button'),
              onTap: () => Navigator.of(context).maybePop(),
              borderRadius: BorderRadius.circular(9999),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
          ),

          // Center: Heading 1 / CareID Logo (Node 10:4598, 10:4599)
          Center(
            child: Image.asset(
              'assets/images/careid_logo_cropped.png',
              height: 22,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Image.asset(
                'assets/images/careid_appbar_clean.png',
                height: 22,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Text(
                  'CAREiD',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Color(0xFF5B14B8),
                  ),
                ),
              ),
            ),
          ),

          // Right: Button - Notifications (Node 10:4600)
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              key: const Key('prescription_builder_notifications_button'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.notificationCenter);
              },
              borderRadius: BorderRadius.circular(9999),
              child: SizedBox(
                width: 32,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFBA1A1A),
                          shape: BoxShape.circle,
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
    );
  }

  // ---------------------------------------------------------------------------
  // Page Header (Figma Node 10:4442 - 10:4447)
  // Title: "Prescription Builder" (Gradient A44CFF -> 5B14B8, 32px Bold)
  // Subtitle: "Drafting new medication order" (14px Regular #494552)
  // ---------------------------------------------------------------------------
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
          ).createShader(bounds),
          child: const Text(
            'Prescription Builder',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 40 / 32,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Drafting new medication order',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494552),
            height: 20 / 14,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Patient Summary Card (Figma Node 10:4450 - 10:4483)
  // White card, 20px radius, 1px border #E1E3E4, 21px padding, top-right purple ornament
  // ---------------------------------------------------------------------------
  Widget _buildPatientSummaryCard(Patient patient) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top-right purple corner decorative arc (Node 10:4451)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 128,
              height: 128,
              decoration: const BoxDecoration(
                color: Color(0x1A3F1D8B), // #3f1d8b opacity 10%
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9999),
                ),
              ),
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Header: Avatar, Name & ID (Node 10:4452)
                Row(
                  children: [
                    // Avatar (56x56)
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE1E3E4),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/prescription_patient_avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: const Color(0xFFEDEEEF),
                            child: const Icon(
                              Icons.person,
                              size: 28,
                              color: Color(0xFF5B14B8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name & ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.name.isNotEmpty ? patient.name : 'John Doe',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF191C1D),
                              height: 28 / 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.badge_outlined,
                                size: 14,
                                color: Color(0xFF494552),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  patient.careId.isNotEmpty
                                      ? patient.careId
                                      : 'HV-99214',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF494552),
                                    height: 20 / 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),

                // Horizontal Border / Divider (Node 10:4463)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE1E3E4),
                ),
                const SizedBox(height: 17),

                // PRIMARY DIAGNOSIS (Node 10:4465 - 10:4471)
                const Text(
                  'PRIMARY DIAGNOSIS',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    letterSpacing: 0.6,
                    height: 16 / 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: Color(0xFFBA1A1A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        patient.chronicConditions.isNotEmpty
                            ? patient.chronicConditions.first
                            : 'Essential (primary) hypertension',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF191C1D),
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // KNOWN ALLERGIES (Node 10:4472 - 10:4483)
                const Text(
                  'KNOWN ALLERGIES',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    letterSpacing: 0.6,
                    height: 16 / 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Danger red chip (Penicillin)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0x33BA1A1A),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: Color(0xFF93000A),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Penicillin',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF93000A),
                              letterSpacing: 0.1,
                              height: 20 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Neutral gray chip (Latex (Mild))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEEEF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFCBC4D4),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Latex (Mild)',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                          letterSpacing: 0.1,
                          height: 20 / 14,
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
    );
  }

  // ---------------------------------------------------------------------------
  // Clinical Decision Support Widget (Figma Node 10:4484 - 10:4491)
  // Background #F3F4F5, 20px radius, 1px border #E1E3E4, padding 21px
  // ---------------------------------------------------------------------------
  Widget _buildClinicalDecisionSupportWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: Color(0xFF006971),
              ),
              SizedBox(width: 8),
              Text(
                'Clinical Insights',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF006971),
                  height: 24 / 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Patient's latest BP reading (145/90 mmHg) suggests current regimen may require titration. Liver function tests are within normal limits.",
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF494552),
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search & Add Section (Figma Node 10:4493 - 10:4553)
  // White card, 20px radius, 1px border #E1E3E4, padding 21px
  // ---------------------------------------------------------------------------
  Widget _buildSearchAndAddSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Section Heading (Node 10:4494)
          const Text(
            'Add Medication',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF191C1D),
              height: 24 / 16,
            ),
          ),
          const SizedBox(height: 16),

          // Search Input (Node 10:4496 - 10:4505)
          Container(
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Color(0xFF494552),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      color: Color(0xFF191C1D),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search drug database...',
                      hintStyle: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        color: Color(0xB3494552), // rgba(73,69,82,0.7)
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          _medicineNameController.text = query;
                        });
                      }
                    },
                  ),
                ),
                InkWell(
                  key: const Key('prescription_builder_dictate_button'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Listening for voice dictation...'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFF5B14B8),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(9999),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.mic_none_rounded,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Form Grid (Node 10:4506 - 10:4548)
          // 1. Medicine Name
          _buildFloatingInputField(
            label: 'Medicine Name',
            controller: _medicineNameController,
          ),
          const SizedBox(height: 16),

          // 2. Dosage
          _buildFloatingInputField(
            label: 'Dosage',
            controller: _dosageController,
          ),
          const SizedBox(height: 16),

          // 3. Frequency (Dropdown)
          _buildDropdownField(
            label: 'Frequency',
            controller: _frequencyController,
            options: _frequencyOptions,
          ),
          const SizedBox(height: 16),

          // 4. Duration
          _buildFloatingInputField(
            label: 'Duration',
            controller: _durationController,
          ),
          const SizedBox(height: 16),

          // 5. Route (Dropdown)
          _buildDropdownField(
            label: 'Route',
            controller: _routeController,
            options: _routeOptions,
          ),
          const SizedBox(height: 16),

          // 6. Patient Instructions (Textarea)
          _buildFloatingInputField(
            label: 'Patient Instructions',
            controller: _instructionsController,
            isTextarea: true,
          ),
          const SizedBox(height: 16),

          // Button: Add to Order (Node 10:4550)
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              key: const Key('prescription_builder_add_to_order_button'),
              onTap: _addMedicationToOrder,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E3E4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 14, color: Color(0xFF191C1D)),
                    SizedBox(width: 8),
                    Text(
                      'Add to Order',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF191C1D),
                        letterSpacing: 0.1,
                        height: 20 / 14,
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

  // Floating label style input widget matching Figma
  Widget _buildFloatingInputField({
    required String label,
    required TextEditingController controller,
    bool isTextarea = false,
  }) {
    return Container(
      width: double.infinity,
      height: isTextarea ? 82 : 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Floating Label
          Positioned(
            left: 0,
            top: 6,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
                letterSpacing: 0.5,
                height: 16 / 12,
              ),
            ),
          ),

          // Input Text
          Positioned(
            left: 0,
            right: 0,
            top: 22,
            bottom: isTextarea ? 6 : 0,
            child: TextField(
              controller: controller,
              maxLines: isTextarea ? 2 : 1,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF191C1D),
                height: 24 / 16,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown style selector matching Figma
  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
  }) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Floating Label
          Positioned(
            left: 0,
            top: 6,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
                letterSpacing: 0.5,
                height: 16 / 12,
              ),
            ),
          ),

          // Value and Dropdown Popup
          Positioned(
            left: 0,
            right: 0,
            top: 22,
            bottom: 0,
            child: PopupMenuButton<String>(
              initialValue: controller.text,
              onSelected: (String val) {
                setState(() {
                  controller.text = val;
                });
              },
              itemBuilder: (BuildContext context) {
                return options.map((String opt) {
                  return PopupMenuItem<String>(
                    value: opt,
                    child: Text(
                      opt,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  );
                }).toList();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.text,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF191C1D),
                      height: 24 / 16,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color(0xFF494552),
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
  // Current Prescription List (Figma Node 10:4554 - 10:4578)
  // Section heading + White cards with pill icon, medicine info, edit & delete buttons
  // ---------------------------------------------------------------------------
  Widget _buildCurrentPrescriptionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Current Prescription',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF191C1D),
              height: 24 / 16,
            ),
          ),
        ),
        const SizedBox(height: 12),

        if (_prescriptionItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: const Center(
              child: Text(
                'No medications added yet.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF494552),
                ),
              ),
            ),
          )
        else
          ..._prescriptionItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circular Pill Icon Container (Node 10:4561)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(
                            0xFF3F1D8B,
                          ).withValues(alpha: 0.20),
                        ),
                        child: const Icon(
                          Icons.medication_outlined,
                          size: 20,
                          color: Color(0xFF3F1D8B),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Details (Node 10:4564)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.medicineName,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF191C1D),
                                height: 24 / 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '1 tablet • ${item.route} • ${item.frequency} • ${item.duration}',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF494552),
                                height: 20 / 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                text: 'Sig: ',
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF191C1D),
                                  letterSpacing: 0.5,
                                  height: 16 / 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: item.instructions,
                                    style: const TextStyle(
                                      color: Color(0xFF494552),
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

                  // Actions: Edit & Remove (Node 10:4571 - 10:4578)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit Button (Node 10:4573)
                      InkWell(
                        key: Key('prescription_builder_edit_$index'),
                        onTap: () => _editMedication(index),
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Remove Button (Node 10:4576)
                      InkWell(
                        key: Key('prescription_builder_remove_$index'),
                        onTap: () => _removeMedication(index),
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: Color(0xFFBA1A1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Interaction Alert Indicator (Figma Node 10:4579 - 10:4585)
  // Background #F3F4F5, 20px radius, 1px border #E1E3E4, padding 17px
  // ---------------------------------------------------------------------------
  Widget _buildInteractionAlertIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 20,
            color: Color(0xFF006971),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'No interaction alerts detected',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
                letterSpacing: 0.1,
                height: 20 / 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Pinned Actions Bar (Figma Node 10:4586 - 10:4592)
  // Height 64px, Save Draft button (149px) + Review Interactions button (147px)
  // ---------------------------------------------------------------------------
  Widget _buildBottomActionsBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA).withValues(alpha: 0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFFE1E3E4), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Button: Save Draft (Node 10:4587) - 149px wide, 48px high, border #7A7583
          InkWell(
            key: const Key('prescription_builder_save_draft_button'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescription draft saved successfully.'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF28006D),
                ),
              );
            },
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 149,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: const Color(0xFF7A7583), width: 1),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Save Draft',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF28006D),
                  letterSpacing: 0.1,
                  height: 20 / 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Button: Review Interactions (Node 10:4589) - 147px wide, 48px high, gradient
          InkWell(
            key: const Key('prescription_builder_review_interactions_button'),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.drugInteractionReview,
                arguments: _prescriptionItems,
              );
            },
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 147,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x335B14B8),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Review\nInteractions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.1,
                        height: 14 / 12,
                      ),
                      overflow: TextOverflow.ellipsis,
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
}
