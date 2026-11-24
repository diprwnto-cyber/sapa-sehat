import 'package:flutter/foundation.dart';

class AntreanData {
  final String nomorAntrean;
  final String kodeTiket;
  final String namaBalita;
  final String usiaBalita;
  final String sesi;
  final String estimasiJam;
  final List<String> layanan;
  final String catatan;

  const AntreanData({
    required this.nomorAntrean,
    required this.kodeTiket,
    required this.namaBalita,
    required this.usiaBalita,
    required this.sesi,
    required this.estimasiJam,
    required this.layanan,
    required this.catatan,
  });
}

class AntreanState extends ChangeNotifier {
  AntreanData? _activeTicket;

  AntreanData? get activeTicket => _activeTicket;
  bool get hasActiveTicket => _activeTicket != null;

  void bookAntrean({
    required String namaBalita,
    required String usiaBalita,
    required String sesi,
    required String estimasiJam,
    required List<String> layanan,
    required String catatan,
  }) {
    _activeTicket = AntreanData(
      nomorAntrean: '#B-14',
      kodeTiket: 'SS-20261125-B14-RAYYAN',
      namaBalita: namaBalita,
      usiaBalita: usiaBalita,
      sesi: sesi,
      estimasiJam: estimasiJam,
      layanan: layanan,
      catatan: catatan,
    );
    notifyListeners();
  }

  void cancelBooking() {
    _activeTicket = null;
    notifyListeners();
  }
}

final antreanState = AntreanState();
