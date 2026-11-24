import 'package:material_ui/material_ui.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/screens/home_screen.dart';
import 'tambah_balita_screen.dart';
import '../../koreksi/screens/rincian_kunjungan_screen.dart';

class AnakSayaScreen extends StatefulWidget {
  final String? initialChildName;
  final String? initialChildNik;
  final String? initialTtl;
  final String? initialHubungan;
  final String? initialBbl;
  final String? initialPbl;
  final String? initialJenisKelamin;
  final bool initialStatusPending;
  final bool? hasChildren;

  const AnakSayaScreen({
    super.key,
    this.initialChildName,
    this.initialChildNik,
    this.initialTtl,
    this.initialHubungan,
    this.initialBbl,
    this.initialPbl,
    this.initialJenisKelamin,
    this.initialStatusPending = true,
    this.hasChildren,
  });

  @override
  State<AnakSayaScreen> createState() => _AnakSayaScreenState();
}

class _AnakSayaScreenState extends State<AnakSayaScreen> {
  late int _selectedChildTab; // 0: Rayyan (Verified), 1: Aisyah (Pending)
  late bool _hasChildrenState;
  bool _isRequestCancelled = false;

  @override
  void initState() {
    super.initState();
    _selectedChildTab = widget.initialStatusPending ? 1 : 0;
    _hasChildrenState = widget.hasChildren ?? true;
  }

