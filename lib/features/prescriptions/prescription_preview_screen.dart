import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';

class PrescriptionPreviewScreen extends StatelessWidget {
  final Map<String, dynamic>? prescriptionData;

  const PrescriptionPreviewScreen({super.key, this.prescriptionData});

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final data = prescriptionData ?? routeArgs;

    final hospitalName =
        data?['hospitalName'] as String? ?? 'Metro General\nHospital';
    final hospitalAddress =
        data?['hospitalAddress'] as String? ??
        '123 Clinical Way, Medical\nDistrict, NY 10001';
    final hospitalPhone =
        data?['hospitalPhone'] as String? ?? 'Phone: (555) 019-8273';

    final doctorNameHeader =
        data?['doctorNameHeader'] as String? ?? 'Dr. Sarah\nJenkins';
    final doctorTitle =
        data?['doctorTitle'] as String? ?? 'MD, Internal\nMedicine';
    final doctorRegNo =
        data?['doctorRegNo'] as String? ?? 'Reg. No:\nMED-7492-X';
    final doctorSignatureName =
        data?['doctorSignatureName'] as String? ?? 'Dr. Sarah Jenkins';
    final signatureText = data?['signatureText'] as String? ?? 'S. Jenkins';

    final patientName = data?['patientName'] as String? ?? 'John Doe';
    final patientAgeSex = data?['patientAgeSex'] as String? ?? '44 / M';
    final prescriptionDate =
        data?['prescriptionDate'] as String? ?? 'Oct 24, 2023';
    final patientWeight = data?['patientWeight'] as String? ?? '82 kg';

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
                          'Prescription Preview',
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.25, -0.97),
            end: Alignment(0.25, 0.97),
            colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Digital Prescription Card (Figma Node 10:4689)
              _buildDigitalPrescriptionCard(
                context: context,
                hospitalName: hospitalName,
                hospitalAddress: hospitalAddress,
                hospitalPhone: hospitalPhone,
                doctorNameHeader: doctorNameHeader,
                doctorTitle: doctorTitle,
                doctorRegNo: doctorRegNo,
                patientName: patientName,
                patientAgeSex: patientAgeSex,
                prescriptionDate: prescriptionDate,
                patientWeight: patientWeight,
                doctorSignatureName: doctorSignatureName,
                signatureText: signatureText,
              ),

              const SizedBox(height: 24),

              // Section - Sharing Options (Figma Node 10:4782)
              _buildSharingOptions(context),

              const SizedBox(height: 20),

              // Primary Action: Finalize & Sign (Figma Node 10:4806)
              _buildPrimaryAction(context),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalPrescriptionCard({
    required BuildContext context,
    required String hospitalName,
    required String hospitalAddress,
    required String hospitalPhone,
    required String doctorNameHeader,
    required String doctorTitle,
    required String doctorRegNo,
    required String patientName,
    required String patientAgeSex,
    required String prescriptionDate,
    required String patientWeight,
    required String doctorSignatureName,
    required String signatureText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(203, 196, 212, 0.3),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative top header accent bar (Figma Node 10:4781)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 8,
            child: Container(color: const Color(0xFF28006D)),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: Hospital & Doctor details (Figma Node 10:4690)
                Container(
                  padding: const EdgeInsets.only(bottom: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE1E3E4), width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hospital Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospitalName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF191C1D),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              hospitalAddress,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF494552),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hospitalPhone,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF494552),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Doctor Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            doctorNameHeader,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF28006D),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctorTitle,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF494552),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doctorRegNo,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF494552),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Patient Info 2x2 Grid (Figma Node 10:4705)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE1E3E4),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildPatientDataField(
                              label: 'PATIENT NAME',
                              value: patientName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPatientDataField(
                              label: 'AGE / SEX',
                              value: patientAgeSex,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildPatientDataField(
                              label: 'DATE',
                              value: prescriptionDate,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPatientDataField(
                              label: 'WEIGHT',
                              value: patientWeight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Rx Section (Figma Node 10:4726)
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE1E3E4), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '℞',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 36,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF28006D),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Medications',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF191C1D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Medication Item 1: Lisinopril 10mg (Figma Node 10:4733)
                _buildMedicationCard(
                  name: '1. Lisinopril 10mg',
                  sig: 'Take 1 tablet by mouth daily in the morning.',
                  quantity: '30 Tablets',
                  refills: '0 Refills',
                  route: 'Oral',
                ),

                const SizedBox(height: 14),

                // Medication Item 2: Metformin 500mg (Figma Node 10:4750)
                _buildMedicationCard(
                  name: '2. Metformin 500mg',
                  sig: 'Take 1 tablet by mouth twice daily with meals.',
                  quantity: '60 Tablets',
                  refills: '2 Refills',
                  route: 'Oral',
                ),

                const SizedBox(height: 24),

                // Footer / Signature Section (Figma Node 10:4767)
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFE1E3E4), width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // QR Code + Scan text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color.fromRGBO(203, 196, 212, 0.4),
                                width: 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/prescription_preview_qr.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.qr_code_2,
                                    size: 54,
                                    color: Color(0xFF28006D),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Scan to\nverify',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF494552),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),

                      // Signature + Doctor Name + Digitally Signed
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            padding: const EdgeInsets.only(bottom: 4),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFCBC4D4),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                signatureText,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(
                                    0xFF28006D,
                                  ).withValues(alpha: 0.85),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            doctorSignatureName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF191C1D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Digitally Signed',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildPatientDataField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF494552),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF191C1D),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationCard({
    required String name,
    required String sig,
    required String quantity,
    required String refills,
    required String route,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(203, 196, 212, 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sig,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF494552),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quantity,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF191C1D),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  refills,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF191C1D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Route pill (Oral)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF76F1FF).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 13,
                  color: Color(0xFF006971),
                ),
                const SizedBox(width: 4),
                Text(
                  route,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF006971),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharingOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Document Actions',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF191C1D),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.picture_as_pdf_outlined,
                label: 'Share PDF',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Generating and sharing encrypted PDF...'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.print_outlined,
                label: 'Print',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sent to wireless clinic printer'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.send_to_mobile_rounded,
                label: 'Send to Patient',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Prescription sent to Patient CareID App'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionButton(
                context: context,
                icon: Icons.save_outlined,
                label: 'Save to Records',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved to EHR clinical records'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: const Color(0xFF28006D)),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF191C1D),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryAction(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(91, 20, 184, 0.25),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(9999),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Prescription finalized, digitally signed, and transmitted to EHR vault.',
                  ),
                  backgroundColor: Color(0xFF28006D),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                (route) => false,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Finalize & Sign',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
