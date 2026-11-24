import 'package:material_ui/material_ui.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';
import '../../children/screens/tambah_balita_screen.dart';
import '../../children/screens/anak_saya_screen.dart';
import '../../koreksi/screens/rincian_kunjungan_screen.dart';
import '../../koreksi/screens/formulir_koreksi_screen.dart';
import '../../imunisasi/screens/buku_imunisasi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _children = [];
  bool _isLoading = true;
  int _selectedTabIndex = 0; // Bottom nav index
  int _selectedChildIndex = 0; // Child tab index

  bool get _hasChildren => _children.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        authService.getProfile(),
        authService.getChildren(),
      ]);
      if (mounted) {
        setState(() {
          _profile = results[0] as Map<String, dynamic>?;
          _children = results[1] as List<Map<String, dynamic>>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String _getUserDisplayName() {
    final rawName = _profile?['nama_lengkap'] ??
        authService.currentUser?.userMetadata?['nama_lengkap'];
    if (rawName != null && rawName.toString().trim().isNotEmpty) {
      final trimmed = rawName.toString().trim();
      if (trimmed.toLowerCase().startsWith('ibu ') ||
          trimmed.toLowerCase().startsWith('bunda ') ||
          trimmed.toLowerCase().startsWith('ayah ') ||
          trimmed.toLowerCase().startsWith('pak ')) {
        return trimmed;
      }
      return 'Ibu $trimmed';
    }
    return 'Ibu Sarah';
  }

  String _getInitials(String name) {
    final cleaned = name.replaceAll(RegExp(r'^(Ibu|Bunda|Ayah|Pak)\s+', caseSensitive: false), '').trim();
    final parts = cleaned.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'IS';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi SapaSehat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Keluar'),
          ),
        ],
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

  void _showAddChildDialog({bool isKlaim = false}) {
    final nameController = TextEditingController(text: isKlaim ? '' : 'Muhammad Rayyan Al-Ghifari');
    final nikController = TextEditingController(text: isKlaim ? '3201123456780001' : '');
    final usiaController = TextEditingController(text: '14');
    String jenisKelamin = 'Laki-laki';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
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
                        color: isKlaim ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isKlaim ? Icons.link_rounded : Icons.child_care_rounded,
                        color: isKlaim ? const Color(0xFF2563EB) : const Color(0xFF059669),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isKlaim ? 'Klaim Data Anak' : 'Daftarkan Anak Baru',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Fields
                Text(
                  isKlaim ? 'Nomor Induk Kependudukan (NIK) Anak / KIA' : 'Nama Lengkap Anak Balita',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: isKlaim ? nikController : nameController,
                  decoration: InputDecoration(
                    hintText: isKlaim ? 'Contoh: 3201xxxxxxxxxxxx' : 'Contoh: Muhammad Rayyan',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (!isKlaim) ...[
                  const Text(
                    'Usia Balita (Bulan)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: usiaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Contoh: 14',
                      suffixText: 'Bulan',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Jenis Kelamin',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Laki-laki')),
                          selected: jenisKelamin == 'Laki-laki',
                          selectedColor: const Color(0xFFECFDF5),
                          labelStyle: TextStyle(
                            color: jenisKelamin == 'Laki-laki' ? const Color(0xFF059669) : const Color(0xFF475569),
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) => setModalState(() => jenisKelamin = 'Laki-laki'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Perempuan')),
                          selected: jenisKelamin == 'Perempuan',
                          selectedColor: const Color(0xFFECFDF5),
                          labelStyle: TextStyle(
                            color: jenisKelamin == 'Perempuan' ? const Color(0xFF059669) : const Color(0xFF475569),
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) => setModalState(() => jenisKelamin = 'Perempuan'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      final childName = isKlaim
                          ? 'Muhammad Rayyan Al-Ghifari'
                          : (nameController.text.trim().isEmpty ? 'Muhammad Rayyan Al-Ghifari' : nameController.text.trim());
                      final age = int.tryParse(usiaController.text) ?? 14;

                      final newChild = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'nama_anak': childName,
                        'usia_bulan': age,
                        'jenis_kelamin': jenisKelamin,
                        'berat_badan': '9.8',
                        'tinggi_badan': '78.2',
                        'lingkar_kepala': '46.5',
                        'lingkar_lengan': '14.2',
                        'kunjungan_terakhir': '10 Nov 2026',
                        'kader': 'Ibu Siti Aminah',
                        'status_verifikasi': 'terverifikasi',
                      };

                      setState(() {
                        _children.add(newChild);
                        _selectedChildIndex = _children.length - 1;
                      });

                      Navigator.pop(ctx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF059669),
                          content: Text(
                            isKlaim
                                ? 'Berhasil! Data anak berhasil diklaim dan diverifikasi.'
                                : 'Berhasil! Data anak $childName berhasil didaftarkan.',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      isKlaim ? 'Klaim Sekarang' : 'Daftarkan Sekarang',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeatureNotice(String title, String description) {
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showProfileSheet() {
    final displayName = _getUserDisplayName();
    final email = _profile?['email'] ?? authService.currentUser?.email ?? '-';
    final noHp = _profile?['no_hp'] ?? authService.currentUser?.userMetadata?['no_hp'] ?? '-';
    final initials = _getInitials(displayName);

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
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0D9488), width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Color(0xFF0F766E),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Peran: Wali / Orang Tua Balita',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(email, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  const Divider(height: 18, color: Color(0xFFE2E8F0)),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(noHp, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _handleLogout();
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Keluar dari Akun', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _getUserDisplayName();
    final initials = _getInitials(displayName);
    final greeting = _getTimeGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Stack(
              children: [
                // Soft background gradient aura at the top
                Positioned(
                  top: -80,
                  left: -40,
                  right: -40,
                  height: 320,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.4, -0.6),
                        radius: 1.2,
                        colors: [
                          Color(0xFFE0F7F0), // Mint glow
                          Color(0xFFF0FDF4),
                          Color(0xFFF8FAFC),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Main Scrollable Content
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        // ==========================================
                        // 1. TOP HEADER & PROFILE
                        // ==========================================
                        Row(
                          children: [
                            // Avatar Circle
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFCCFBF1), // soft teal mint
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF0D9488), // teal border
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  color: Color(0xFF0F766E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Greeting & Posyandu Location
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$greeting, $displayName 👋',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.home_work_outlined,
                                        size: 15,
                                        color: Color(0xFF0D9488),
                                      ),
                                      const SizedBox(width: 4),
                                      const Expanded(
                                        child: Text(
                                          'Posyandu Melati RW 03 • Kel. Karanganyar',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF475569),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Notification Bell Icon with Badge
                            InkWell(
                              onTap: () {
                                _showFeatureNotice(
                                  'Notifikasi Posyandu',
                                  '1. Jadwal Pelayanan Posyandu Melati RW 03: Rabu, 25 Nov 2026.\n'
                                  '2. Pemberian Kapsul Vitamin A & Wajib Bawa KIA Fisik.',
                                );
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.notifications_none_rounded,
                                      color: Color(0xFF1E293B),
                                      size: 24,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          '2',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ==========================================
                        // 2-5. CONDITIONAL: CHILD DATA or EMPTY STATE
                        // (Pengumuman Resmi, Status Akun Terhubung, & Kartu Anak
                        //  hanya muncul ketika sudah ada anak / baru mendaftarkan anak)
                        // ==========================================
                        if (_hasChildren) ...[
                          // --- PENGUMUMAN RESMI POSYANDU BANNER ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB), // Soft yellow
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFDE047), // Amber yellow border
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Pill Tag
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('📢 ', style: TextStyle(fontSize: 10)),
                                          Text(
                                            'PENGUMUMAN RESMI POSYANDU',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text(
                                      'Bidan Siti • 20 Nov',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF78350F),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Pemberian Kapsul Vitamin A & Wajib Bawa KIA Fisik',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF78350F),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    _showFeatureNotice(
                                      'Pemberian Vitamin A',
                                      'Pelayanan Posyandu tanggal 25 Nov 2026 menyediakan suplementasi Vitamin A dosis tinggi untuk Balita. '
                                      'Orang tua wajib membawa buku KIA (Kesehatan Ibu dan Anak) fisik untuk pencatatan resmi.',
                                    );
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Pelayanan 25 Nov menyediakan Vitamin A. Bawa buku KIA... ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF92400E),
                                        height: 1.3,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Baca →',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB45309),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // --- VERIFIED ACCOUNT BANNER ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFA7F3D0),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_outlined,
                                  color: Color(0xFF059669),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Akun Terhubung: ${_children.length} Anak Balita Terverifikasi Resmi',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF065F46),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AnakSayaScreen(initialStatusPending: false),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Kelola ↗',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // --- CHILD TABS ---
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Dynamic child tabs from database
                                ..._children.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final child = entry.value;
                                  final namaAnak = child['nama_anak'] ?? 'Anak ${idx + 1}';
                                  final namaPendek = namaAnak.toString().split(' ').take(2).join(' ');
                                  final isSelected = _selectedChildIndex == idx;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: InkWell(
                                      onTap: () => setState(() => _selectedChildIndex = idx),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF0F172A)
                                                : const Color(0xFFCBD5E1),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('👶 ', style: TextStyle(fontSize: 12)),
                                            Text(
                                              '$namaPendek ✓',
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : const Color(0xFF475569),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                // + Klaim Anak tab
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: const Text(
                                      '+ Klaim Anak',
                                      style: TextStyle(
                                        color: Color(0xFF475569),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // --- CHILD HEALTH STATS CARD (from selected child) ---
                          Builder(builder: (context) {
                            final selectedChild = _selectedChildIndex < _children.length
                                ? _children[_selectedChildIndex]
                                : _children.first;
                            final namaAnak = selectedChild['nama_anak'] ?? 'Anak';
                            final usia = selectedChild['usia_bulan']?.toString() ?? '-';
                            final bb = selectedChild['berat_badan']?.toString() ?? '-';
                            final tb = selectedChild['tinggi_badan']?.toString() ?? '-';
                            final lk = selectedChild['lingkar_kepala']?.toString() ?? '-';
                            final lila = selectedChild['lingkar_lengan']?.toString() ?? '-';
                            final kunjunganTerakhir = selectedChild['kunjungan_terakhir'] ?? '-';
                            final kader = selectedChild['kader'] ?? '-';

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          namaAnak,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Usia: $usia Bulan',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kunjungan Terakhir: $kunjunganTerakhir • Kader: $kader',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // 2x2 Metrics Grid
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildMetricCard(
                                          title: 'Berat Badan (BB)',
                                          value: bb,
                                          unit: 'kg',
                                          badgeText: '↑ Tercatat',
                                          badgeColor: const Color(0xFF059669),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _buildMetricCard(
                                          title: 'Tinggi Badan (TB)',
                                          value: tb,
                                          unit: 'cm',
                                          badgeText: '↑ Tercatat',
                                          badgeColor: const Color(0xFF059669),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildMetricCard(
                                          title: 'Lingkar Kepala (LK)',
                                          value: lk,
                                          unit: 'cm',
                                          badgeText: 'Tercatat',
                                          badgeColor: const Color(0xFF2563EB),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _buildMetricCard(
                                          title: 'Lingkar Lengan (LiLA)',
                                          value: lila,
                                          unit: 'cm',
                                          badgeText: 'Tercatat',
                                          badgeColor: const Color(0xFF2563EB),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  // Layanan Diterima Tags
                                  Row(
                                    children: [
                                      const Text(
                                        'Layanan Diterima:',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              _buildServiceTag('💊 Vit. A ✓'),
                                              const SizedBox(width: 6),
                                              _buildServiceTag('💉 PCV 1 ✓'),
                                              const SizedBox(width: 6),
                                              _buildServiceTag('🥣 PMT Balita ✓'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const RincianKunjunganScreen(),
                                        ),
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          'Buka Riwayat Lengkap Pengukuran Balita →',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF059669),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 20),
                        ] else ...[
                          // ==========================================
                          // EMPTY STATE: Belum ada anak terdaftar
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Illustration Icon
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFDE68A),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.child_care_rounded,
                                    color: Color(0xFFD97706),
                                    size: 36,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum Ada Anak Terdaftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Daftarkan atau klaim data anak balita Anda untuk melihat grafik tumbuh kembang, riwayat imunisasi, dan jadwal Posyandu.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Action buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                                          );
                                        },
                                        icon: const Icon(Icons.link_rounded, size: 18),
                                        label: const Text('Klaim Anak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF2563EB),
                                          side: const BorderSide(color: Color(0xFF2563EB)),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                                          );
                                        },
                                        icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                                        label: const Text('Daftarkan Anak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF059669),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],

                        // ==========================================
                        // 6. MENU CEPAT & LAYANAN MANDIRI
                        // ==========================================
                        const Text(
                          'Menu Cepat & Layanan Mandiri',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Akses langsung ke formulir pendaftaran dan administrasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            // 1. Daftar Antrean (Special highlight with BUKA badge)
                            Expanded(
                              child: _buildQuickMenuItem(
                                title: 'Daftar Antrean',
                                icon: Icons.event_available_rounded,
                                iconColor: const Color(0xFF059669),
                                iconBgColor: const Color(0xFFECFDF5),
                                borderColor: const Color(0xFF10B981),
                                badgeText: 'BUKA',
                                isPrimary: true,
                                onTap: () {
                                  _showFeatureNotice(
                                    'Daftar Antrean',
                                    'Pendaftaran antrean online Posyandu Melati RW 03 telah dibuka untuk jadwal Rabu, 25 Nov 2026.',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 2. Klaim Anak
                            Expanded(
                              child: _buildQuickMenuItem(
                                title: 'Klaim Anak',
                                icon: Icons.person_add_alt_1_rounded,
                                iconColor: const Color(0xFF2563EB),
                                iconBgColor: const Color(0xFFEFF6FF),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TambahBalitaScreen()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 3. Koreksi Data
                            Expanded(
                              child: _buildQuickMenuItem(
                                title: 'Koreksi Data',
                                icon: Icons.edit_note_rounded,
                                iconColor: const Color(0xFFD97706),
                                iconBgColor: const Color(0xFFFEF3C7),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const FormulirKoreksiScreen()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 4. Buku Imunisasi
                            Expanded(
                              child: _buildQuickMenuItem(
                                title: 'Buku Imunisasi',
                                icon: Icons.vaccines_rounded,
                                iconColor: const Color(0xFF7C3AED),
                                iconBgColor: const Color(0xFFF5F3FF),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const BukuImunisasiScreen()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ==========================================
                        // 7. UPCOMING SCHEDULE CARD (DARK GREEN)
                        // ==========================================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46), // Deep forest green
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF065F46).withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row Badges
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF047857),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'JADWAL H-2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Rabu, 25 Nov 2026',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Sisa 12 Slot ⏳',
                                      style: TextStyle(
                                        color: Color(0xFF92400E),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Schedule Title
                              const Text(
                                'Pelayanan Rutin Posyandu Melati RW 03',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Location info
                              Text(
                                '📍 Balai RW 03 • 08:00 - 11:30 WIB • Timbang & PCV 2',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.88),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Nested White Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF59E0B), // Orange dot
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _hasChildren
                                                ? '${_children[_selectedChildIndex < _children.length ? _selectedChildIndex : 0]['nama_anak'] ?? 'Anak'} belum terdaftar pada jadwal ini'
                                                : 'Belum ada balita terdaftar pada jadwal ini',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 16.0, top: 2),
                                      child: Text(
                                        'Ambil nomor antrean & tentukan estimasi jam kedatangan',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Booking Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!_hasChildren) {
                                            _showAddChildDialog(isKlaim: false);
                                            return;
                                          }
                                          final currentChild = _children[_selectedChildIndex < _children.length ? _selectedChildIndex : 0];
                                          final nama = currentChild['nama_anak'] ?? 'Balita';
                                          _showFeatureNotice(
                                            'Booking Antrean Online',
                                            'Nomor antrean berhasil dibuat:\n'
                                            '• Nomor: A-14\n'
                                            '• Estimasi Kedatangan: 09:15 - 09:45 WIB\n'
                                            '• Pasien: $nama\n'
                                            'Silakan datang tepat waktu dan tunjukkan nomor antrean ini ke kader.',
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF059669),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.confirmation_number_outlined, size: 18),
                                            SizedBox(width: 8),
                                            Text(
                                              'Booking Antrean Online Sekarang →',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),

      // ==========================================
      // 8. BOTTOM NAVIGATION BAR
      // ==========================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() => _selectedTabIndex = index);
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnakSayaScreen()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RincianKunjunganScreen()),
              );
            } else if (index == 4) {
              _showProfileSheet();
            } else if (index != 0) {
              final titles = ['Beranda', 'Anak Saya', 'Jadwal', 'Riwayat', 'Profil'];
              _showFeatureNotice(
                titles[index],
                'Halaman ${titles[index]} sedang dipersiapkan untuk sinkronisasi data Posyandu.',
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color(0xFF059669),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
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
      ),
    );
  }

  // -------------------------------------------------------------
  // HELPER WIDGETS
  // -------------------------------------------------------------

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required String badgeText,
    required Color badgeColor,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF065F46),
        ),
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    Color? borderColor,
    String? badgeText,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor ?? const Color(0xFFE2E8F0),
            width: isPrimary ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isPrimary ? iconColor : const Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (badgeText != null)
              Positioned(
                top: -12,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
