class FormatDataApi {
  String formatarHojeParaApi() {
    final hoje = DateTime.now();
    return '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';
  }

  String converterBrParaApi(String dataBr) {
    final partes = dataBr.split('/'); // [dd, MM, yyyy]
    return '${partes[2]}-${partes[1]}-${partes[0]}';
  }

  String formatarHojeParaExibir() {
    final hoje = DateTime.now();
    return '${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}';
  }
}
