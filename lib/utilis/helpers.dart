class Helpers {

  /// Simple ISO date -> dd/MM/yyyy
static String formatIsoToDate(String iso) {
  if (iso.isEmpty) return "";
  try {
    final dt = DateTime.parse(iso);
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    return "$dd/$mm/$yyyy";
  } catch (_) {
    return iso;
  }
}


// =====================================================
// 8) HELPERS
// =====================================================
static String fmtDate(DateTime dt) =>
    "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";

static String fmtIso(String iso) {
  final dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  return fmtDate(dt);
}
}