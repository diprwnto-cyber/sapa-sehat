import 'package:material_ui/material_ui.dart';
import '../../../core/services/antrean_state.dart';
import '../../children/screens/anak_saya_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../koreksi/screens/rincian_kunjungan_screen.dart';
import '../../profil/screens/profil_screen.dart';
import 'tiket_antrean_screen.dart';

class PendaftaranKunjunganScreen extends StatefulWidget {
  const PendaftaranKunjunganScreen({super.key});

  @override
  State<PendaftaranKunjunganScreen> createState() => _PendaftaranKunjunganScreenState();
}

class _PendaftaranKunjunganScreenState extends State<PendaftaranKunjunganScreen> {
  int _selectedChild = 0; // 0: M. Rayyan, 1: Aisyah Putri
  int _selectedSession = 1; // 1: Sesi 2 (09:00 - 10:00), 2: Sesi 3 (10:00 - 11:30)
  bool _svcImunisasi = true;
  bool _svcVitA = true;
  bool _svcKonseling = false;
  final _catatanController = TextEditingController(
    text: 'Rayyan agak batuk ringan 2 hari, ingin konsultasi ke Bidan Desa.',
  );

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    final nama = _selectedChild == 0 ? 'M. Rayyan' : 'Aisyah Putri';
    final usia = _selectedChild == 0 ? '14 Bulan' : '3 Bulan';
    final sesi = _selectedSession == 1
        ? 'Sesi 2 (09:00 - 10:00 WIB)'
        : 'Sesi 3 (10:00 - 11:30 WIB)';
    final jam = _selectedSession == 1 ? '09:00 - 09:45 WIB' : '10:00 - 10:45 WIB';

    final layanan = <String>['⚖️ Timbang Meja 2'];
    if (_svcImunisasi) layanan.add('💉 Imunisasi PCV 2');
    if (_svcVitA) layanan.add('🥣 PMT & Vit A (M4)');
    if (_svcKonseling) layanan.add('👩‍⚕️ Konseling Gizi');

    antreanState.bookAntrean(
      namaBalita: nama,
      usiaBalita: usia,
      sesi: sesi,
      estimasiJam: jam,
      layanan: layanan,
      catatan: _catatanController.text.trim(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TiketAntreanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Pendaftaran Kunjungan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Booking Antrean Online Posyandu Melati',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'RABU, 25 NOV 2026',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Sisa 12 Kuota',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pelayanan Rutin Posyandu & Imunisasi PCV 2',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '📍 Balai Warga RW 03, Kel. Jebres • Pukul 08:00 - 11:30 WIB',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 1. Pilih Balita
            _buildSectionLabel('1. Pilih Balita yang Didaftarkan'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildChildOption(
                    index: 0,
                    name: 'M. Rayyan',
                    sub: '14 Bulan • Terpilih',
                    avatarBg: const Color(0xFFFEF3C7),
                    avatarColor: const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildChildOption(
                    index: 1,
                    name: 'Aisyah Putri',
                    sub: '3 Bulan • Terverifikasi',
                    avatarBg: const Color(0xFFFCE7F3),
                    avatarColor: const Color(0xFFDB2777),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2. Pilih Sesi Jam Kedatangan
            _buildSectionLabel('2. Pilih Sesi Jam Kedatangan (Cegah Kerumunan)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSessionCard(
                    index: 0,
                    title: 'Sesi 1',
                    time: '08:00 - 09:00',
                    status: 'Penuh',
                    disabled: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSessionCard(
                    index: 1,
                    title: 'Sesi 2',
                    time: '09:00 - 10:00',
                    status: '● Sisa 4 Slot',
                    disabled: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSessionCard(
                    index: 2,
                    title: 'Sesi 3',
                    time: '10:00 - 11:30',
                    status: '● Sisa 8 Slot',
                    disabled: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. Pilih Layanan
            _buildSectionLabel('3. Pilih Layanan yang Dibutuhkan di Posyandu'),
            const SizedBox(height: 8),
            _buildServiceCheckbox(
              title: 'Penimbangan BB, TB, LK, LiLA (Meja 2) • Wajib',
              checked: true,
              locked: true,
              onChanged: null,
            ),
            const SizedBox(height: 8),
            _buildServiceCheckbox(
              title: 'Imunisasi PCV Dosis 3 / Rutin (Meja 5 Bidan)',
              checked: _svcImunisasi,
              onChanged: (v) => setState(() => _svcImunisasi = v),
            ),
            const SizedBox(height: 8),
            _buildServiceCheckbox(
              title: 'Vitamin A & PMT Biskuit Balita (Meja 4)',
              checked: _svcVitA,
              onChanged: (v) => setState(() => _svcVitA = v),
            ),
            const SizedBox(height: 8),
            _buildServiceCheckbox(
              title: 'Konseling Gizi / Masalah Makan Anak (Meja 4)',
              checked: _svcKonseling,
              onChanged: (v) => setState(() => _svcKonseling = v),
            ),

            const SizedBox(height: 16),

            // 4. Catatan untuk Kader
            const Text(
              '4. Catatan untuk Kader (Opsional)',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _catatanController,
                maxLines: 2,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155)),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Tulis keluhan atau catatan untuk kader/bidan...',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Estimasi Nomor Antrean dark banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF065F46),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'ESTIMASI',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA7F3D0),
                          ),
                        ),
                        Text(
                          '#B-14',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimasi Nomor Antrean: #B-14',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sesi 2 • Datang pukul 09:00 WIB • Bawa Buku KIA Fisik',
                          style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
                        ),
                        Text(
                          'Pendaftaran gratis tanpa dipungut biaya apapun',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF34D399),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Submit Button
            GestureDetector(
              onTap: _submitBooking,
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_available_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Konfirmasi Pendaftaran & Buat Tiket',
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

            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Nomor tiket dan QR Code akan langsung diterbitkan secara instan.',
                style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSectionLabel(String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
        children: [
          TextSpan(text: '$text '),
          const TextSpan(text: '*', style: TextStyle(color: Color(0xFFEF4444))),
        ],
      ),
    );
  }

  Widget _buildChildOption({
    required int index,
    required String name,
    required String sub,
    required Color avatarBg,
    required Color avatarColor,
  }) {
    final selected = _selectedChild == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedChild = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: avatarBg,
              child: Icon(Icons.sentiment_satisfied_alt_rounded, color: avatarColor, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected ? const Color(0xFF059669) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required int index,
    required String title,
    required String time,
    required String status,
    required bool disabled,
  }) {
    final selected = _selectedSession == index;
    return GestureDetector(
      onTap: disabled ? null : () => setState(() => _selectedSession = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: disabled
              ? const Color(0xFFF1F5F9)
              : (selected ? const Color(0xFFECFDF5) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: disabled
                    ? const Color(0xFF94A3B8)
                    : (selected ? const Color(0xFF059669) : const Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: disabled ? const Color(0xFF94A3B8) : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: disabled ? const Color(0xFF94A3B8) : const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCheckbox({
    required String title,
    required bool checked,
    bool locked = false,
    ValueChanged<bool>? onChanged,
  }) {
    return GestureDetector(
      onTap: locked || onChanged == null ? null : () => onChanged(!checked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: checked ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: checked ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? const Color(0xFF10B981) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                ),
              ),
              child: checked
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: checked ? FontWeight.bold : FontWeight.w500,
                  color: checked ? const Color(0xFF065F46) : const Color(0xFF475569),
                ),
              ),
            ),
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
        currentIndex: 2,
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
            Navigator.pop(context);
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RincianKunjunganScreen()),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilScreen()),
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
