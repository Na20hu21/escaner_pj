import 'dart:io';

import 'package:flutter/material.dart';

import '../data/captured_document.dart';
import '../data/pdf_builder.dart';

/// Muestra las páginas capturadas. Permite reordenar y eliminar.
/// Al confirmar genera el PDF y hace pop con [CapturedDocument].
class PagesPreviewScreen extends StatefulWidget {
  const PagesPreviewScreen({super.key, required this.imagePaths});

  final List<String> imagePaths;

  @override
  State<PagesPreviewScreen> createState() => _PagesPreviewScreenState();
}

class _PagesPreviewScreenState extends State<PagesPreviewScreen> {
  late List<String> _pages;
  bool _isBuilding = false;

  @override
  void initState() {
    super.initState();
    _pages = List.from(widget.imagePaths);
  }

  Future<void> _confirm() async {
    if (_pages.isEmpty) return;
    setState(() => _isBuilding = true);
    try {
      final doc = await PdfBuilder.build(_pages);
      if (mounted) Navigator.of(context).pop(doc);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar PDF: $e')),
        );
        setState(() => _isBuilding = false);
      }
    }
  }

  void _deletePage(int index) {
    setState(() => _pages.removeAt(index));
    if (_pages.isEmpty) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Revisar — ${_pages.length} página${_pages.length != 1 ? 's' : ''}',
        ),
      ),
      bottomNavigationBar: _isBuilding
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: _pages.isNotEmpty ? _confirm : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continuar — elegir destinatario'),
                ),
              ),
            ),
      body: _isBuilding
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generando PDF…'),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  color: Colors.amber.shade50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Arrastrá para reordenar · tocá 🗑 para eliminar',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _pages.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _pages.removeAt(oldIndex);
                  _pages.insert(newIndex, item);
                });
              },
              itemBuilder: (context, i) {
                return Card(
                  key: ValueKey(_pages[i]),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(_pages[i]),
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('Página ${i + 1}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: 'Eliminar página',
                      onPressed: () => _deletePage(i),
                    ),
                  ),
                );
              },
            ),
                ),
              ],
            ),
    );
  }
}
