import 'package:flutter/material.dart';
import 'models.dart';

/// One reusable button for most actions in the app.
/// Example: AppButton(label: 'ORDER NOW', icon: Icons.arrow_forward, onPressed: () {})
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonType type;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = AppButtonType.primary,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = type == AppButtonType.primary
        ? AppColors.orange
        : type == AppButtonType.dark
            ? AppColors.brown
            : Colors.transparent;
    final foreground =
        type == AppButtonType.outline ? AppColors.brown : AppColors.deepBrown;

    final button = icon == null
        ? ElevatedButton(
            onPressed: onPressed,
            style: _style(background, foreground, type),
            child: Text(label),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
            style: _style(background, foreground, type),
          );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  ButtonStyle _style(Color background, Color foreground, AppButtonType type) {
    return ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: type == AppButtonType.outline ? 0 : 1,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: type == AppButtonType.outline
            ? const BorderSide(color: AppColors.brown)
            : BorderSide.none,
      ),
    );
  }
}

enum AppButtonType { primary, dark, outline }

/// Reusable back button. It returns to the previous page when possible.
class BackButtonApp extends StatelessWidget {
  final VoidCallback? onPressed;
  const BackButtonApp({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Go back',
      onPressed: onPressed ??
          () {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          },
      icon: const Icon(Icons.arrow_back_rounded),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.orange.withValues(alpha: 0.18),
        foregroundColor: AppColors.brown,
      ),
    );
  }
}

/// Reusable category filter button. Keep it inside a Material widget.
class CategoryButton extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CategoryButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppColors.orange,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? AppColors.deepBrown : AppColors.brown,
          fontWeight: FontWeight.w700,
        ),
        shape: StadiumBorder(
          side: BorderSide(color: AppColors.orange.withValues(alpha: 0.45)),
        ),
      ),
    );
  }
}
