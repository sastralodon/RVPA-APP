import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../services/skin_analyzer.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../main_shell.dart';
import 'analysis_history_view.dart';
import 'analysis_result_view.dart';

enum _Mode { camera, result, history }

/// Tab Analisis (tombol tengah bottom navigation).
/// Berisi tiga tampilan: Kamera -> Hasil analisis -> Riwayat analisis.
class AnalysisTab extends StatefulWidget {
  const AnalysisTab({super.key});

  @override
  State<AnalysisTab> createState() => _AnalysisTabState();
}

class _AnalysisTabState extends State<AnalysisTab> {
  _Mode _mode = _Mode.camera;
  String? _photoPath;
  bool _analyzing = false;
  bool _frontCamera = true;
  AnalysisResult? _result;
  bool _resultSaved = false;

  Future<void> _pick(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: _frontCamera ? CameraDevice.front : CameraDevice.rear,
      maxWidth: 1080,
    );
    if (file == null) return;
    setState(() {
      _photoPath = file.path;
      _analyzing = true;
    });

    final acne = await SkinAnalyzer.analyze(file.path);
    if (!mounted) return;
    setState(() {
      _analyzing = false;
      _resultSaved = false;
      _result = AnalysisResult(
        id: store.newId('s'),
        date: DateTime.now(),
        acneDetected: acne,
        photoPath: file.path,
        isSample: SkinAnalyzer.usesSampleResult,
      );
      _mode = _Mode.result;
    });
  }

  void _saveResult() {
    if (_result == null || _resultSaved) return;
    store.saveAnalysis(_result!);
    setState(() => _resultSaved = true);
    showMessage(context, 'Hasil disimpan ke riwayat');
  }

  void _rescan() => setState(() {
        _photoPath = null;
        _result = null;
        _mode = _Mode.camera;
      });

  void _back() {
    if (_mode == _Mode.camera) {
      MainShell.goTo(context, MainShell.homeTab);
    } else {
      _rescan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: switch (_mode) {
        _Mode.result => AnalysisResultView(
            result: _result!,
            saved: _resultSaved,
            onBack: _back,
            onSave: _saveResult,
            onRescan: _rescan,
          ),
        _Mode.history => AnalysisHistoryView(
            onBack: _back,
            onNewScan: _rescan,
            onOpen: (r) => setState(() {
              _result = r;
              _resultSaved = true;
              _mode = _Mode.result;
            }),
          ),
        _Mode.camera => _buildCamera(),
      },
    );
  }

  Widget _buildCamera() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Row(
          children: [
            CircleBackButton(onPressed: _back),
            const SizedBox(width: 12),
            const Text('Analisis kulit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _mode = _Mode.history),
              child: const Tag('Riwayat'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text('Kenali kulitmu lebih dekat', style: AppText.serif(size: 22)),
        const SizedBox(height: 4),
        const Text('Posisikan wajah di dalam bingkai.', style: AppText.caption),
        const SizedBox(height: 16),

        // Area pratinjau kamera
        AspectRatio(
          aspectRatio: 0.88,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              color: AppColors.dark,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_photoPath != null) Image.file(File(_photoPath!), fit: BoxFit.cover),
                  const CustomPaint(painter: _FaceFramePainter()),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Tag(
                        _frontCamera ? 'Kamera depan' : 'Kamera belakang',
                        icon: Icons.photo_camera_outlined,
                        background: const Color(0x33FFFFFF),
                        foreground: Colors.white,
                      ),
                    ),
                  ),
                  if (_photoPath == null)
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: Text('Pratinjau kamera', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ),
                    ),
                  if (_analyzing)
                    Container(
                      color: const Color(0x99000000),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 14),
                          Text('Menganalisis kulit...', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppColors.pinkSoft, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 15, color: AppColors.pink),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cahaya alami, tanpa makeup atau filter.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.pinkDark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _RoundIcon(
              icon: Icons.photo_library_outlined,
              tooltip: 'Pilih dari galeri',
              onTap: _analyzing ? null : () => _pick(ImageSource.gallery),
            ),
            GestureDetector(
              onTap: _analyzing ? null : () => _pick(ImageSource.camera),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.pink, width: 2),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(color: AppColors.pink, shape: BoxShape.circle),
                      child: const Icon(Icons.photo_camera_outlined, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Ambil foto', style: AppText.label),
                ],
              ),
            ),
            _RoundIcon(
              icon: Icons.cameraswitch_outlined,
              tooltip: 'Ganti kamera',
              onTap: () => setState(() => _frontCamera = !_frontCamera),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Foto untuk analisis kulit, bukan diagnosis medis.',
          textAlign: TextAlign.center,
          style: AppText.tiny,
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _RoundIcon({required this.icon, required this.tooltip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: IconButton(
        onPressed: onTap,
        tooltip: tooltip,
        style: IconButton.styleFrom(backgroundColor: AppColors.pinkSoft, fixedSize: const Size(48, 48)),
        icon: Icon(icon, color: AppColors.pink, size: 22),
      ),
    );
  }
}

/// Bingkai wajah: sudut-sudut putih + oval putus-putus.
class _FaceFramePainter extends CustomPainter {
  const _FaceFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Sudut bingkai
    final frame = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.62,
      height: size.height * 0.72,
    );
    const c = 26.0;
    final corners = [
      [frame.topLeft, const Offset(c, 0), const Offset(0, c)],
      [frame.topRight, const Offset(-c, 0), const Offset(0, c)],
      [frame.bottomLeft, const Offset(c, 0), const Offset(0, -c)],
      [frame.bottomRight, const Offset(-c, 0), const Offset(0, -c)],
    ];
    for (final corner in corners) {
      canvas.drawLine(corner[0], corner[0] + corner[1], white);
      canvas.drawLine(corner[0], corner[0] + corner[2], white);
    }

    // Oval putus-putus
    final dash = Paint()
      ..color = const Color(0xFFF7A8C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final oval = Path()..addOval(frame.deflate(18));
    for (final metric in oval.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 5), dash);
        d += 10;
      }
    }

    // Garis bantu horizontal di tengah
    final guide = Paint()
      ..color = const Color(0x99E5508A)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(frame.left + 18, frame.center.dy),
      Offset(frame.right - 18, frame.center.dy),
      guide,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
