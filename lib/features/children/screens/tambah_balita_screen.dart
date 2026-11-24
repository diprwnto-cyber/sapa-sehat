import 'package:material_ui/material_ui.dart';
import '../../home/screens/home_screen.dart';
import 'anak_saya_screen.dart';

class TambahBalitaScreen extends StatefulWidget {
  const TambahBalitaScreen({super.key});

  @override
  State<TambahBalitaScreen> createState() => _TambahBalitaScreenState();
}

class _TambahBalitaScreenState extends State<TambahBalitaScreen> {
  final _noKkController = TextEditingController(text: '3314052901180004');
  final _nikBalitaController = TextEditingController(text: '3314051508260001');
  final _namaBalitaController = TextEditingController(text: 'Aisyah Putri Prasetyo');
  final _tempatLahirController = TextEditingController(text: 'Surakarta');
  final _tanggalLahirController = TextEditingController(text: '15/08/2026');
  final _anakKeController = TextEditingController(text: '2 (Kedua)');
  final _bblController = TextEditingController(text: '3.1');
  final _pblController = TextEditingController(text: '48.5');

  String _posyanduBinaan = 'Posyandu Melati RW 03';
  String _hubungan = 'Ibu';
  String _jenisKelamin = 'Perempuan';
  String _bukuKia = 'Sudah Ada ✓';
  final String _fotoKkName = 'Foto_Kartu_Keluarga_Aisyah.jpg';
  bool _isLoading = false;

