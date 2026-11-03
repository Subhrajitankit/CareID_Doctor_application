import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';

class PrescriptionHistoryModel {
  final String id;
  final String medicationName;
  final String date;
  final String status; // 'Active', 'Completed', 'Cancelled'
  final String sig;
  final String prescriber;
  final bool hasRepeat;
  final double opacity;

  const PrescriptionHistoryModel({
    required this.id,
    required this.medicationName,
    required this.date,
    required this.status,
    required this.sig,
    required this.prescriber,
    this.hasRepeat = false,
    this.opacity = 1.0,
  });
}

class PrescriptionHistoryScreen extends StatefulWidget {
  final List<PrescriptionHistoryModel>? customRecords;

  const PrescriptionHistoryScreen({super.key, this.customRecords});

  @override
  State<PrescriptionHistoryScreen> createState() =>
      _PrescriptionHistoryScreenState();
}

class _PrescriptionHistoryScreenState extends State<PrescriptionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Active';
  String _searchQuery = '';

  late final List<PrescriptionHistoryModel> _allRecords;

  @override
  void initState() {
    super.initState();
    _allRecords = widget.customRecords ?? _buildInitialRecords();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PrescriptionHistoryModel> _buildInitialRecords() {
    return [
      // Figma Item 1 (Node 10:4837)
      const PrescriptionHistoryModel(
        id: 'rx-figma-1',
        medicationName: 'Lisinopril 10mg',
        date: 'Sep 12, 2023',
        status: 'Active',
        sig: 'Take 1 tablet by mouth daily for blood pressure.',
        prescriber: 'Dr. Sarah Jenkins (Cardiology)',
        hasRepeat: true,
        opacity: 1.0,
      ),
      // Figma Item 2 (Node 10:4865)
      const PrescriptionHistoryModel(
        id: 'rx-figma-2',
        medicationName: 'Amoxicillin 500mg',
        date: 'Jul 05, 2023',
        status: 'Completed',
        sig: 'Take 1 capsule by mouth three times daily for 7 days.',
        prescriber: 'Dr. Mark Owen (Primary Care)',
        hasRepeat: false,
        opacity: 0.8,
      ),
      // Live Clinical Context from MockData
      ...MockData.prescriptions.map((rx) {
        final med = rx.medications.isNotEmpty ? rx.medications.first : null;
        return PrescriptionHistoryModel(
          id: rx.id,
          medicationName: med != null
              ? '${med.name} ${med.dosage}'
              : 'Prescription #${rx.id}',
          date: rx.date,
          status: 'Active',
          sig:
              med?.instructions ??
              'Take as instructed by cardiologist for ${rx.diagnosis}.',
          prescriber: '${MockData.doctorName} (${MockData.doctorTitle})',
          hasRepeat: true,
          opacity: 1.0,
        );
      }),
    ];
  }

  List<PrescriptionHistoryModel> get _filteredRecords {
    return _allRecords.where((item) {
      // In the default "Active" timeline view, show both active items and recent timeline history (matching Figma)
      // If the user explicitly selects "Completed" or "Cancelled", filter strictly.
      bool matchesFilter;
      if (_selectedFilter == 'Active') {
        matchesFilter =
            true; // Shows the full timeline context as designed in Figma node 10:4820
      } else if (_selectedFilter == 'All') {
        matchesFilter = true;
      } else {
        matchesFilter =
            item.status.toLowerCase() == _selectedFilter.toLowerCase();
      }

      final matchesSearch =
          _searchQuery.isEmpty ||
          item.medicationName.toLowerCase().contains(_searchQuery) ||
          item.sig.toLowerCase().contains(_searchQuery) ||
          item.prescriber.toLowerCase().contains(_searchQuery);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF28006D),
                        size: 22,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.dashboard,
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Prescription History',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF28006D),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        color: Color(0xFF28006D),
                        size: 22,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notifications'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient matching Figma node 10:4820
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.35, -0.94),
                end: Alignment(0.35, 0.94),
                colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF)],
              ),
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                children: [
                  // Section - Search & Filter (Figma Node 10:4822)
                  _buildSearchAndFilterSection(),

                  const SizedBox(height: 28),

                  // Section - Timeline / History List (Figma Node 10:4836)
                  _buildTimelineHistorySection(),
                ],
              ),
            ),
          ),

          // Floating Bottom Navigation Shell (Figma Node 10:4898)
          _buildBottomNavigationShell(context),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input Bar (Figma Node 10:4823)
        Container(
          height: 49,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF7A7583), width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.search, size: 20, color: Color(0xFF6B7280)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: const Color(0xFF191C1D),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search medications...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                    color: Color(0xFF7A7583),
                  ),
                  splashRadius: 18,
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              const SizedBox(width: 12),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Filter Pills Row (Figma Node 10:4829)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterPill('Active'),
              const SizedBox(width: 8),
              _buildFilterPill('Completed'),
              const SizedBox(width: 8),
              _buildFilterPill('Cancelled'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String filterName) {
    final isSelected = _selectedFilter == filterName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = isSelected ? 'All' : filterName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006971) : Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF006971)
                : const Color(0xFF7A7583),
            width: 1,
          ),
        ),
        child: Text(
          filterName,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF494552),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineHistorySection() {
    final records = _filteredRecords;

    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.medication_outlined,
                size: 48,
                color: Color(0xFF7A7583),
              ),
              const SizedBox(height: 12),
              Text(
                'No prescriptions found',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try adjusting your search or filter options',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF494552),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: List.generate(records.length, (index) {
        final record = records[index];
        final isLast = index == records.length - 1;
        return _buildTimelineItem(record: record, isLast: isLast);
      }),
    );
  }

  Widget _buildTimelineItem({
    required PrescriptionHistoryModel record,
    required bool isLast,
  }) {
    final isActive = record.status.toLowerCase() == 'active';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Timeline Track & Dot Column (Figma Node 10:4861 & 10:4885)
          SizedBox(
            width: 48,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Connecting vertical timeline track
                if (!isLast)
                  Positioned(
                    top: 24,
                    bottom: -24,
                    left: 23,
                    child: Container(width: 2, color: const Color(0xFFE1E3E4)),
                  ),

                // 48x48 Circular Timeline Dot (Node 10:4862 / 10:4886)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF3F1D8B)
                        : const Color(0xFFE1E3E4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8F9FA),
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(14, 18),
                      painter: MedicineJarPainter(
                        color: isActive
                            ? const Color(0xFFAB8EFD)
                            : const Color(0xFF494552),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Right Prescription Card (Figma Node 10:4838 & 10:4866)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Opacity(
                opacity: record.opacity,
                child: Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE1E3E4),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Medication Name + Date + Status Pill
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.medicationName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF191C1D),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 13,
                                      color: Color(0xFF494552),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      record.date,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xFF494552),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Status Badge (Node 10:4847 / 10:4875)
                          _buildStatusPill(record.status),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Inner Gray Background Container (Node 10:4849 / 10:4877)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: const Color(0xFF494552),
                                  height: 1.45,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Sig: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: record.sig,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: const Color(0xFF494552),
                                  height: 1.45,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Prescriber: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: record.prescriber,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Divider (Node 10:4854 / 10:4882)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFCBC4D4),
                      ),

                      const SizedBox(height: 14),

                      // Action Buttons Row (Node 10:4855 & 10:4859)
                      Row(
                        mainAxisAlignment: record.hasRepeat
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          // View Details Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.prescriptionPreview,
                                arguments: {
                                  'hospitalName': 'Metro General\nHospital',
                                  'patientName': 'John Doe',
                                  'doctorNameHeader': 'Dr. Sarah\nJenkins',
                                  'prescriptionDate': record.date,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: Text(
                                'View Details',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF28006D),
                                ),
                              ),
                            ),
                          ),

                          // Repeat Action Button (Node 10:4855)
                          if (record.hasRepeat)
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9999),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFA44CFF),
                                    Color(0xFF5B14B8),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(91, 20, 184, 0.25),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(9999),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Repeating ${record.medicationName}...',
                                        ),
                                      ),
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.prescriptionBuilder,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.replay_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Repeat',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    final lower = status.toLowerCase();
    final isActive = lower == 'active';
    final isCompleted = lower == 'completed';

    Color bg;
    Color border;
    Color textColor;

    if (isActive) {
      bg = const Color(0xFF59D8E5);
      border = const Color(0xFF006971);
      textColor = const Color(0xFF006971);
    } else if (isCompleted) {
      bg = const Color(0xFFE1E3E4);
      border = const Color(0xFFCBC4D4);
      textColor = const Color(0xFF494552);
    } else {
      bg = const Color(0xFFFFD8D8);
      border = const Color(0xFFBA1A1A);
      textColor = const Color(0xFFBA1A1A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        status,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationShell(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: Center(
        child: Container(
          width: 351,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: const Color.fromRGBO(203, 196, 212, 0.3),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 25,
                offset: Offset(0, 20),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 10,
                offset: Offset(0, 8),
                spreadRadius: -6,
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.dashboard,
                          (route) => false,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.grid_view_rounded,
                            size: 18,
                            color: Color(0xFF006D76),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Home',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF006D76),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Patients (Active cyan pill background)
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF76F1FF),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.people_alt_rounded,
                              size: 16,
                              color: Color(0xFF494552),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Patients',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF494552),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center Spacer for elevated Scan QR button
                  const SizedBox(width: 56),

                  // 3. Schedule
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.appointmentsOverview,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Schedule',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. Profile
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.doctorProfile);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Profile',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Elevated Center Scan QR Button (Figma Node 10:4911)
              Positioned(
                top: -16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.cameraPermission);
                  },
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
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 25,
                          offset: Offset(0, 12),
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
        ),
      ),
    );
  }
}

