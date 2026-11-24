import 'package:material_ui/material_ui.dart';
import '../../children/screens/anak_saya_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../jadwal/screens/jadwal_posyandu_screen.dart';
import '../../koreksi/screens/rincian_kunjungan_screen.dart';

class UbahKataSandiScreen extends StatefulWidget {
  const UbahKataSandiScreen({super.key});

  @override
  State<UbahKataSandiScreen> createState() => _UbahKataSandiScreenState();
}

class _UbahKataSandiScreenState extends State<UbahKataSandiScreen> {
  final _oldController = TextEditingController(text: 'SapaSehat2025!');
  final _newController = TextEditingController(text: 'PosyanduMelati#26');
  final _confirmController = TextEditingController(text: 'PosyanduMelati#26');

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _isSaving = false;

  bool get _hasMinLength => _newController.text.length >= 8;
  bool get _hasUpperAndLower =>
      RegExp(r'[A-Z]').hasMatch(_newController.text) &&
      RegExp(r'[a-z]').hasMatch(_newController.text);
  bool get _hasDigit => RegExp(r'[0-9]').hasMatch(_newController.text);
  bool get _hasSymbol => RegExp(r'[@$!%*#?&]').hasMatch(_newController.text);

  int get _strengthCount {
    int count = 0;
    if (_hasMinLength) count++;
    if (_hasUpperAndLower) count++;
    if (_hasDigit) count++;
    if (_hasSymbol) count++;
    return count;
  }

  bool get _passwordsMatch =>
      _confirmController.text.isNotEmpty &&
      _newController.text == _confirmController.text;

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (_oldController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kata sandi saat ini terlebih dahulu.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }
    if (_strengthCount < 4 || !_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan kata sandi baru memenuhi semua kriteria dan cocok persis.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kata sandi berhasil diperbarui & disinkronkan ke server Dinkes!'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final strength = _strengthCount;
    final strengthLabel = strength == 4
        ? 'Kuat ✓'
        : (strength >= 2 ? 'Sedang' : 'Lemah');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 68,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0F172A), size: 22),
              ),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubah Kata Sandi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Perbarui Keamanan Akun SapaSehat',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.info_outline_rounded, color: Color(0xFF475569), size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. DARK GREEN SHIELD BANNER
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF065F46), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Color(0xFF34D399), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lindungi Akun & Data Balita',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Gunakan kombinasi sandi yang kuat untuk menjaga keamanan rekam medis Buku KIA Digital keluarga.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFCBD5E1),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ==========================================
            // 2. KATA SANDI SAAT INI
            // ==========================================
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                children: [
                  TextSpan(text: 'Kata Sandi Saat Ini '),
                  TextSpan(text: '*', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: TextField(
                controller: _oldController,
                obscureText: _obscureOld,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF64748B), size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureOld ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureOld = !_obscureOld),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tautan reset kata sandi telah dikirim via WhatsApp.'),
                      backgroundColor: Color(0xFF065F46),
                    ),
                  );
                },
                child: const Text(
                  'Lupa kata sandi lama? Reset via WhatsApp →',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // 3. KATA SANDI BARU
            // ==========================================
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                children: [
                  TextSpan(text: 'Kata Sandi Baru '),
                  TextSpan(text: '*', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981), width: 1.5),
              ),
              child: TextField(
                controller: _newController,
                obscureText: _obscureNew,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF059669), size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Strength indicator bar
            Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i < strength ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  if (i < 3) const SizedBox(width: 6),
                ],
                const SizedBox(width: 10),
                Text(
                  strengthLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: strength == 4 ? const Color(0xFF059669) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Criteria box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KRITERIA KATA SANDI AMAN:',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF065F46),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildCriteriaItem('Minimal 8 karakter', _hasMinLength)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildCriteriaItem('Huruf besar (A-Z) & kecil (a-z)', _hasUpperAndLower)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _buildCriteriaItem('Memuat angka (0-9)', _hasDigit)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildCriteriaItem('Simbol / karakter (@\$!%*#?&)', _hasSymbol)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // 4. KONFIRMASI KATA SANDI BARU
            // ==========================================
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                children: [
                  TextSpan(text: 'Konfirmasi Kata Sandi Baru '),
                  TextSpan(text: '*', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _passwordsMatch ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                  width: _passwordsMatch ? 1.5 : 1,
                ),
              ),
              child: TextField(
                controller: _confirmController,
                obscureText: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: _passwordsMatch ? const Color(0xFF059669) : const Color(0xFF64748B),
                    size: 20,
                  ),
                  suffixIcon: _passwordsMatch
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Color(0xFF10B981),
                            child: Icon(Icons.check_rounded, color: Colors.white, size: 13),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            if (_passwordsMatch) ...[
              const SizedBox(height: 6),
              const Text(
                '✓ Kata sandi baru cocok persis',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // ==========================================
            // 5. PEMBERITAHUAN SESI KEAMANAN
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_rounded, color: Color(0xFF64748B), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pemberitahuan Sesi Keamanan:',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Setelah kata sandi berhasil diperbarui, seluruh sesi login pada perangkat lain akan dikeluarkan secara otomatis demi keamanan akun Anda.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ==========================================
            // 6. SIMPAN KATA SANDI BARU BUTTON
            // ==========================================
            GestureDetector(
              onTap: _isSaving ? null : _savePassword,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isSaving)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    else ...[
                      const Icon(Icons.vpn_key_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Simpan Kata Sandi Baru',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Perubahan akan langsung tersinkronisasi ke server Dinas Kesehatan.',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildCriteriaItem(String label, bool met) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 14,
          color: met ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: met ? const Color(0xFF065F46) : const Color(0xFF64748B),
            ),
          ),
        ),
      ],
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
          } else if (index == 4) {
            Navigator.pop(context);
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
