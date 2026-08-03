import 'package:flutter/material.dart';
import 'package:nota/core/theme/app_colors.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';

class MindMapConnectionsPainter extends CustomPainter {
  final List<MapNode> nodes;
  final List<MapEdge> edges;
  final Offset? activeDragStart;
  final Offset? activeDragEnd;

  MindMapConnectionsPainter({
    required this.nodes,
    required this.edges,
    this.activeDragStart,
    this.activeDragEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final nodeMap = {for (var node in nodes) node.id: node};

    for (var edge in edges) {
      final fromNode = nodeMap[edge.fromNodeId];
      final toNode = nodeMap[edge.toNodeId];

      if (fromNode != null && toNode != null) {
        // Node center assuming node size is roughly 150x60
        // We will adjust the exact center based on node widget size later
        // For now, let's assume the (x, y) is the top-left, and center is x+75, y+30
        final fromOffset = Offset(fromNode.x + 75, fromNode.y + 30);
        final toOffset = Offset(toNode.x + 75, toNode.y + 30);
        
        _drawCurvedLine(canvas, fromOffset, toOffset, paint);
      }
    }

    if (activeDragStart != null && activeDragEnd != null) {
      final dragPaint = Paint()
        ..color = AppColors.secondary
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
        
      _drawCurvedLine(canvas, activeDragStart!, activeDragEnd!, dragPaint);
    }
  }

  void _drawCurvedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    
    // Create a bezier curve for a more organic mind map look
    final controlPoint1 = Offset((p1.dx + p2.dx) / 2, p1.dy);
    final controlPoint2 = Offset((p1.dx + p2.dx) / 2, p2.dy);
    
    path.cubicTo(
      controlPoint1.dx, controlPoint1.dy,
      controlPoint2.dx, controlPoint2.dy,
      p2.dx, p2.dy,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MindMapConnectionsPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.activeDragStart != activeDragStart ||
        oldDelegate.activeDragEnd != activeDragEnd;
  }
}
