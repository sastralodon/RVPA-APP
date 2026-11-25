import 'dart:io';

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';

/// Tombol utama pink berbentuk kapsul.
class RvpaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final double height;

  const RvpaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.pink,
                side: const BorderSide(color: AppColors.pink, width: 1.3),
                shape: const StadiumBorder(),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.pinkSoft,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: child,
            ),
    );
  }
}

/// Label kecil di atas isian form.
class FieldLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const FieldLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Row(
        children: [
          Text(text, style: AppText.label),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Isian teks bergaya RVPA (sudut membulat, garis tipis).
class RvpaTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const RvpaTextField({
    super.key,
    this.controller,
    this.hint = '',
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.validator,
  });

  @override
  State<RvpaTextField> createState() => _RvpaTextFieldState();
}

class _RvpaTextFieldState extends State<RvpaTextField> {
  late bool _hidden = widget.obscure;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _hidden,
      keyboardType: widget.keyboardType,
      maxLines: widget.obscure ? 1 : widget.maxLines,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      validator: widget.validator,
      style: const TextStyle(fontSize: 14, color: AppColors.text),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
        prefixIcon: widget.icon == null ? null : Icon(widget.icon, size: 20, color: AppColors.pink),
        suffixIcon: widget.obscure
            ? IconButton(
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.textGrey,
                ),
              )
            : widget.suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.pink),
        errorBorder: _border(AppColors.red),
        focusedErrorBorder: _border(AppColors.red),
      ),
    );
  }
}

/// Chip pilihan (kategori, waktu pemakaian, gender, jenis kulit).
class SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.pink : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? AppColors.pink : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: selected ? Colors.white : AppColors.textGrey),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lingkaran hari (Sen, Sel, ...) untuk jadwal pemakaian dan alarm.
class DayCircle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double size;

  const DayCircle({super.key, required this.label, required this.selected, this.onTap, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.pink : Colors.white,
          border: Border.all(color: selected ? AppColors.pink : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }
}

/// Label kecil berwarna (kategori produk, waktu pakai, status).
class Tag extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;
  final IconData? icon;

  const Tag(
    this.text, {
    super.key,
    this.background = AppColors.pinkSoft,
    this.foreground = AppColors.pink,
    this.icon,
  });

  const Tag.category(this.text, {super.key})
      : background = AppColors.lilac,
        foreground = AppColors.lilacText,
        icon = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: foreground)),
        ],
      ),
    );
  }
}

/// Kartu putih bergaris tipis.
class RvpaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  const RvpaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.borderColor = AppColors.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
    if (onTap == null) return box;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: box);
  }
}

/// Foto produk, atau kotak pink berikon tabung jika belum ada foto.
class ProductThumb extends StatelessWidget {
  final Product product;
  final double size;
  final double radius;
  final double? height;

  const ProductThumb({super.key, required this.product, this.size = 64, this.radius = 14, this.height});

  @override
  Widget build(BuildContext context) {
    final h = height ?? size;
    final path = product.photoPath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: h,
        color: product.active ? AppColors.pinkSoft : const Color(0xFFF2F0F1),
        child: path != null
            ? Image.file(File(path), fit: BoxFit.cover)
            : Icon(
                Icons.science_outlined,
                size: h * 0.45,
                color: product.active ? AppColors.pink : AppColors.textGrey,
              ),
      ),
    );
  }
}

/// Kotak peringatan "Segera habis! Kedaluwarsa dalam X hari".
class ExpiryWarning extends StatelessWidget {
  final int daysLeft;
  const ExpiryWarning({super.key, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final expired = daysLeft < 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.redSoft, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expired ? 'Sudah kedaluwarsa!' : 'Segera habis!',
                  style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  expired
                      ? 'Lewat ${-daysLeft} hari dari tanggal kedaluwarsa'
                      : daysLeft == 0
                          ? 'Kedaluwarsa hari ini'
                          : 'Kedaluwarsa dalam $daysLeft hari',
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu toggle "Masuk ke rutinitas".
class RoutineToggleCard extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const RoutineToggleCard({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RvpaCard(
      color: AppColors.pinkLight,
      borderColor: AppColors.pinkSoft,
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Masuk ke rutinitas', style: AppText.label),
                const SizedBox(height: 2),
                Text(
                  value ? 'Aktif: produk masuk jadwal rutinitas' : 'Nonaktif: produk tidak masuk jadwal rutinitas',
                  style: TextStyle(fontSize: 11, color: value ? AppColors.pink : AppColors.textGrey),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Lingkaran foto profil (atau ikon orang jika belum ada foto).
class Avatar extends StatelessWidget {
  final String? photoPath;
  final double size;
  final Color background;

  const Avatar({super.key, this.photoPath, this.size = 64, this.background = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: background),
      clipBehavior: Clip.antiAlias,
      child: photoPath != null
          ? Image.file(File(photoPath!), fit: BoxFit.cover)
          : Icon(Icons.person_outline_rounded, size: size * 0.5, color: AppColors.pink),
    );
  }
}

/// Tombol kembali berbentuk lingkaran pink muda (dipakai di layar analisis).
class CircleBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CircleBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
        child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.pink),
      ),
    );
  }
}

/// Kotak bergaris putus-putus (area tambah foto, tombol tambah alarm).
class DashedBox extends StatelessWidget {
  final Widget child;
  final double height;
  final double radius;
  final VoidCallback? onTap;
  final Color color;

  const DashedBox({
    super.key,
    required this.child,
    this.height = 140,
    this.radius = 18,
    this.onTap,
    this.color = AppColors.pinkLight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(radius: radius),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double radius;
  _DashedBorderPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.65, 0.65, size.width - 1.3, size.height - 1.3),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => oldDelegate.radius != radius;
}

/// Dialog konfirmasi sederhana. Mengembalikan true jika pengguna setuju.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Hapus',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: AppText.serif(size: 20)),
      content: Text(message, style: AppText.body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal', style: TextStyle(color: AppColors.textGrey)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel, style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
