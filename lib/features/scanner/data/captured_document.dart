/// Resultado de una sesión de escaneo: PDF generado + miniatura + cantidad de páginas.
class CapturedDocument {
  const CapturedDocument({
    required this.pdfPath,
    required this.thumbnailPath,
    required this.pageCount,
  });

  final String pdfPath;
  final String thumbnailPath;
  final int pageCount;
}
