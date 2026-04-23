import 'package:flutter/material.dart';

import '../screens/barcode_scanner_screen.dart';

/// Abre el escáner y devuelve el valor leído, o null si se canceló.
Future<String?> scanBarcode(BuildContext context) async {
  final result = await Navigator.of(context, rootNavigator: true)
      .push<String>(
    MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
  );
  return (result != null && result.isNotEmpty) ? result : null;
}

/// Botón ícono que abre el escáner y llama [onScanned] con el valor leído.
class BarcodeScanButton extends StatelessWidget {
  const BarcodeScanButton({super.key, required this.onScanned});

  final void Function(String value) onScanned;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () async {
        final value = await scanBarcode(context);
        if (value != null && context.mounted) onScanned(value);
      },
      icon: const Icon(Icons.qr_code_scanner),
      tooltip: 'Escanear código',
    );
  }
}
