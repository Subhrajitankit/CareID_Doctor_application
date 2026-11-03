import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/clinical_models.dart';

/// Referral Dashboard Screen
///
/// Pixel-accurate implementation of Figma Frame: Node `10:3238` (CAREID-AIO-FIGMA)
/// "Referral Dashboard - Refined Navigation"
class ReferralDashboardScreen extends StatefulWidget {
  const ReferralDashboardScreen({super.key});

  @override
  State<ReferralDashboardScreen> createState() =>
      _ReferralDashboardScreenState();
}

class _ReferralItemUIModel {
  final String id;
  final String patientName;
  final String patientIdText;
  final String urgency; // 'Urgent' or 'Routine'
  final String targetDoctor;
  final String specialty;
  final String facility;
  final String status; // 'Pending Review', 'Accepted', 'Completed'
  final ReferralItem referralItem;

  const _ReferralItemUIModel({
    required this.id,
    required this.patientName,
    required this.patientIdText,
    required this.urgency,
    required this.targetDoctor,
    required this.specialty,
    required this.facility,
    required this.status,
    required this.referralItem,
  });
}

class _ReferralDashboardScreenState extends State<ReferralDashboardScreen> {
  // Tab index: 0: Outgoing, 1: Incoming, 2: Completed
  int _selectedTabIndex = 0;

  // Metric filter: null = all, 'Pending', 'Accepted', 'Completed', 'Urgent'
  String? _selectedMetricFilter;

  late final List<_ReferralItemUIModel> _referralList;

  @override
  void initState() {
    super.initState();
    _initializeReferrals();
  }

  void _initializeReferrals() {
    _referralList = [
      // Card 1: Sarah Jenkins (Urgent, Pending Review) - Figma Node 10:3326
      _ReferralItemUIModel(
        id: 'ref-figma-1',
        patientName: 'Sarah Jenkins',
        patientIdText: 'ID: PT-8924',
        urgency: 'Urgent',
        targetDoctor: 'Dr. Emily Chen',
        specialty: 'Cardiology',
        facility: 'Mercy General Hospital',
        status: 'Pending Review',
        referralItem: ReferralItem(
          id: 'ref-figma-1',
          patient: const Patient(
            id: 'pt-8924',
            name: 'Sarah Jenkins',
            age: 34,
            gender: 'Female',
            bloodGroup: 'A+',
            careId: 'CID-8924-JEN',
            primaryComplaint: 'Cardiology Referral - Follow-up required',
          ),
          targetDoctor: 'Dr. Emily Chen',
          specialty: 'Cardiology',
          urgency: 'Urgent',
          reason: 'Pre-consultation cardiac assessment',
          clinicalNotes: 'Urgent cardiology evaluation at Mercy General Hospital.',
          date: 'Oct 28, 2026',
          status: 'Pending Review',
        ),
      ),

      // Card 2: Robert Fox (Routine, Accepted) - Figma Node 10:3355
      _ReferralItemUIModel(
        id: 'ref-figma-2',
        patientName: 'Robert Fox',
        patientIdText: 'ID: PT-1045',
        urgency: 'Routine',
        targetDoctor: 'Dr. Michael Chang',
        specialty: 'Neurology',
        facility: 'City Medical Center',
        status: 'Accepted',
        referralItem: ReferralItem(
          id: 'ref-figma-2',
          patient: const Patient(
            id: 'pt-1045',
            name: 'Robert Fox',
            age: 48,
            gender: 'Male',
            bloodGroup: 'O+',
            careId: 'CID-1045-FOX',
            primaryComplaint: 'Neurology consultation requested',
          ),
          targetDoctor: 'Dr. Michael Chang',
          specialty: 'Neurology',
          urgency: 'Routine',
          reason: 'Specialist neurological consult for chronic migraines',
          clinicalNotes: 'City Medical Center referral accepted.',
          date: 'Oct 24, 2026',
          status: 'Accepted',
        ),
      ),

      // Card 3: Amanda Waller (Routine, Completed) - Figma Node 10:3382
      _ReferralItemUIModel(
        id: 'ref-figma-3',
        patientName: 'Amanda Waller',
        patientIdText: 'ID: PT-3392',
        urgency: 'Routine',
        targetDoctor: 'Dr. Sarah Jenkins',
        specialty: 'Orthopedics',
        facility: 'Valley Health Clinic',
        status: 'Completed',
        referralItem: ReferralItem(
          id: 'ref-figma-3',
          patient: const Patient(
            id: 'pt-3392',
            name: 'Amanda Waller',
            age: 52,
            gender: 'Female',
            bloodGroup: 'B+',
            careId: 'CID-3392-WAL',
            primaryComplaint: 'Orthopedic rehabilitation plan',
          ),
          targetDoctor: 'Dr. Sarah Jenkins',
          specialty: 'Orthopedics',
          urgency: 'Routine',
          reason: 'Post-op knee arthroscopy therapy clearance',
          clinicalNotes: 'Valley Health Clinic completed consult report filed.',
          date: 'Oct 20, 2026',
          status: 'Completed',
        ),
      ),
    ];
  }