/// Custom painter for the medicine jar icon inside the timeline circle (Node 10:4864 / 10:4888).
class MedicineJarPainter extends CustomPainter {
  final Color color;

  const MedicineJarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final scaleX = size.width / 14.0;
    final scaleY = size.height / 18.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // SVG path: M5.5 14.5H8.5V12H11V9H8.5V6.5H5.5V9H3V12H5.5V14.5V14.5
    // M2 18C1.45 18 0.979167 17.8042 0.5875 17.4125C0.195833 17.0208 0 16.55 0 16V5C0 4.45 0.195833 3.97917 0.5875 3.5875C0.979167 3.19583 1.45 3 2 3H12C12.55 3 13.0208 3.19583 13.4125 3.5875C13.8042 3.97917 14 4.45 14 5V16C14 16.55 13.8042 17.0208 13.4125 17.4125C13.0208 17.8042 12.55 18 12 18H2V18
    // M1 2V0H13V2H1V2
    final path = Path()..fillType = PathFillType.evenOdd;

    // Cutout plus cross
    path.moveTo(5.5, 14.5);
    path.lineTo(8.5, 14.5);
    path.lineTo(8.5, 12);
    path.lineTo(11, 12);
    path.lineTo(11, 9);
    path.lineTo(8.5, 9);
    path.lineTo(8.5, 6.5);
    path.lineTo(5.5, 6.5);
    path.lineTo(5.5, 9);
    path.lineTo(3, 9);
    path.lineTo(3, 12);
    path.lineTo(5.5, 12);
    path.close();

    // Bottle body: RRect from (0,3) to (14,18) with radius 2
    path.addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 3, 14, 15),
        const Radius.circular(2),
      ),
    );

    // Top cap: (1, 0) to (13, 2)
    path.addRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 0, 12, 2),
        const Radius.circular(0.5),
      ),
    );

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MedicineJarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
