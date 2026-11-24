import 'package:material_ui/material_ui.dart';
import '../../../core/services/antrean_state.dart';
import '../../children/screens/anak_saya_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../koreksi/screens/rincian_kunjungan_screen.dart';
import '../../profil/screens/profil_screen.dart';
import 'pendaftaran_kunjungan_screen.dart';
import 'tiket_antrean_screen.dart';

class JadwalPosyanduScreen extends StatefulWidget {
  const JadwalPosyanduScreen({super.key});

  @override
  State<JadwalPosyanduScreen> createState() => _JadwalPosyanduScreenState();
}

class _JadwalPosyanduScreenState extends State<JadwalPosyanduScreen> {
  bool _isCalendarTab = true;
  int _agendaFilterIndex = 0; // 0: Semua, 1: Mendatang, 2: Selesai

  @override
  void initState() {
    super.initState();
    antreanState.addListener(_onAntreanChanged);
    if (antreanState.hasActiveTicket) {
      _isCalendarTab = false;
    }
  }

  @override
  void dispose() {
    antreanState.removeListener(_onAntreanChanged);
    super.dispose();
  }

  void _onAntreanChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openPendaftaran() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PendaftaranKunjunganScreen()),
    );
    if (mounted && antreanState.hasActiveTicket) {
      setState(() => _isCalendarTab = false);
    }
  }

  void _openTiket() {
    if (!antreanState.hasActiveTicket) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TiketAntreanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTicket = antreanState.hasActiveTicket;
    final ticket = antreanState.activeTicket;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 68,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Posyandu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              'Posyandu Melati RW 03 • Kel. Jebres',
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF0F172A),
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. TOP DARK GREEN HERO BANNER
            // ==========================================
            if (!hasTicket)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF065F46), Color(0xFF064E3B), Color(0xFF0F172A)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'RABU, 25 NOV 2026',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Sisa 12 Kuota ⏳',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pelayanan Rutin Posyandu & PCV 2',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '📍 Balai Warga RW 03 • Pukul 08:00 - 11:30 WIB',
                      style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rayyan belum terdaftar',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFDE047),
                                ),
                              ),
                              Text(
                                'Pilih sesi kedatangan online',
                                style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _openPendaftaran,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_available_rounded, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Daftar Kunjungan →',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
              )
            else
              GestureDetector(
                onTap: _openTiket,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF065F46), Color(0xFF064E3B), Color(0xFF0F172A)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.4)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'ANTREAN',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA7F3D0),
                              ),
                            ),
                            Text(
                              ticket!.nomorAntrean,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ticket.namaBalita} (${ticket.usiaBalita})',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rabu, 25 Nov 2026 • ${ticket.estimasiJam}',
                              style: const TextStyle(fontSize: 10.5, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              '✓ Terdaftar: Timbang & Vaksin PCV 2',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF34D399),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF34D399), size: 20),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 14),

            // ==========================================
            // 2. TAB SWITCHER: TAMPILAN KALENDER / DAFTAR AGENDA
            // ==========================================
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isCalendarTab = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isCalendarTab ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _isCalendarTab
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: _isCalendarTab ? const Color(0xFF059669) : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tampilan Kalender',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: _isCalendarTab ? FontWeight.bold : FontWeight.w500,
                                color: _isCalendarTab ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isCalendarTab = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isCalendarTab ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !_isCalendarTab
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_bulleted_rounded,
                              size: 15,
                              color: !_isCalendarTab ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              hasTicket ? 'Daftar Agenda (3) ✓' : 'Daftar Agenda (2)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: !_isCalendarTab ? FontWeight.bold : FontWeight.w500,
                                color: !_isCalendarTab ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // 3. CALENDAR VIEW OR AGENDA LIST VIEW
            // ==========================================
            if (_isCalendarTab) ...[
              _buildCalendarCard(),
              const SizedBox(height: 16),
              const Text(
                'Agenda Posyandu Terdekat',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              _buildAgendaCard1(hasTicket, ticket),
              const SizedBox(height: 12),
              _buildAgendaCard2(),
            ] else ...[
              // Filter pills
              Row(
                children: [
                  _buildFilterChip('Semua (3)', 0),
                  const SizedBox(width: 8),
                  _buildFilterChip('Mendatang (2)', 1),
                  const SizedBox(width: 8),
                  _buildFilterChip('Selesai (1)', 2),
                ],
              ),
              const SizedBox(height: 12),
              if (_agendaFilterIndex == 0 || _agendaFilterIndex == 1) ...[
                _buildAgendaCard1(hasTicket, ticket),
                const SizedBox(height: 12),
                _buildAgendaCard2(),
                const SizedBox(height: 12),
              ],
              if (_agendaFilterIndex == 0 || _agendaFilterIndex == 2)
                _buildAgendaCard3Selesai(),
            ],
          ],
        ),
      ),
      floatingActionButton: !hasTicket
          ? FloatingActionButton.extended(
              onPressed: _openPendaftaran,
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Daftar Kunjungan',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final selected = _agendaFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _agendaFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    const weekdays = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
    // Nov 2026 starts on Sunday: Mon 27..Sat 31 (prev month), Sun 1..Mon 30
    final cells = <Map<String, dynamic>>[
      {'d': 27, 'muted': true},
      {'d': 28, 'muted': true},
      {'d': 29, 'muted': true},
      {'d': 30, 'muted': true},
      {'d': 31, 'muted': true},
      for (int d = 1; d <= 30; d++) {'d': d, 'muted': false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'November 2026',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Row(
                children: [
                  _buildCircleIcon(Icons.chevron_left_rounded),
                  const SizedBox(width: 8),
                  _buildCircleIcon(Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: weekdays
                .map(
                  (w) => Expanded(
                    child: Center(
                      child: Text(
                        w,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          for (int row = 0; row < 5; row++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  for (int col = 0; col < 7; col++)
                    Expanded(
                      child: _buildDayCell(cells[row * 7 + col]),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendDot(color: Color(0xFF10B981), label: 'Posyandu Buka (Sisa 12 Slot)'),
              _LegendDot(color: Color(0xFF3B82F6), label: 'Penyuluhan MPASI'),
              _LegendDot(color: Color(0xFF94A3B8), label: 'Selesai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF475569)),
    );
  }

  Widget _buildDayCell(Map<String, dynamic> cell) {
    final int d = cell['d'] as int;
    final bool muted = cell['muted'] as bool;
    final bool is25 = !muted && d == 25;
    final bool is23 = !muted && d == 23;
    final bool is10 = !muted && d == 10;
    final bool is28 = !muted && d == 28;

    return Center(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: is25 ? const Color(0xFF10B981) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              shape: is23 ? BoxShape.rectangle : BoxShape.rectangle,
              border: is23
                  ? Border.all(color: const Color(0xFF3B82F6), width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$d',
              style: TextStyle(
                fontSize: 12,
                fontWeight: (is25 || is23 || is10 || is28) ? FontWeight.bold : FontWeight.w500,
                color: is25
                    ? Colors.white
                    : (is23
                        ? const Color(0xFF2563EB)
                        : (muted ? const Color(0xFFCBD5E1) : const Color(0xFF0F172A))),
              ),
            ),
          ),
          if (is10 || is28)
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: is10 ? const Color(0xFF94A3B8) : const Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildAgendaCard1(bool hasTicket, AntreanData? ticket) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hasTicket
                      ? 'Terdaftar (${ticket!.nomorAntrean}) ✓'
                      : 'Sisa 12 Kuota 🟢',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasTicket
                ? 'Pelayanan Rutin Posyandu & Imunisasi PCV 2'
                : 'Pelayanan Rutin Posyandu & PCV 2',
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '📍 Balai Warga RW 03, Kel. Jebres • Pukul 08:00 - 11:30 WIB',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildTag('⚖️ Timbang Meja 2'),
              const SizedBox(width: 6),
              _buildTag('💉 Vaksin PCV 2'),
              if (hasTicket) ...[
                const SizedBox(width: 6),
                _buildTag('🥣 PMT Balita'),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hasTicket ? 'Kuota: 33/45 Terisi (Sisa 12 Slot)' : 'Kuota Terbuka',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),
              GestureDetector(
                onTap: hasTicket ? _openTiket : _openPendaftaran,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    hasTicket ? 'Lihat Tiket Antrean ↗' : 'Daftar Sekarang →',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildAgendaCard2() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SABTU, 28 NOV 2026',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pendaftaran Buka (Sisa 24)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Kelas Edukasi MPASI & Cegah Stunting',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '📍 Aula Balai Kelurahan Jebres • Pukul 09:00 - 12:00 WIB',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildTag('👩‍⚕️ Konseling Ahli Gizi'),
              const SizedBox(width: 6),
              _buildTag('🍳 Demo Masak MPASI'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Terbuka untuk Balita 6–24 Bulan',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pendaftaran Kelas Edukasi MPASI berhasil diajukan!'),
                      backgroundColor: Color(0xFF2563EB),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '+ Daftar Sekarang →',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildAgendaCard3Selesai() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SELASA, 10 NOV 2026',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Selesai Dihadiri ✓',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Pelayanan Penimbangan & Vitamin A Sem. 2',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '📍 Balai Warga RW 03 • Kehadiran: Rayyan Hadir ✓ (Meja 1–5)',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hasil: BB 9.8 kg • TB 78.2 cm • Vit. A Biru ✓',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF475569)),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RincianKunjunganScreen()),
                ),
                child: const Text(
                  'Lihat Rekam Medis >',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
