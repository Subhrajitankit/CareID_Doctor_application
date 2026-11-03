import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/clinical_models.dart';

/// Incoming Referral Screen
///
/// Pixel-accurate implementation of Figma Frame: Node `10:5719` (CAREID-AIO-FIGMA)
/// "Incoming Referral - Refined Navigation"
class IncomingReferralScreen extends StatefulWidget {
  final ReferralItem? referralArg;

  static const ReferralItem figmaReferral = ReferralItem(
    id: 'ref-figma-incoming',
    patient: Patient(
      id: 'pt-figma-robert',
      name: 'Robert Caldwell',
      age: 58,
      gender: 'Male',
      bloodGroup: 'A+',
      careId: 'HV-883-921',
      primaryComplaint:
          'Persistent, unexplained tachycardia and shortness of breath',
    ),
    targetDoctor: 'Dr. Sarah Jenkins',
    specialty: 'General Practice, City Health',
    urgency: 'Urgent',
    reason:
        'Evaluation of persistent, unexplained tachycardia and shortness of breath upon mild exertion. Patient has a history of mild hypertension, previously managed well, but symptoms have worsened over the past three weeks.',
    clinicalNotes:
        'History of mild hypertension, previously managed well, but symptoms have worsened over the past three weeks.',
    date: 'Oct 28, 2026',
    status: 'Pending Review',
  );

  const IncomingReferralScreen({super.key, this.referralArg});

  @override
  State<IncomingReferralScreen> createState() => _IncomingReferralScreenState();
}

class _IncomingReferralScreenState extends State<IncomingReferralScreen> {
  bool _isAccepted = false;
  bool _isDeclined = false;

  @override
  Widget build(BuildContext context) {
    final referral =
        widget.referralArg ??
        (ModalRoute.of(context)?.settings.arguments as ReferralItem?) ??
        IncomingReferralScreen.figmaReferral;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FD),
      body: Stack(
        children: [
          // Background Gradient (Figma linear-gradient(102.32deg, #FFF7ED 0%, #F5F3FF 50%))
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF)],
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
                // TopAppBar (Figma Node 10:5750)
                _buildTopAppBar(context),

                // Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: 110, // Spacing for floating Bottom Nav
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section: Overline, Title, Received capsule (Node 10:5765)
                        _buildHeaderSection(),
                        const SizedBox(height: 24),

                        // Card 1: Patient Summary Card (Node 10:5776)
                        _buildPatientSummaryCard(referral),
                        const SizedBox(height: 16),

                        // Card 2: Referring Physician Card (Node 10:5799)
                        _buildReferringPhysicianCard(context, referral),
                        const SizedBox(height: 16),

                        // Card 3: Recent Vitals Card (Node 10:5819)
                        _buildRecentVitalsCard(),
                        const SizedBox(height: 16),

                        // Card 4: Attached Medical Records Card (Node 10:5849)
                        _buildAttachedRecordsCard(context),
                        const SizedBox(height: 24),