  @override
  void dispose() {
    _noKkController.dispose();
    _nikBalitaController.dispose();
    _namaBalitaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _anakKeController.dispose();
    _bblController.dispose();
    _pblController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate to AnakSayaScreen showing pending verification status
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AnakSayaScreen(
            initialChildName: _namaBalitaController.text.trim().isEmpty
                ? 'Aisyah Putri Rahmawati'
                : _namaBalitaController.text.trim(),
            initialChildNik: _nikBalitaController.text.trim().isEmpty
                ? '3314055208260003'
                : _nikBalitaController.text.trim(),
            initialTtl: '${_tempatLahirController.text}, ${_tanggalLahirController.text}',
            initialHubungan: '$_hubungan Kandung',
            initialBbl: _bblController.text,
            initialPbl: _pblController.text,
            initialJenisKelamin: _jenisKelamin,
            initialStatusPending: true,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP APP BAR
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF0F172A),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tambah Data Balita',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pendaftaran & Penautan Rekam Medis Meja 1',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. PERMENKES NOTICE BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 ', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Text(
                        'Sesuai Permenkes 24/2022, data diverifikasi Kader Meja 1 Posyandu.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF065F46),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 3. SECTION 1: DATA KK & POSYANDU BINAAN
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '1. Data Kartu Keluarga & Posyandu Binaan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: const Text(
                            'Wajib KK ✓',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // No KK Field
                    const Text(
                      'Nomor Kartu Keluarga (16 Digit) *',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _noKkController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        suffixIcon: Container(
                          padding: const EdgeInsets.only(right: 12),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Valid ✓',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                          ),
                        ),
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

                    // Posyandu & Hubungan Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Posyandu Binaan Domisili
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Posyandu Binaan Domisili *',
                                style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _posyanduBinaan,
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0F172A)),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    items: [
                                      'Posyandu Melati RW 03',
                                      'Posyandu Mawar RW 01',
                                      'Posyandu Anggrek RW 02',
                                    ].map((e) => DropdownMenuItem(value: e, child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _posyanduBinaan = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Right: Hubungan dg Anak
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hubungan dg Anak *',
                                style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: ['Ibu', 'Ayah', 'Wali'].map((item) {
                                  final isSelected = _hubungan == item;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: InkWell(
                                        onTap: () => setState(() => _hubungan = item),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                                              width: isSelected ? 1.5 : 1,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            isSelected ? '✓ $item' : item,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                              color: isSelected ? const Color(0xFF065F46) : const Color(0xFF475569),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // KK Footer
                    const Text(
                      'Kepala Keluarga: Budi Prasetyo • Ibu: Sarah Ratna Dewi',
                      style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 4. SECTION 2: IDENTITAS LENGKAP BALITA
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2. Identitas Lengkap Balita',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Sesuai Akta / KIA',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // NIK Field
                    const Text(
                      'Nomor Induk Kependudukan (NIK) Balita *',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nikBalitaController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        suffixIcon: Container(
                          padding: const EdgeInsets.only(right: 12),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Tercatat Dukcapil ✓',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                          ),
                        ),
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

                    // Nama Lengkap Balita
                    const Text(
                      'Nama Lengkap Balita *',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _namaBalitaController,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
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

                    // Tempat Lahir & Tanggal Lahir Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tempat Lahir *',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _tempatLahirController,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
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
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal Lahir *',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _tanggalLahirController,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  suffixIcon: const Icon(Icons.calendar_month_outlined, size: 20, color: Color(0xFF64748B)),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 5. SECTION 3: DATA KELAHIRAN DASAR & BUKU KIA
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '3. Data Kelahiran Dasar & Buku KIA',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Usia: 3 Bulan ILP',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Jenis Kelamin & Anak Ke- Row
                    Row(
                      children: [
                        // Jenis Kelamin
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jenis Kelamin *',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  // Laki-laki
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => _jenisKelamin = 'Laki-laki'),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: _jenisKelamin == 'Laki-laki' ? const Color(0xFFEFF6FF) : Colors.white,
                                          border: Border.all(
                                            color: _jenisKelamin == 'Laki-laki' ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          _jenisKelamin == 'Laki-laki' ? '👶 Laki-laki ✓' : '👶 Laki-laki',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: _jenisKelamin == 'Laki-laki' ? const Color(0xFF2563EB) : const Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Perempuan
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(() => _jenisKelamin = 'Perempuan'),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: _jenisKelamin == 'Perempuan' ? const Color(0xFFFDF2F8) : Colors.white,
                                          border: Border.all(
                                            color: _jenisKelamin == 'Perempuan' ? const Color(0xFFDB2777) : const Color(0xFFCBD5E1),
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          _jenisKelamin == 'Perempuan' ? '👧 Perempuan ✓' : '👧 Perempuan',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: _jenisKelamin == 'Perempuan' ? const Color(0xFFDB2777) : const Color(0xFF475569),
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
                        const SizedBox(width: 10),

                        // Anak Ke-
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Anak Ke- *',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _anakKeController,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // BBL, PBL, Buku KIA Row
                    Row(
                      children: [
                        // BBL
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Berat Lahir (BBL)',
                                style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _bblController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  suffixText: 'kg',
                                  suffixStyle: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // PBL
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Panjang Lahir (PBL)',
                                style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _pblController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  suffixText: 'cm',
                                  suffixStyle: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Buku KIA Fisik
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Buku KIA Fisik?',
                                style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  border: Border.all(color: const Color(0xFF10B981)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _bukuKia,
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF065F46), size: 18),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                                    items: ['Sudah Ada ✓', 'Belum Ada'].map((e) => DropdownMenuItem(value: e, child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _bukuKia = val);
                                    },
                                  ),
                                ),
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

              // 6. UPLOAD ATTACHMENT CARD (DASHED GREEN)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF10B981),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.description_outlined, color: Color(0xFF059669), size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fotoKkName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '✓ 1.2 MB • Bukti Hubungan Siap Diverifikasi Meja 1',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pilih foto KK baru dari galeri/kamera.'),
                            backgroundColor: Color(0xFF059669),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Ganti ',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                            ),
                            Icon(Icons.refresh_rounded, size: 14, color: Color(0xFF475569)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 7. SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Simpan & Ajukan Verifikasi Balita',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Kader Meja 1 akan memvalidasi data KK dalam 1x24 Jam Kerja.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
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
          currentIndex: 1, // Anak Saya active
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AnakSayaScreen()),
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
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
