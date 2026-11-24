import 'package:material_ui/material_ui.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';
import '../../children/screens/anak_saya_screen.dart';
import '../../children/screens/tambah_balita_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../jadwal/screens/jadwal_posyandu_screen.dart';
import '../../koreksi/screens/rincian_kunjungan_screen.dart';
import 'ubah_kata_sandi_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Map<String, dynamic>? _profile;
  int _childCount = 2;
  bool _waReminderEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final results = await Future.wait([
        authService.getProfile(),
        authService.getChildren(),
      ]);
      if (!mounted) return;
      final profile = results[0] as Map<String, dynamic>?;
      final children = results[1] as List<Map<String, dynamic>>;
      setState(() {
        _profile = profile;
        if (children.isNotEmpty) {
          _childCount = children.length;
        }
      });
    } catch (_) {}
  }

  String get _displayName {
    final raw = _profile?['nama_lengkap'] ??
        authService.currentUser?.userMetadata?['nama_lengkap'] ??
        'Siti Aminah';
    return raw.toString().trim().isEmpty ? 'Siti Aminah' : raw.toString();
  }

  String get _displayPhone {
    final raw = _profile?['no_hp'] ??
        authService.currentUser?.userMetadata?['no_hp'] ??
        '+62 812-3456-7890';
    return raw.toString().trim().isEmpty ? '+62 812-3456-7890' : raw.toString();
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Soft red logout icon circle
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Keluar dari Akun?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        height: 1.45,
                      ),
                      children: [
                        const TextSpan(text: 'Apakah Anda yakin ingin keluar dari akun '),
                        TextSpan(
                          text: '$_displayName?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const TextSpan(
                          text: '\nAnda harus memasukkan nomor HP dan sandi kembali saat hendak masuk ke aplikasi.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Green WA reminder banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pengingat WhatsApp Tetap Aktif',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                              Text(
                                'Broadcast jadwal H-1 tetap dikirim ke $_displayPhone',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Batal & Ya, Keluar buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx, false),
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx, true),
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout_rounded, color: Colors.white, size: 17),
                                SizedBox(width: 6),
                                Text(
                                  'Ya, Keluar',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Ketuk di luar kotak dialog untuk membatalkan',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      await authService.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ==========================================
          // 1. DARK GREEN GRADIENT HEADER
          // ==========================================
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 18,
              left: 20,
              right: 20,
              bottom: 22,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF065F46),
                  Color(0xFF064E3B),
                  Color(0xFF0F172A),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with green + badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF34D399), width: 2.5),
                      ),
                      child: const Icon(
                        Icons.face_retouching_natural_rounded,
                        color: Color(0xFFB45309),
                        size: 30,
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF064E3B), width: 2),
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // Name, verified pill, NIK, KK
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 6, color: Color(0xFFA7F3D0)),
                            SizedBox(width: 5),
                            Text(
                              'Orang Tua Terverifikasi ✓',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'NIK: 3372015508920003\nNo. KK: 3372011905180002',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF94A3B8),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit icon button
                GestureDetector(
                  onTap: () => _showInfoDialog(
                    'Edit Profil',
                    'Perubahan data NIK & Kartu Keluarga dilakukan melalui verifikasi Kader Meja 1 Posyandu Melati RW 03.',
                  ),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. SCROLLABLE MENU LIST
          // ==========================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // WhatsApp Gateway Card
                  GestureDetector(
                    onTap: () => _showInfoDialog(
                      'WhatsApp Gateway Aktif',
                      'Nomor $_displayPhone terhubung ke sistem pengingat H-1 Posyandu Melati RW 03.',
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF10B981), width: 1.3),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFECFDF5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_rounded, color: Color(0xFF059669), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _displayPhone,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '● Terhubung WhatsApp Gateway (Pengingat H-1)',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Posyandu Binaan Card
                  GestureDetector(
                    onTap: () => _showInfoDialog(
                      'Posyandu Binaan',
                      'Posyandu Melati RW 03 • Kel. Jebres\nPuskesmas Pembina: Jebres\nBidan Pembina: Bd. Sri Wahyuni',
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.apartment_rounded, color: Color(0xFF2563EB), size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Posyandu Melati RW 03 • Kel. Jebres',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Pusk. Pembina: Jebres • Bidan: Bd. Sri Wahyuni',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // DATA KELUARGA & ANAK
                  const Text(
                    'DATA KELUARGA & ANAK',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          icon: Icons.sentiment_satisfied_alt_rounded,
                          iconBg: const Color(0xFFFEF3C7),
                          iconColor: const Color(0xFFD97706),
                          title: 'Data Balita Saya ($_childCount Terdaftar)',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AnakSayaScreen()),
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildMenuTile(
                          icon: Icons.add_rounded,
                          iconBg: const Color(0xFFECFDF5),
                          iconColor: const Color(0xFF059669),
                          title: 'Tambah Balita Baru (Daftarkan)',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // KEAMANAN & NOTIFIKASI
                  const Text(
                    'KEAMANAN & NOTIFIKASI',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          icon: Icons.lock_outline_rounded,
                          iconBg: const Color(0xFFF1F5F9),
                          iconColor: const Color(0xFF334155),
                          title: 'Ganti Kata Sandi (Password)',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UbahKataSandiScreen()),
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFECFDF5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Color(0xFF059669),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Pengingat WhatsApp H-1',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Switch(
                                value: _waReminderEnabled,
                                activeThumbColor: Colors.white,
                                activeTrackColor: const Color(0xFF10B981),
                                onChanged: (val) {
                                  setState(() => _waReminderEnabled = val);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        val
                                            ? 'Pengingat WhatsApp H-1 diaktifkan.'
                                            : 'Pengingat WhatsApp H-1 dinonaktifkan.',
                                      ),
                                      backgroundColor: const Color(0xFF065F46),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // BANTUAN & INFORMASI RESMI
                  const Text(
                    'BANTUAN & INFORMASI RESMI',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          icon: Icons.phone_in_talk_outlined,
                          iconBg: const Color(0xFFEFF6FF),
                          iconColor: const Color(0xFF2563EB),
                          title: 'Hubungi Bidan Desa & Kader',
                          onTap: () => _showInfoDialog(
                            'Hubungi Bidan & Kader',
                            'Bidan Desa: Bd. Sri Wahyuni\nKader Meja 1: Ibu Siti Aminah\nWhatsApp Posyandu: +62 812-0000-0303',
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildMenuTile(
                          icon: Icons.description_outlined,
                          iconBg: const Color(0xFFFEF3C7),
                          iconColor: const Color(0xFFD97706),
                          title: 'Panduan Layanan 5 Meja ILP',
                          onTap: () => _showInfoDialog(
                            'Panduan Layanan 5 Meja ILP',
                            'Meja 1: Pendaftaran & Check-In QR\nMeja 2: Penimbangan & Pengukuran Antropometri\nMeja 3: Pencatatan Buku KIA & KMS Digital\nMeja 4: Penyuluhan Gizi, Vitamin A & PMT\nMeja 5: Imunisasi & Pelayanan Kesehatan Nakes',
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildMenuTile(
                          icon: Icons.info_outline_rounded,
                          iconBg: const Color(0xFFF1F5F9),
                          iconColor: const Color(0xFF475569),
                          title: 'Tentang Aplikasi & Privasi Data',
                          onTap: () => _showInfoDialog(
                            'Tentang SapaSehat',
                            'SapaSehat Mobile v1.0.0 (MVP)\nDinas Kesehatan Kota Surakarta\nSeluruh data rekam medis balita terenkripsi sesuai standar Permenkes 24/2022.',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Keluar dari Akun button
                  GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Keluar dari Akun',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'SapaSehat Mobile v1.0.0 (MVP) • Dinkes Kota Surakarta',
                      style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ==========================================
      // BOTTOM NAVIGATION BAR (Profil Active)
      // ==========================================
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AnakSayaScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const JadwalPosyanduScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RincianKunjunganScreen()),
            );
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_satisfied_alt_outlined),
            activeIcon: Icon(Icons.sentiment_satisfied_alt_rounded),
            label: 'Anak Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month_rounded),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
