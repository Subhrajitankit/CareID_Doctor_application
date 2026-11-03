import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/clinical_models.dart';

/// Referral Success Screen
///
/// Pixel-accurate implementation of Figma Frame: Node `10:3781` (CAREID-AIO-FIGMA)
/// "Referral Success - Auto-Redirect Refinement"
///
/// Figma Specifications:
/// - Frame size: 390 x 1048
/// - Background: Linear gradient 110.41deg from #FFF7ED (0%) to #F5F3FF (50%)
/// - Soft Tonal Accents: Node 10:3845 (#CFBDFF, 30% opacity, 32px blur) & Node 10:3846 (#87F3FF, 30% opacity, 32px blur)
/// - TopAppBar: Node 10:3812 (Height: 64px, CareID logo centered, notification bell + avatar right)
/// - Success Container: Node 10:3825 (Width: 342px, Height: 580px, Padding: 33px all sides, Radius: 24px, Shadow: 0 8 30 rgba(0,0,0,0.04))
/// - 3D Illustration: Node 10:3828 (192 x 192px with glow rings and 3D shield checkmark)
/// - Heading 1: Node 10:3835 ("Referral Sent\nSuccessfully", 24px, SemiBold, #191C1D, line-height 32px)
/// - Body Text: Node 10:3837 (3 lines wrapped, 16px, Regular, #494552, line-height 26px)
/// - Primary Button: Node 10:3839 ("Return to Referrals", 276 x 48px, gradient #A44CFF -> #5B14B8)
/// - Secondary Button: Node 10:3842 ("View Referral Details", 276 x 48px, outlined 2px #CBC4D4, text #28006D)
/// - Bottom Nav: Node 10:3782 (Height: 71px, Radius: 36px, Elevated QR button, Profile cyan pill)
class ReferralSuccessScreen extends StatelessWidget {
  final ReferralItem? referral;

  const ReferralSuccessScreen({super.key, this.referral});