                        // Action Area Card (Node 10:5896)
                        _buildActionAreaCard(context, referral),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Shell (Figma Node 10:5720)
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
  // TopAppBar (Figma Node 10:5750)
  // Height: 64px, background #F3F4F5, shadow 0 1px 1px rgba(0,0,0,0.05)
  // Left: Back button (10:5753)
  // Center: CareID Logo (10:5757) - 98px x 22.05px
  // Right: Notification Bell (10:5759) + Doctor Avatar (10:5762)
  // ---------------------------------------------------------------------------
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F5),
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
          // Left: Back Arrow Button (Node 10:5753)
          GestureDetector(
            key: const Key('incoming_referral_back_button'),
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
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF191C1D),
              ),
            ),
          ),

          // Center: CareID Logo (Node 10:5757)
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

          // Right: Notification Bell (Node 10:5759) + Doctor Avatar (Node 10:5762)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                key: const Key('incoming_referral_bell_button'),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.notificationCenter);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 22,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                      color: const Color(0xFFE1E3E4),
                      width: 2,
                    ),
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header Section (Figma Node 10:5765)
  // Overline: "INCOMING REFERRAL" (14px Medium #28006D, letterSpacing 0.7)
  // Title: "Review Patient" (40px Bold #191C1D, letterSpacing -0.8, line height 48px)
  // Capsule: "Received 2 hours ago" (capsule #EDEEEF, icon + 12px Medium #494552)
  // ---------------------------------------------------------------------------
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overline
        const Text(
          'INCOMING REFERRAL',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF28006D),
            letterSpacing: 0.7,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 4),

        // Title
        const Text(
          'Review Patient',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191C1D),
            letterSpacing: -0.8,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),

        // Received time capsule (Node 10:5771)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEEEF),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Color(0xFF494552),
              ),
              SizedBox(width: 8),
              Text(
                'Received 2 hours ago',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF494552),
                  letterSpacing: 0.5,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Card 1: Patient Summary Card (Figma Node 10:5776)
  // Background: white, 20px radius, 25px padding, 1px border rgba(203,196,212,0.3)
  // Avatar + Name "Robert Caldwell" + Male, 58 yrs • DOB: 12/04/1965 + ID: HV-883-921
  // Urgent pill (! Urgent)
  // Divider
  // Reason for Referral + Description text
  // ---------------------------------------------------------------------------
  Widget _buildPatientSummaryCard(ReferralItem referral) {
    final patientName = referral.patient.name;
    final patientDetails =
        referral.id == IncomingReferralScreen.figmaReferral.id
        ? 'Male, 58 yrs • DOB: 12/04/1965'
        : '${referral.patient.gender}, ${referral.patient.age} yrs • Blood: ${referral.patient.bloodGroup}';
    final patientId = referral.id == IncomingReferralScreen.figmaReferral.id
        ? 'ID: HV-883-921'
        : 'ID: ${referral.patient.careId}';
    final reasonText = referral.reason;

    return Container(
      padding: const EdgeInsets.all(25),
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Name / Demographics + Urgent Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Photo (Node 10:5779)
              Container(
                width: 48,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Image.asset(
                    'assets/images/patient_arthur.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFD8EEF3),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF006971),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name + Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      patientDetails,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494552),
                        height: 1.43,
                      ),
                    ),
                    Text(
                      patientId,
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
              const SizedBox(width: 8),

              // Urgent Badge (Node 10:5788)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.priority_high_rounded,
                      size: 11,
                      color: Color(0xFFBA1A1A),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Urgent',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBA1A1A),
                        letterSpacing: 0.5,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Horizontal Divider (Node 10:5793)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0x80CBC4D4), // rgba(203,196,212,0.5)
            ),
          ),

          // Reason for Referral Section (Node 10:5794)
          const Text(
            'Reason for Referral',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reasonText,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 2: Referring Physician Card (Figma Node 10:5799)
  // Background: rgba(232,221,255,0.3) (#F7F3FF), border rgba(207,189,255,0.5)
  // Stethoscope icon + "Referring Physician" (16px SemiBold #28006D)
  // 48x48 avatar + "Dr. Sarah Jenkins", "General Practice, City Health"
  // Outline button: mail icon + "Message Dr. Jenkins" (border #28006D, text #28006D)
  // ---------------------------------------------------------------------------
  Widget _buildReferringPhysicianCard(
    BuildContext context,
    ReferralItem referral,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0x4DE8DDFF), // rgba(232,221,255,0.3)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x80CFBDFF), // rgba(207,189,255,0.5)
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Stethoscope Icon + Heading
          const Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 20,
                color: Color(0xFF28006D),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Referring Physician',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Doctor Info Row
          Row(
            children: [
              // Avatar 48x48
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF8F9FA),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/doctor_sarah_jenkins.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFEADDFF),
                      child: const Center(
                        child: Text(
                          'SJ',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Doctor Name + Specialty
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Sarah Jenkins',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        height: 1.5,
                      ),
                    ),
                    Text(
                      'General Practice, City Health',
                      style: TextStyle(
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
            ],
          ),
          const SizedBox(height: 16),

          // Message Dr. Jenkins Button (Node 10:5814)
          GestureDetector(
            key: const Key('incoming_referral_message_physician_button'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.patientMessages);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF28006D), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    size: 16,
                    color: Color(0xFF28006D),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Message Dr. Jenkins',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF28006D),
                        letterSpacing: 0.1,
                        height: 1.43,
                      ),
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
  // Card 3: Recent Vitals Card (Figma Node 10:5819)
  // Background: white, 20px radius, 21px padding, 1px border rgba(203,196,212,0.3)
  // Pulse icon + "Recent Vitals" (16px SemiBold #191C1D)
  // 2x2 Grid:
  //   - Blood Pressure: "145/90"
  //   - Heart Rate: 2px solid left border #BA1A1A, "112 bpm" (SemiBold #BA1A1A)
  //   - SpO2: "96 %"
  //   - Temp: "98.4 °F"
  // ---------------------------------------------------------------------------
  Widget _buildRecentVitalsCard() {
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Heartbeat Icon + Heading
          const Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                size: 20,
                color: Color(0xFF191C1D),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Recent Vitals',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2x2 Grid of metrics
          Column(
            children: [
              // Row 1: Blood Pressure & Heart Rate
              Row(
                children: [
                  // Blood Pressure
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Blood Pressure',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF494552),
                              letterSpacing: 0.5,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '145/90',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Heart Rate (with abnormal red indicator border)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 14,
                        top: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          left: BorderSide(color: Color(0xFFBA1A1A), width: 2),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Heart Rate',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF494552),
                              letterSpacing: 0.5,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '112',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFBA1A1A),
                                    height: 1.33,
                                  ),
                                ),
                                TextSpan(
                                  text: ' bpm',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFBA1A1A),
                                    letterSpacing: 0.5,
                                    height: 1.33,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Row 2: SpO2 & Temp
              Row(
                children: [
                  // SpO2
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SpO2',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF494552),
                              letterSpacing: 0.5,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '96',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1D),
                                    height: 1.33,
                                  ),
                                ),
                                TextSpan(
                                  text: ' %',
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
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Temp
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Temp',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF494552),
                              letterSpacing: 0.5,
                              height: 1.33,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '98.4',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1D),
                                    height: 1.33,
                                  ),
                                ),
                                TextSpan(
                                  text: ' °F',
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 4: Attached Medical Records Card (Figma Node 10:5849)
  // Background: white, 20px radius, 21px padding, 1px border rgba(203,196,212,0.3)
  // Folder icon + "Attached Medical Records" (16px SemiBold #191C1D)
  // 3 records:
  //   1. Initial Consultation Notes.pdf (Cyan badge, download icon)
  //   2. Chest X-Ray (AP View).dcm (Pink badge, view eye icon)
  //   3. Comprehensive Metabolic Panel.pdf (Cyan badge, download icon)
  // ---------------------------------------------------------------------------
  Widget _buildAttachedRecordsCard(BuildContext context) {
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Folder Icon + Heading
          const Row(
            children: [
              Icon(
                Icons.folder_open_rounded,
                size: 20,
                color: Color(0xFF191C1D),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Attached Medical Records',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // File Item 1: Initial Consultation Notes.pdf
          _buildFileRow(
            context: context,
            keyName: 'file_consultation_notes',
            title: 'Initial Consultation Notes.pdf',
            subtitle: '1.2 MB • Uploaded Today',
            badgeColor: const Color(0xFF87F3FF),
            badgeIcon: Icons.description_outlined,
            badgeIconColor: const Color(0xFF004F58),
            actionIcon: Icons.download_rounded,
          ),
          const SizedBox(height: 8),

          // File Item 2: Chest X-Ray (AP View).dcm
          _buildFileRow(
            context: context,
            keyName: 'file_chest_xray',
            title: 'Chest X-Ray (AP View).dcm',
            subtitle: '15 MB • Uploaded Yesterday',
            badgeColor: const Color(0xFFFFDADA),
            badgeIcon: Icons.image_outlined,
            badgeIconColor: const Color(0xFFBA1A1A),
            actionIcon: Icons.visibility_outlined,
          ),
          const SizedBox(height: 8),

          // File Item 3: Comprehensive Metabolic Panel.pdf
          _buildFileRow(
            context: context,
            keyName: 'file_metabolic_panel',
            title: 'Comprehensive Metabolic Panel.pdf',
            subtitle: '340 KB • Uploaded Yesterday',
            badgeColor: const Color(0xFF87F3FF),
            badgeIcon: Icons.description_outlined,
            badgeIconColor: const Color(0xFF004F58),
            actionIcon: Icons.download_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFileRow({
    required BuildContext context,
    required String keyName,
    required String title,
    required String subtitle,
    required Color badgeColor,
    required IconData badgeIcon,
    required Color badgeIconColor,
    required IconData actionIcon,
  }) {
    return GestureDetector(
      key: Key(keyName),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $title'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF28006D),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Colored File Type Box (40x40)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(badgeIcon, size: 20, color: badgeIconColor),
            ),
            const SizedBox(width: 12),

            // File Name & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                  Text(
                    subtitle,
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
            const SizedBox(width: 8),

            // Action Icon
            Icon(actionIcon, size: 20, color: const Color(0xFF494552)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Area Card (Figma Node 10:5896)
  // Background: white, 20px radius, 25px padding, 1px border rgba(203,196,212,0.3)
  // Button 1: "Request More Information" (border #7A7583, icon info, 20px radius)
  // Button 2: "Decline Referral" (pill, border #BA1A1A, text #BA1A1A)
  // Button 3: "Accept Referral" (pill gradient #A44CFF to #5B14B8, checkmark icon, white text)
  // ---------------------------------------------------------------------------
  Widget _buildActionAreaCard(BuildContext context, ReferralItem referral) {
    return Container(
      padding: const EdgeInsets.all(25),
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Button 1: Request More Information (Node 10:5897)
          GestureDetector(
            key: const Key('incoming_referral_request_info_button'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Information request sent to Dr. Sarah Jenkins.',
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF28006D),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF7A7583), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Color(0xFF494552),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Request More Information',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.1,
                        height: 1.43,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bottom Buttons: Decline Referral & Accept Referral
          Row(
            children: [
              // Decline Referral Button (Node 10:5902)
              Expanded(
                child: GestureDetector(
                  key: const Key('incoming_referral_decline_button'),
                  onTap: () {
                    setState(() {
                      _isDeclined = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Referral has been declined.'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFFBA1A1A),
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: const Color(0xFFBA1A1A),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _isDeclined ? 'Declined' : 'Decline\nReferral',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFBA1A1A),
                        height: 1.2,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Accept Referral Button (Node 10:5904)
              Expanded(
                child: GestureDetector(
                  key: const Key('incoming_referral_accept_button'),
                  onTap: () {
                    setState(() {
                      _isAccepted = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Referral accepted! Patient added to clinical queue.',
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF5B14B8),
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 700), () {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.referralDashboard,
                        );
                      }
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000), // rgba(0,0,0,0.15)
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _isAccepted ? 'Accepted' : 'Accept\nReferral',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.2,
                              letterSpacing: 0.1,
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation Shell (Figma Node 10:5720)
  // Background: rgba(248,249,250,0.9), blur 12px, shadow 0 -2px 12px rgba(0,0,0,0.05)
  // Items: Home, Patients, Scan QR (Center Floating 64x64 circle), Schedule, Profile
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
              // 1. Home (Node 10:5722)
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

              // 2. Patients (Node 10:5727)
              Expanded(
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.patientDirectory),
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

              // Empty middle space for elevated Scan QR button
              const SizedBox(width: 72),

              // 3. Schedule (Node 10:5737)
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

              // 4. Profile (Node 10:5742) - Active cyan pill
              Expanded(
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.doctorProfile),
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

          // Center Elevated Scan QR Button (Node 10:5732) - 64x64 purple circle
          Positioned(
            top: -24,
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.cameraPermission),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B14B8),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
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