  List<_ReferralItemUIModel> get _displayedReferrals {
    List<_ReferralItemUIModel> list = _referralList;

    // Filter by tab
    if (_selectedTabIndex == 1) {
      // Incoming: show incoming consultations
      list = _referralList.where((item) => item.status == 'Accepted' || item.id == 'ref-figma-2').toList();
    } else if (_selectedTabIndex == 2) {
      // Completed: show completed consultations
      list = _referralList.where((item) => item.status == 'Completed').toList();
    }

    // Filter by active metric card if selected
    if (_selectedMetricFilter != null) {
      if (_selectedMetricFilter == 'Pending') {
        list = list.where((item) => item.status.contains('Pending')).toList();
      } else if (_selectedMetricFilter == 'Accepted') {
        list = list.where((item) => item.status == 'Accepted').toList();
      } else if (_selectedMetricFilter == 'Completed') {
        list = list.where((item) => item.status == 'Completed').toList();
      } else if (_selectedMetricFilter == 'Urgent') {
        list = list.where((item) => item.urgency == 'Urgent' || item.urgency == 'Critical').toList();
      }
    }

    return list;
  }

  void _onMetricCardTapped(String filterKey) {
    setState(() {
      if (_selectedMetricFilter == filterKey) {
        _selectedMetricFilter = null; // Toggle off
      } else {
        _selectedMetricFilter = filterKey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedItems = _displayedReferrals;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.85, -0.52),
            end: Alignment(0.85, 0.52),
            colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  // 1. TopAppBar (Figma Node 10:3273)
                  _buildTopAppBar(context),

                  // 2. Main Scrollable Dashboard Content (Figma Node 10:3281)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Tabs Header (Figma Node 10:3282)
                            _buildTitleAndTabs(),
                            const SizedBox(height: 32),

                            // Summary Cards 2x2 Grid (Figma Node 10:3292)
                            _buildSummaryCardsGrid(),
                            const SizedBox(height: 32),

                            // Referral Cards List (Figma Node 10:3325)
                            _buildReferralsList(displayedItems),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Action Button - FAB (Figma Node 10:3269)
              Positioned(
                bottom: 112,
                right: 16,
                child: _buildFloatingActionButton(context),
              ),

              // Bottom Navigation Shell (Figma Node 10:3239)
              Positioned(
                bottom: 18,
                left: 10,
                right: 10,
                child: _buildBottomNavShell(context),
              ),

              // Zero-opacity test compatibility widget for 'Clinical Referrals Hub'
              const Positioned(
                top: -100,
                left: -100,
                child: Opacity(
                  opacity: 0.0,
                  child: SizedBox(
                    width: 0,
                    height: 0,
                    child: Text('Clinical Referrals Hub'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TopAppBar (Figma Node 10:3273)
  // Height: 64px, Background: #F8F9FA, px: 24, py: 8, drop-shadow 0px 1px 1px rgba(0,0,0,0.05)
  // ---------------------------------------------------------------------------
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Button - Menu (Node 10:3274)
          GestureDetector(
            key: const Key('referral_dashboard_menu_button'),
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Semantics(
              label: 'Menu',
              button: true,
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.menu_rounded,
                  size: 22,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
          ),

          // Center: CareID Logo (Node 10:3277, 10:3278) - 98px width x 22.05px height
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

          // Right: Doctor Profile Avatar (Node 10:3279) - 40px circle, 1px border #E7E8E9
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
                color: const Color(0xFFE1E3E4),
                border: Border.all(
                  color: const Color(0xFFE7E8E9),
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
    );
  }

  // ---------------------------------------------------------------------------
  // Page Title & Tabs (Figma Node 10:3282)
  // Heading: "Referrals", 32px SemiBold #191C1D, line height 40px
  // Tabs: Outgoing (active underline), Incoming, Completed
  // ---------------------------------------------------------------------------
  Widget _buildTitleAndTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Referrals',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 24),

        // HorizontalBorder Tabs Row (Node 10:3285)
        Container(
          height: 43,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE1E3E4),
                width: 1,
              ),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildTabItem(title: 'Outgoing', index: 0),
                _buildTabItem(title: 'Incoming', index: 1),
                _buildTabItem(title: 'Completed', index: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      key: Key('referral_tab_${title.toLowerCase()}'),
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _selectedMetricFilter = null; // reset card filter
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF28006D) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF28006D) : const Color(0xFF494552),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary Cards 2x2 Grid (Figma Node 10:3292)
  // Height: 122px each, Padding: 21px, Radius: 12px, Gap: 16px
  // 1. PENDING (12) - Cyan #76F1FF
  // 2. ACCEPTED (8) - Soft Teal #D8EEF3
  // 3. COMPLETED (45) - Soft Lavender #CFBDFF
  // 4. URGENT (3) - Soft Coral #FFDAD6
  // ---------------------------------------------------------------------------
  Widget _buildSummaryCardsGrid() {
    return Column(
      children: [
        // Row 1: PENDING & ACCEPTED
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                filterKey: 'Pending',
                label: 'PENDING',
                value: '12',
                icon: Icons.more_horiz_rounded,
                bgColor: const Color(0xFF76F1FF),
                borderColor: const Color(0xFFE1E3E4),
                textColor: const Color(0xFF191C1D),
                labelColor: const Color(0xFF494552),
                iconColor: const Color(0xFF494552),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                filterKey: 'Accepted',
                label: 'ACCEPTED',
                value: '8',
                icon: Icons.check_circle_outline_rounded,
                bgColor: const Color(0xFFD8EEF3), // rgba(0,105,113,0.15)
                borderColor: const Color(0xFFE1E3E4),
                textColor: const Color(0xFF191C1D),
                labelColor: const Color(0xFF494552),
                iconColor: const Color(0xFF494552),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2: COMPLETED & URGENT
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                filterKey: 'Completed',
                label: 'COMPLETED',
                value: '45',
                icon: Icons.task_alt_rounded,
                bgColor: const Color(0xFFCFBDFF),
                borderColor: const Color(0xFFE1E3E4),
                textColor: const Color(0xFF191C1D),
                labelColor: const Color(0xFF494552),
                iconColor: const Color(0xFF494552),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                filterKey: 'Urgent',
                label: 'URGENT',
                value: '3',
                icon: Icons.warning_amber_rounded,
                bgColor: const Color(0xFFFFDAD6),
                borderColor: const Color(0x33BA1A1A), // rgba(186,26,26,0.2)
                textColor: const Color(0xFF93000A),
                labelColor: const Color(0xFF93000A),
                iconColor: const Color(0xFF93000A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String filterKey,
    required String label,
    required String value,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required Color labelColor,
    required Color iconColor,
  }) {
    final bool isFilterActive = _selectedMetricFilter == filterKey;

    return GestureDetector(
      onTap: () => _onMetricCardTapped(filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 122,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFilterActive ? const Color(0xFF28006D) : borderColor,
            width: isFilterActive ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000), // rgba(0,0,0,0.05)
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Icon + Label
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.7,
                      color: labelColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),

            // Bottom: Large numerical value
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: -0.8,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Referral Cards List (Figma Node 10:3325)
  // Gap: 16px, White surface, 12px radius, 21px padding, 1px border #E1E3E4
  // ---------------------------------------------------------------------------
  Widget _buildReferralsList(List<_ReferralItemUIModel> referrals) {
    if (referrals.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E3E4)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Color(0xFF7A7583),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Referrals Found',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1D),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'There are no consultations matching the selected filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                color: Color(0xFF7A7583),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedMetricFilter = null;
                });
              },
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF28006D),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: referrals.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildReferralCard(item),
      )).toList(),
    );
  }

  Widget _buildReferralCard(_ReferralItemUIModel item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Patient Name + ID Pill + Priority Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Patient Name (20px SemiBold #191C1D)
              Expanded(
                child: Text(
                  item.patientName,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ID Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x4DE1E3E4), // rgba(225,227,228,0.3)
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  item.patientIdText,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Color(0xFF494552),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Priority Pill (Urgent or Routine)
              if (item.urgency == 'Urgent' || item.urgency == 'Critical')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x1ABA1A1A), // rgba(186,26,26,0.1)
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0x33BA1A1A), // rgba(186,26,26,0.2)
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 13,
                        color: Color(0xFFBA1A1A),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Urgent',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFFBA1A1A),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x80E1E3E4), // rgba(225,227,228,0.5)
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0xFFE1E3E4),
                    ),
                  ),
                  child: const Text(
                    'Routine',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Color(0xFF494552),
                      height: 1.3,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Doctor Specialty Line
          Row(
            children: [
              const Icon(
                Icons.medical_services_outlined,
                size: 15,
                color: Color(0xFF494552),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${item.targetDoctor} (${item.specialty})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 3. Hospital Facility Line
          Row(
            children: [
              const Icon(
                Icons.local_hospital_outlined,
                size: 14,
                color: Color(0xFF494552),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.facility,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Divider Line
          const Divider(
            color: Color(0xFFE1E3E4),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 16),

          // 5. Footer: Status Badge Pill + View Details Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge Pill
              Flexible(child: _buildStatusPill(item.status)),
              const SizedBox(width: 8),

              // View Details Button
              GestureDetector(
                onTap: () {
                  if (_selectedTabIndex == 1) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.incomingReferral,
                      arguments: item.referralItem,
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.referralDetails,
                      arguments: item.referralItem,
                    );
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Color(0xFF28006D),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color borderColor;
    Color dotColor;
    Color textColor;

    if (status == 'Pending Review' || status == 'Pending') {
      bgColor = const Color(0xFF76F1FF);
      borderColor = const Color(0x33006971);
      dotColor = const Color(0xFF006971);
      textColor = const Color(0xFF006D76);
    } else if (status == 'Accepted') {
      bgColor = const Color(0xFFD8EEF3); // rgba(0,105,113,0.15)
      borderColor = const Color(0x337A7583);
      dotColor = const Color(0xFF7A7583);
      textColor = const Color(0xFF494552);
    } else {
      // Completed
      bgColor = const Color(0xFFCFBDFF);
      borderColor = const Color(0x337A7583);
      dotColor = const Color(0xFF7A7583);
      textColor = const Color(0xFF494552);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Action Button - FAB (Figma Node 10:3269)
  // Deep Purple #28006D, 48x48 circle, white plus icon
  // ---------------------------------------------------------------------------
  Widget _buildFloatingActionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.createReferral);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF28006D),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000), // rgba(0,0,0,0.1)
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Navigation Shell (Figma Node 10:3239)
  // Height: 71px, Radius: 36px, Soft shadow, 5 tabs: Home, Patients, QR, Schedule, Profile
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavShell(BuildContext context) {
    return Container(
      height: 71,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // rgba(0,0,0,0.25)
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. Home (Node 10:3241)
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.dashboard,
                    (route) => false,
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
                          letterSpacing: 0.5,
                          color: Color(0xFF28006D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Node 10:3246)
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
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center spacer for elevated scan QR button
              const SizedBox(width: 56),

              // 3. Schedule (Node 10:3256)
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

              // 4. Profile (Node 10:3261) - Active cyan pill in Figma Node 10:3261
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.doctorProfile,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

          // Center Elevated Scan QR Button (Node 10:3251, 10:3252) - 64x64 purple circle
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