  @override
  Widget build(BuildContext context) {
    final activeReferral =
        referral ??
        (ModalRoute.of(context)?.settings.arguments as ReferralItem?);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: Stack(
        children: [
          // 1. Exact Figma Ambient Background Gradient (110.41deg, #FFF7ED 0% to #F5F3FF 50%)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.6, -1.0),
                  end: Alignment(0.6, 1.0),
                  colors: [
                    Color(0xFFFFF7ED), // 0%
                    Color(0xFFF5F3FF), // 50%
                  ],
                ),
              ),
            ),
          ),

          // 2. Background Accents (Material 3 Soft Tonal Layering - Node 10:3844)
          // Top-left purple accent (Node 10:3845: x: -39, y: -100, width: 195, height: 410, #CFBDFF @ 30%)
          Positioned(
            top: -60,
            left: -39,
            child: IgnorePointer(
              child: Container(
                width: 195,
                height: 410,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFBDFF).withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),

          // Bottom-right cyan accent (Node 10:3846: x: 195, y: 556, width: 234, height: 492, #87F3FF @ 30%)
          Positioned(
            bottom: 60,
            right: -39,
            child: IgnorePointer(
              child: Container(
                width: 234,
                height: 492,
                decoration: BoxDecoration(
                  color: const Color(0xFF87F3FF).withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),

          // 3. Screen Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header - TopAppBar (Node 10:3812)
                _buildTopAppBar(context),

                // Main Content Canvas (Node 10:3824)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 48,
                      bottom:
                          120, // clearance for floating bottom navigation shell
                    ),
                    child: Center(
                      child: _buildSuccessCard(context, activeReferral),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Floating Bottom Navigation Shell (Node 10:3782)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _buildBottomNavShell(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header - TopAppBar (Node 10:3812, 10:3813)
  // Height: 64px, White/F8F9FA, CareID Logo Center, Bell + Avatar Right
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
          // Left placeholder for balanced centering
          const Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: 44, height: 44),
          ),

          // Center CareID Logo (Node 10:3816)
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

          // Right Notification Bell & Avatar (Node 10:3817)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Button (Node 10:3818)
                InkWell(
                  key: const Key('referral_success_bell_button'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.notificationCenter);
                  },
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    width: 32,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Doctor Profile Avatar (Node 10:3821, 10:3822)
                InkWell(
                  key: const Key('referral_success_avatar_button'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.doctorProfile);
                  },
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/doctor_profile_avatar_topbar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Image.asset(
                          'assets/images/doctor_profile_avatar_appbar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: const Color(0xFF76F1FF),
                            child: const Icon(
                              Icons.person,
                              size: 18,
                              color: Color(0xFF28006D),
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Success Container Card (Node 10:3825)
  // Exact Figma: Width: 342px, Height: 580px, Padding: 33px all around, Radius: 24px
  // ---------------------------------------------------------------------------
  Widget _buildSuccessCard(BuildContext context, ReferralItem? activeReferral) {
    return Container(
      width: 342,
      padding: const EdgeInsets.all(33),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F5), width: 1),
        gradient: const RadialGradient(
          center: Alignment(0.0, 0.0),
          radius: 0.9,
          colors: [
            Color(0x33E8DDFF), // rgba(232,221,255,0.2) Node 10:3826
            Colors.white,
          ],
          stops: [0.0, 0.65],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            offset: Offset(0, 8),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 3D Success Illustration with Glowing Rings (Node 10:3827, 10:3828)
          // Width: 192px, Height: 192px, Margin Bottom: 24px
          _buildIllustrationBadge(),
          const SizedBox(height: 24),

          // Typography Content: Heading 1 (Node 10:3834, 10:3835)
          // 24px, SemiBold, #191C1D, line-height 32px, tracking -0.6px
          const Text(
            'Referral Sent\nSuccessfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 32 / 24,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 12),

          // Typography Content: Body Description (Node 10:3836, 10:3837)
          // Max-width: 276px, 16px, Regular, #494552, line-height 26px
          const SizedBox(
            width: 276,
            child: Text(
              "The receiving doctor has been\nnotified and the patient's records\nhave been securely transferred.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
                height: 26 / 16,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons (Node 10:3838)
          _buildActionButtons(context, activeReferral),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3D Success Illustration (Node 10:3828)
  // Exact Figma Frame: 192 x 192px with glow rings and 3D metallic shield
  // ---------------------------------------------------------------------------
  Widget _buildIllustrationBadge() {
    return SizedBox(
      width: 192,
      height: 192,
      child: Image.asset(
        'assets/images/referral_success_shield.png',
        width: 192,
        height: 192,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildVector3DShield(),
      ),
    );
  }

  // High-fidelity fallback vector 3D shield widget with cyan checkmark
  Widget _buildVector3DShield() {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow Ring (#76F1FF @ 20%)
          Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF76F1FF).withValues(alpha: 0.20),
            ),
          ),

          // Inner Glow Ring (#87F3FF @ 40%)
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF87F3FF).withValues(alpha: 0.40),
            ),
          ),

          // Purple Shield Circle
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF5B14B8), Color(0xFF380775)],
                center: Alignment(-0.2, -0.3),
                radius: 0.85,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5B14B8).withValues(alpha: 0.40),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                size: 56,
                color: Color(0xFF76F1FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Buttons (Node 10:3838)
  // Exact Figma: Width: 276px, Height: 48px each, Gap: 16px
  // 1. Primary Action: Return to Referrals (Gradient #A44CFF -> #5B14B8)
  // 2. Secondary Action: View Referral Details (Outlined #CBC4D4)
  // ---------------------------------------------------------------------------
  Widget _buildActionButtons(
    BuildContext context,
    ReferralItem? activeReferral,
  ) {
    return Column(
      children: [
        // Primary Button (Node 10:3839) - Gradient Pill 276 x 48px
        Container(
          width: 276,
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
                color: Color(0x1A000000), // rgba(0,0,0,0.10)
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -1,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('referral_success_return_button'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.referralDashboard,
                );
              },
              borderRadius: BorderRadius.circular(9999),
              child: const Center(
                child: Text(
                  'Return to Referrals',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Secondary Button (Node 10:3842) - Outlined Pill 276 x 48px
        Container(
          width: 276,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: const Color(0xFFCBC4D4), width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('referral_success_details_button'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.referralDetails,
                  arguments: activeReferral,
                );
              },
              borderRadius: BorderRadius.circular(9999),
              child: const Center(
                child: Text(
                  'View Referral Details',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Color(0xFF28006D),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation Shell (Figma Node 10:3782)
  // Height: 71px, Radius: 36px, Soft shadow, 5 tabs: Home, Patients, QR, Schedule, Profile
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavShell(BuildContext context) {
    return Container(
      height: 71,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000), // soft bottom shadow
            blurRadius: 18,
            offset: Offset(0, 6),
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
              // 1. Home (Node 10:3784)
              Expanded(
                child: InkWell(
                  key: const Key('referral_success_nav_home'),
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

              // 2. Patients (Node 10:3789)
              Expanded(
                child: InkWell(
                  key: const Key('referral_success_nav_patients'),
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
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer for center elevated Scan QR button
              const SizedBox(width: 56),

              // 3. Schedule (Node 10:3799)
              Expanded(
                child: InkWell(
                  key: const Key('referral_success_nav_schedule'),
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

              // 4. Profile (Node 10:3804) - Active cyan pill
              Expanded(
                child: InkWell(
                  key: const Key('referral_success_nav_profile'),
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

          // Center Elevated Scan QR Button (Node 10:3794, 10:3795)
          Positioned(
            top: -18,
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
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 26,
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
