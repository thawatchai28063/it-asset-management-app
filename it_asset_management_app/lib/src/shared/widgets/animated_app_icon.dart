import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedAppIcon extends StatefulWidget {
  const AnimatedAppIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 72,
    this.backgroundColor,
  });

  final IconData icon;
  final Color color;
  final double size;
  final Color? backgroundColor;

  @override
  State<AnimatedAppIcon> createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<AnimatedAppIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotation = Tween<double>(begin: -0.025, end: 0.025).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? widget.color.withValues(alpha: 0.12);
    return ScaleTransition(
      scale: _scale,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotation.value * math.pi,
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                bg,
                widget.color.withValues(alpha: 0.24),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size * 0.46,
          ),
        ),
      ),
    );
  }
}

class AnimatedEmptyState extends StatelessWidget {
  const AnimatedEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedAppIcon(icon: icon, color: color, size: 82),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrettyIconBadge extends StatelessWidget {
  const PrettyIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.26),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class StaticIconBadge extends StatelessWidget {
  const StaticIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withAlpha(24),
          border: Border.all(color: color.withAlpha(42)),
        ),
        child: Icon(icon, color: color, size: size * 0.52),
      ),
    );
  }
}

IconData assetTypeIcon(String type) {
  final normalized = type.toLowerCase();
  if (normalized.contains('laptop') || normalized.contains('notebook')) {
    return Icons.laptop_mac;
  }
  if (normalized.contains('desktop') || normalized.contains('pc')) {
    return Icons.desktop_windows;
  }
  if (normalized.contains('printer')) {
    return Icons.print;
  }
  if (normalized.contains('network') || normalized.contains('switch')) {
    return Icons.settings_ethernet;
  }
  if (normalized.contains('access')) {
    return Icons.wifi;
  }
  if (normalized.contains('monitor')) {
    return Icons.monitor;
  }
  if (normalized.contains('storage') || normalized.contains('server')) {
    return Icons.dns;
  }
  if (normalized.contains('tablet') || normalized.contains('ipad')) {
    return Icons.tablet_mac;
  }
  if (normalized.contains('scanner')) {
    return Icons.document_scanner;
  }
  return Icons.devices_other;
}

Color assetTypeColor(String type) {
  final normalized = type.toLowerCase();
  if (normalized.contains('laptop') || normalized.contains('notebook')) {
    return Colors.indigo;
  }
  if (normalized.contains('printer') || normalized.contains('scanner')) {
    return Colors.deepOrange;
  }
  if (normalized.contains('network') || normalized.contains('access')) {
    return Colors.teal;
  }
  if (normalized.contains('storage') || normalized.contains('server')) {
    return Colors.blueGrey;
  }
  if (normalized.contains('monitor')) {
    return Colors.blue;
  }
  if (normalized.contains('tablet') || normalized.contains('ipad')) {
    return Colors.purple;
  }
  return Colors.indigo;
}
