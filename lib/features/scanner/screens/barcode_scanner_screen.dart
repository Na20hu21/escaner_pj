import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// Pantalla de escaneo de código de barras.
/// Devuelve el valor escaneado (String) via pop cuando se detecta un código.
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});
  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _detected = false;
  bool _torchOn = false;

  late final AnimationController _lineCtrl;
  late final Animation<double> _lineAnim;

  @override
  void initState() {
    super.initState();
    _lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _lineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lineCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    _controller?.pauseCamera();
    _controller?.resumeCamera();
  }

  @override
  void dispose() {
    _lineCtrl.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((barcode) {
      if (_detected) return;
      final value = barcode.code;
      if (value == null || value.isEmpty) return;

      debugPrint('=== BARCODE DETECTADO ===');
      debugPrint('  code:   $value');
      debugPrint('  format: ${barcode.format}');
      debugPrint('=========================');

      _detected = true;
      if (mounted) Navigator.of(context).pop(value);
    });
  }

  Future<void> _toggleTorch() async {
    await _controller?.toggleFlash();
    setState(() => _torchOn = !_torchOn);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cutOutWidth = screenWidth * 0.85;
    final cutOutHeight = screenWidth * 0.45;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Escanear código'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleTorch,
            icon: Icon(
              _torchOn ? Icons.flash_on : Icons.flash_off,
              color: _torchOn ? Colors.amber : Colors.white,
            ),
            tooltip: 'Linterna',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera + overlay
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderWidth: 3,
              borderLength: 28,
              borderRadius: 0,
              cutOutWidth: cutOutWidth,
              cutOutHeight: cutOutHeight,
              cutOutBottomOffset: 40,
              overlayColor: Colors.black.withValues(alpha: 0.6),
            ),
            formatsAllowed: const [
              BarcodeFormat.code128,
              BarcodeFormat.code39,
              BarcodeFormat.code93,
              BarcodeFormat.codabar,
              BarcodeFormat.ean8,
              BarcodeFormat.ean13,
              BarcodeFormat.upcA,
              BarcodeFormat.upcE,
              BarcodeFormat.itf,
              BarcodeFormat.qrcode,
              BarcodeFormat.pdf417,
              BarcodeFormat.dataMatrix,
              BarcodeFormat.aztec,
            ],
          ),

          // Animated scan line
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _lineAnim,
                builder: (context, _) {
                  final bodyHeight = MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top;
                  final centerY = bodyHeight / 2 - 40;
                  final lineTop =
                      centerY - cutOutHeight / 2 + _lineAnim.value * cutOutHeight;
                  final lineLeft = (screenWidth - cutOutWidth) / 2 + 4;

                  return Stack(
                    children: [
                      Positioned(
                        top: lineTop,
                        left: lineLeft,
                        width: cutOutWidth - 8,
                        height: 2,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.greenAccent.withValues(alpha: 0.9),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Hint text
          const Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Text(
              'Apuntá la cámara al código de barras o QR',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
