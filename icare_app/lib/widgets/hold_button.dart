import 'dart:async';

import 'package:flutter/material.dart';

import '../study_scope.dart';
import '../theme.dart';

enum HoldStyle { primary, secondary, danger }

class HoldButton extends StatefulWidget {
  const HoldButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.style = HoldStyle.primary,
    this.compact = false,
    this.waitToRead = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final HoldStyle style;
  final bool compact;
  final bool waitToRead;

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  Timer? _armTimer;
  Duration _holdDuration = Duration.zero;
  bool _armed = false;
  bool _armScheduled = false;
  bool _tooQuick = false;
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final timing = StudyScope.watch(context).timing;
    _holdDuration = timing.holdDuration;
    _press.duration = _holdDuration == Duration.zero
        ? const Duration(milliseconds: 1)
        : _holdDuration;
    if (_armScheduled) return;
    _armScheduled = true;
    final delay = widget.waitToRead ? timing.armDelay : Duration.zero;
    if (delay == Duration.zero) {
      _armed = true;
    } else {
      _armTimer = Timer(delay, () {
        if (mounted) setState(() => _armed = true);
      });
    }
  }

  @override
  void dispose() {
    _armTimer?.cancel();
    _press.dispose();
    super.dispose();
  }

  bool get _enabled => _armed && widget.onPressed != null;

  void _activate() {
    if (!_enabled || _activated) return;
    _activated = true;
    widget.onPressed!();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activated = false;
    });
  }

  void _pointerDown(PointerDownEvent event) {
    if (!_enabled) return;
    setState(() => _tooQuick = false);
    _press.forward(from: 0);
  }

  void _pointerUp(PointerUpEvent event) {
    if (!_enabled) return;
    final finished = _holdDuration == Duration.zero || _press.value >= 0.98;
    _press.reverse();
    if (finished) {
      _activate();
    } else if (mounted) {
      setState(() => _tooQuick = true);
    }
  }

  void _pointerCancel(PointerCancelEvent event) {
    _press.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors(widget.style, _enabled);
    final caption = !_armed && widget.waitToRead
        ? 'Please read first'
        : _tooQuick
        ? 'Hold the button a little longer'
        : '';

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      onTap: _enabled ? _activate : null,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: widget.compact
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Listener(
              onPointerDown: _pointerDown,
              onPointerUp: _pointerUp,
              onPointerCancel: _pointerCancel,
              child: AnimatedBuilder(
                animation: _press,
                builder: (context, child) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.border, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _press.value,
                              child: const ColoredBox(color: Color(0x33FFFFFF)),
                            ),
                          ),
                          child!,
                        ],
                      ),
                    ),
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: widget.compact ? 56 : 76,
                    minWidth: widget.compact ? 120 : 76,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.compact ? 14 : 18,
                      vertical: widget.compact ? 10 : 16,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(widget.icon, size: 28, color: colors.foreground),
                          const SizedBox(width: 10),
                          Text(
                            widget.label,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: colors.foreground),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!widget.compact && caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  caption,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: StudyColors.muted, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _HoldColors _colors(HoldStyle style, bool enabled) {
    if (!enabled) {
      return const _HoldColors(
        background: StudyColors.disabled,
        foreground: StudyColors.disabledInk,
        border: StudyColors.disabled,
      );
    }
    switch (style) {
      case HoldStyle.primary:
        return const _HoldColors(
          background: StudyColors.green,
          foreground: Colors.white,
          border: StudyColors.greenDark,
        );
      case HoldStyle.secondary:
        return const _HoldColors(
          background: Colors.white,
          foreground: StudyColors.ink,
          border: StudyColors.green,
        );
      case HoldStyle.danger:
        return const _HoldColors(
          background: StudyColors.clay,
          foreground: Colors.white,
          border: Color(0xFF6E2C22),
        );
    }
  }
}

class _HoldColors {
  const _HoldColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
