import 'package:flutter/material.dart';

/// Permite mover un bloque de calendario: mantener pulsado y arrastrar.
/// Vertical = hora (saltos de 15 min); horizontal = día, si se indica
/// [dayWidth]. Al soltar llama a [onMove] solo si algo cambió.
class DragToMove extends StatefulWidget {
  const DragToMove({
    super.key,
    required this.hourHeight,
    required this.onMove,
    required this.child,
    this.dayWidth,
  });

  final double hourHeight;
  final double? dayWidth;
  final void Function(int dayDelta, int minuteDelta) onMove;
  final Widget child;

  @override
  State<DragToMove> createState() => _DragToMoveState();
}

class _DragToMoveState extends State<DragToMove> {
  Offset _offset = Offset.zero;
  bool _dragging = false;

  (int, int) _deltas() {
    final minutes = (_offset.dy / widget.hourHeight * 60 / 15).round() * 15;
    final w = widget.dayWidth;
    final days = w == null ? 0 : (_offset.dx / w).round();
    return (days, minutes);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _offset,
      child: GestureDetector(
        onLongPressStart: (_) => setState(() => _dragging = true),
        onLongPressMoveUpdate: (d) => setState(() => _offset = d.offsetFromOrigin),
        onLongPressEnd: (_) {
          final (days, minutes) = _deltas();
          setState(() {
            _offset = Offset.zero;
            _dragging = false;
          });
          if (days != 0 || minutes != 0) widget.onMove(days, minutes);
        },
        onLongPressCancel: () => setState(() {
          _offset = Offset.zero;
          _dragging = false;
        }),
        child: Opacity(opacity: _dragging ? 0.7 : 1, child: widget.child),
      ),
    );
  }
}