  void _showNotice(String title, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              message,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _handleCancelRequest() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Permohonan?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan pengajuan verifikasi hubungan keluarga untuk ananda Aisyah Putri?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Kembali', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isRequestCancelled = true;
        _selectedChildTab = 0; // Switch back to Rayyan
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permohonan verifikasi ananda Aisyah Putri telah dibatalkan.'),
          backgroundColor: Color(0xFF64748B),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aisyahName = widget.initialChildName ?? 'Aisyah Putri Rahmawati';
    final aisyahNik = widget.initialChildNik ?? '3314055208260003';
    final aisyahTtl = widget.initialTtl ?? 'Surakarta, 18 Agu 2026';
    final aisyahHubungan = widget.initialHubungan ?? 'Ibu Kandung';
    final aisyahBbl = widget.initialBbl ?? '3.1';
    final aisyahPbl = widget.initialPbl ?? '48.5';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // DEMO STATE SWITCHER (Bisa melihat mode 'Ada Balita' & 'Belum Ada Balita' langsung!)
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _hasChildrenState = true),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _hasChildrenState ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _hasChildrenState
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                : null,
                          ),
                          child: Text(
                            '👶 Ada Balita Tertaut',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: _hasChildrenState ? FontWeight.bold : FontWeight.w500,
                              color: _hasChildrenState ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _hasChildrenState = false),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !_hasChildrenState ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: !_hasChildrenState
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                : null,
                          ),
                          child: Text(
                            '⚪ Belum Ada Balita',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: !_hasChildrenState ? FontWeight.bold : FontWeight.w500,
                              color: !_hasChildrenState ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // KONDISI 1: EMPTY STATE (BELUM ADA BALITA TERTAUT - SCREENSHOT 2)
              // ==========================================
              if (!_hasChildrenState) ...[
                // Header Empty State
                const Text(
                  'Anak Saya',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Rekam Medis Pertumbuhan & Imunisasi Balita',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),

                // Big Circular Stethoscope Illustration with Aura
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE0F7F0), // Mint glow aura
                          border: Border.all(color: const Color(0xFFA7F3D0), width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.favorite_rounded, color: Color(0xFF10B981), size: 36),
                                Positioned(
                                  top: 24,
                                  right: 28,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(color: Color(0xFFFDE68A), shape: BoxShape.circle),
                                    child: const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Badge Belum Ada Balita Tertaut
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, color: Color(0xFF94A3B8), size: 8),
                            SizedBox(width: 8),
                            Text(
                              'Belum Ada Balita Tertaut',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Title & Subtitle
                const Center(
                  child: Text(
                    'Mulai Pantau Tumbuh Kembang Balita',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Tautkan data anak Anda untuk melihat grafik KMS, rekam timbangan Posyandu, buku imunisasi, dan antrean digital.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Big Green Button: Hubungkan Data Anak Sekarang
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                    label: const Text(
                      'Hubungkan Data Anak Sekarang',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Panduan Registrasi Balita Baru
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Panduan Registrasi Balita Baru',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Pilih cara yang paling mudah bagi keluarga Anda:',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),

                      // Cara 1: Online
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.phone_android_rounded, color: Color(0xFF059669), size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. Pengajuan Mandiri Online (Cepat)',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Cukup siapkan NIK Balita & unggah foto Kartu Keluarga (KK).',
                                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Diverifikasi Kader Meja 1 Posyandu dalam 1×24 jam.',
                                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Cara 2: Offline
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.local_hospital_outlined, color: Color(0xFF2563EB), size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '2. Pendaftaran Langsung di Posyandu',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Datang langsung ke Meja 1 saat hari buka Posyandu Melati.',
                                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Kader akan membuatkan buku rekam medis & menautkan akun.',
                                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // WhatsApp Help Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF059669), size: 22),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Butuh Bantuan Menghubungkan Balita?',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hubungi Kader Meja 1 / Bidan Desa Siti Aminah via WhatsApp.',
                              style: TextStyle(fontSize: 10.5, color: Color(0xFF065F46)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => _showNotice(
                          'WhatsApp Kader Meja 1',
                          'Membuka chat WhatsApp dengan Kader Meja 1 / Bidan Desa Siti Aminah.',
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF059669), size: 20),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // ==========================================
                // KONDISI 2: ADA BALITA TERTAUT (POPULATED)
                // ==========================================
                // Top Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Anak Saya',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Data Balita & Rekam Medis Posyandu',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // + Klaim Anak Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Klaim Anak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Child Tabs / Selector Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Tab 1: Muhammad Rayyan (Verified)
                      InkWell(
                        onTap: () => setState(() => _selectedChildTab = 0),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedChildTab == 0
                                ? const Color(0xFF0F172A)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedChildTab == 0 ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('👶 ', style: TextStyle(fontSize: 12)),
                              Text(
                                'Muhammad Rayyan',
                                style: TextStyle(
                                  color: _selectedChildTab == 0 ? Colors.white : const Color(0xFF475569),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Tab 2: Aisyah Putri (Pending)
                      if (!_isRequestCancelled)
                        InkWell(
                          onTap: () => setState(() => _selectedChildTab = 1),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedChildTab == 1
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedChildTab == 1 ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('👧 ', style: TextStyle(fontSize: 12)),
                                Text(
                                  'Aisyah Putri',
                                  style: TextStyle(
                                    color: _selectedChildTab == 1 ? Colors.white : const Color(0xFF475569),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Pending ⏳',
                                    style: TextStyle(
                                      color: Color(0xFF92400E),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // TAB CONTENT
                if (_selectedChildTab == 1 && !_isRequestCancelled) ...[
                  // Aisyah Putri (Pending Verification State)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE047)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF59E0B)),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFB45309), size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Akses Rekam Medis Belum Terbuka',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF78350F),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Permohonan hubungan keluarga untuk ananda Aisyah Putri sedang menunggu verifikasi dokumen KK oleh Kader Posyandu.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF92400E),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Child Profile Card (Aisyah)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFFDE68A)),
                              ),
                              alignment: Alignment.center,
                              child: const Text('👧', style: TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    aisyahName,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Perempuan • Usia 3 Bulan (Kategori Bayi)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Menunggu Verifikasi ⏳',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('NIK Balita', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                                  const SizedBox(height: 2),
                                  Text(
                                    aisyahNik,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TTL', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                                  const SizedBox(height: 2),
                                  Text(
                                    aisyahTtl,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Hubungan', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                                  const SizedBox(height: 2),
                                  Text(
                                    aisyahHubungan,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Data Lahir', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                                  const SizedBox(height: 2),
                                  Text(
                                    'BBL $aisyahBbl kg • $aisyahPbl cm',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Stepper Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pelacakan Status Pengajuan',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Pantau tahap verifikasi berkas oleh Kader Posyandu Melati',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 16),

                        _buildStepperItem(
                          isFirst: true,
                          isDone: true,
                          title: 'Permohonan Dikirimkan',
                          subtitle: '15 Nov 2026, 14:20 WIB • Oleh Ibu Sarah',
                        ),
                        _buildStepperItem(
                          isDone: true,
                          title: 'Dokumen Bukti Terlampir',
                          customSubtitle: Row(
                            children: [
                              const Icon(Icons.description_outlined, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              const Text('KK_Sarah_2026.jpg (1.4 MB) • ', style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                              InkWell(
                                onTap: () => _showNotice('Dokumen KK', 'File Kartu Keluarga telah berhasil diunggah.'),
                                child: const Text('Lihat ↗', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                              ),
                            ],
                          ),
                        ),
                        _buildStepperItem(
                          isLast: true,
                          isInProgress: true,
                          title: 'Sedang Ditinjau oleh Kader Meja 1',
                          subtitle: 'Posyandu Melati RW 03 (Estimasi verifikasi <24 jam)',
                          titleColor: const Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Privacy Notice
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.verified_user_outlined, color: Color(0xFF2563EB), size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Perlindungan Privasi Medis Balita',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Sesuai Permenkes No. 24/2022, akses riwayat timbangan & rekam imunisasi hanya terbuka setelah KK disetujui Kader.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _showNotice(
                        'Hubungi Kader Posyandu',
                        'Membuka percakapan WhatsApp resmi dengan Kader Meja 1 Posyandu Melati RW 03.',
                      ),
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                      label: const Text('Hubungi Kader Posyandu (WhatsApp)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: _handleCancelRequest,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Batalkan Permohonan Hubungan Anak',
                        style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 12.5),
                      ),
                    ),
                  ),
                ] else ...[
                  // Muhammad Rayyan (Verified Record)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_outlined, color: Color(0xFF059669), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Data Rekam Medis Balita Resmi Terverifikasi',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Health Stats Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Muhammad Rayyan Al-Ghifari',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Usia: 14 Bulan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kunjungan Terakhir: 10 Nov 2026 • Kader: Ibu Siti Aminah',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(child: _buildMetricItem(title: 'Berat Badan (BB)', value: '9.8', unit: 'kg', badge: '↑ +0.3 kg')),
                            const SizedBox(width: 10),
                            Expanded(child: _buildMetricItem(title: 'Tinggi Badan (TB)', value: '78.2', unit: 'cm', badge: '↑ +1.1 cm')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildMetricItem(title: 'Lingkar Kepala (LK)', value: '46.5', unit: 'cm', badge: 'Tercatat', badgeColor: const Color(0xFF2563EB))),
                            const SizedBox(width: 10),
                            Expanded(child: _buildMetricItem(title: 'Lingkar Lengan (LiLA)', value: '14.2', unit: 'cm', badge: 'Tercatat', badgeColor: const Color(0xFF2563EB))),
                          ],
                        ),
                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            Text('Layanan Diterima: ', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            Text('💊 Vit. A ✓   💉 PCV 1 ✓   🥣 PMT Balita ✓', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                          ],
                        ),
                        const SizedBox(height: 12),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RincianKunjunganScreen()),
                            );
                          },
                          child: const Text(
                            'Buka Riwayat Lengkap Pengukuran Balita →',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: 1, // Anak Saya active
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RincianKunjunganScreen()));
            } else if (index != 1) {
              final titles = ['Beranda', 'Anak Saya', 'Jadwal', 'Riwayat', 'Profil'];
              _showNotice(titles[index], 'Halaman ${titles[index]} sedang dipersiapkan.');
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF059669),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.sentiment_satisfied_alt_outlined), label: 'Anak Saya'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Jadwal'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperItem({
    bool isFirst = false,
    bool isLast = false,
    bool isDone = false,
    bool isInProgress = false,
    required String title,
    String? subtitle,
    Widget? customSubtitle,
    Color? titleColor,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isDone
                      ? const Color(0xFFECFDF5)
                      : (isInProgress ? const Color(0xFFFEF3C7) : Colors.grey.shade200),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone
                        ? const Color(0xFF059669)
                        : (isInProgress ? const Color(0xFFD97706) : Colors.grey.shade400),
                    width: isInProgress ? 2.5 : 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: Color(0xFF059669))
                    : (isInProgress
                        ? Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFD97706), shape: BoxShape.circle))
                        : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? const Color(0xFF10B981) : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: titleColor ?? const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (customSubtitle != null)
                    customSubtitle
                  else if (subtitle != null)
                    Text(subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required String unit,
    required String badge,
    Color badgeColor = const Color(0xFF059669),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const Spacer(),
              Text(badge, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: badgeColor)),
            ],
          ),
        ],
      ),
    );
  }
}
