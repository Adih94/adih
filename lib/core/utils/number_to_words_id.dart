/// Konversi angka ke kata Bahasa Indonesia, dipakai untuk dibacakan
/// lewat Text-to-Speech. Cukup untuk 0-999 (belum perlu ribuan dulu).
class NumberToWordsId {
  NumberToWordsId._();

  static const List<String> _satuan = [
    'nol', 'satu', 'dua', 'tiga', 'empat', 'lima',
    'enam', 'tujuh', 'delapan', 'sembilan',
  ];

  static String convert(int number) {
    if (number < 0) return 'minus ${convert(-number)}';
    if (number < 10) return _satuan[number];
    if (number < 20) {
      if (number == 10) return 'sepuluh';
      if (number == 11) return 'sebelas';
      return '${_satuan[number - 10]} belas';
    }
    if (number < 100) {
      final puluhan = number ~/ 10;
      final sisa = number % 10;
      final depan = puluhan == 1 ? 'sepuluh' : '${_satuan[puluhan]} puluh';
      return sisa == 0 ? depan : '$depan ${_satuan[sisa]}';
    }
    if (number < 1000) {
      final ratusan = number ~/ 100;
      final sisa = number % 100;
      final depan = ratusan == 1 ? 'seratus' : '${_satuan[ratusan]} ratus';
      return sisa == 0 ? depan : '$depan ${convert(sisa)}';
    }
    return number.toString(); // fallback, belum dibutuhkan untuk tahap ini
  }
}
