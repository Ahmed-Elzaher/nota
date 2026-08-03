import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/theme/app_colors.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';
import 'package:nota/features/mind_map/presentation/controller/mind_maps_cubit.dart';
import 'package:nota/features/mind_map/presentation/widget/mind_map_connections_painter.dart';
import 'package:nota/features/mind_map/presentation/widget/mind_map_node_widget.dart';
import 'package:uuid/uuid.dart';

class MindMapEditorScreen extends StatefulWidget {
  final MindMapEntity? initialMindMap;

  const MindMapEditorScreen({super.key, this.initialMindMap});

  @override
  State<MindMapEditorScreen> createState() => _MindMapEditorScreenState();
}

class _MindMapEditorScreenState extends State<MindMapEditorScreen> {
  late MindMapEntity mindMap;
  String? selectedNodeId;
  
  bool isDraggingNode = false;
  bool isConnecting = false;

  Offset? activeDragStart;
  Offset? activeDragEnd;
  String? draggingFromNodeId;
  
  final TransformationController _transformationController = TransformationController();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.initialMindMap != null) {
      mindMap = widget.initialMindMap!;
    } else {
      mindMap = MindMapEntity(
        id: 0,
        title: 'خريطة ذهنية جديدة',
        nodes: [
          MapNode(id: _uuid.v4(), text: 'الفكرة الرئيسية', x: 5000, y: 5000),
        ],
        edges: [],
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
    
    if (mindMap.nodes.isNotEmpty) {
      final firstNode = mindMap.nodes.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        _transformationController.value = Matrix4.identity()
          ..setTranslationRaw(
            -(firstNode.x - screenWidth / 2 + 75), 
            -(firstNode.y - screenHeight / 2 + 30),
            0.0,
          );
      });
    }
  }

  void _saveMap() {
    context.read<MindMapsCubit>().saveMindMap(mindMap);
  }

  void _addNodeViaFab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scenePoint = _transformationController.toScene(Offset(screenWidth / 2, screenHeight / 2));
    setState(() {
      mindMap = mindMap.copyWith(
        nodes: [
          ...mindMap.nodes,
          MapNode(id: _uuid.v4(), text: '', x: scenePoint.dx, y: scenePoint.dy),
        ],
      );
    });
    _saveMap();
  }

  void _updateNodePosition(String id, Offset delta) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    final adjustedDelta = delta / scale;
    
    setState(() {
      mindMap = mindMap.copyWith(
        nodes: mindMap.nodes.map((n) {
          if (n.id == id) {
            return n.copyWith(x: n.x + adjustedDelta.dx, y: n.y + adjustedDelta.dy);
          }
          return n;
        }).toList(),
      );
    });
  }

  void _updateNodeText(String id, String newText) {
    setState(() {
      mindMap = mindMap.copyWith(
        nodes: mindMap.nodes.map((n) {
          if (n.id == id) {
            return n.copyWith(text: newText);
          }
          return n;
        }).toList(),
      );
    });
    _saveMap();
  }

  void _updateNodeColor(String id, String? newColor) {
    setState(() {
      mindMap = mindMap.copyWith(
        nodes: mindMap.nodes.map((n) {
          if (n.id == id) {
            return n.copyWith(color: newColor);
          }
          return n;
        }).toList(),
      );
    });
    _saveMap();
  }

  void _deleteNode(String id) {
    setState(() {
      mindMap = mindMap.copyWith(
        nodes: mindMap.nodes.where((n) => n.id != id).toList(),
        edges: mindMap.edges.where((e) => e.fromNodeId != id && e.toNodeId != id).toList(),
      );
      selectedNodeId = null;
    });
    _saveMap();
  }

  void _onConnectDragStart(String nodeId, Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(globalPosition);
    final scenePoint = _transformationController.toScene(localPosition);

    setState(() {
      isConnecting = true;
      draggingFromNodeId = nodeId;
      activeDragStart = scenePoint;
      activeDragEnd = scenePoint;
    });
  }

  void _onConnectDragUpdate(Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(globalPosition);
    final scenePoint = _transformationController.toScene(localPosition);

    setState(() {
      activeDragEnd = scenePoint;
    });
  }

  void _onConnectDragEnd(Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(globalPosition);
    final scenePoint = _transformationController.toScene(localPosition);

    String? targetNodeId;
    for (var node in mindMap.nodes) {
      if (node.id != draggingFromNodeId) {
        final rect = Rect.fromLTWH(node.x, node.y, 150, 60); // approx rect
        if (rect.contains(scenePoint)) {
          targetNodeId = node.id;
          break;
        }
      }
    }

    if (targetNodeId != null && draggingFromNodeId != null) {
      final newEdge = MapEdge(fromNodeId: draggingFromNodeId!, toNodeId: targetNodeId);
      setState(() {
        mindMap = mindMap.copyWith(
          edges: [...mindMap.edges, newEdge],
        );
      });
      _saveMap();
    }

    setState(() {
      isConnecting = false;
      draggingFromNodeId = null;
      activeDragStart = null;
      activeDragEnd = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enableCanvasPan = !isDraggingNode && !isConnecting;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: TextField(
          controller: TextEditingController(text: mindMap.title),
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(border: InputBorder.none),
          onSubmitted: (value) {
            setState(() {
              mindMap = mindMap.copyWith(title: value);
            });
            _saveMap();
          },
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.iconDefault,
          ),
          onPressed: () {
            _saveMap();
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'mind_map_editor_fab',
        onPressed: _addNodeViaFab,
        label: const Text('إضافة فكرة', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: HugeIcon(icon: HugeIcons.strokeRoundedAdd01, color: AppColors.onPrimary),
        backgroundColor: AppColors.primary,
      ),
      body: GestureDetector(
        onTapDown: (details) {
          if (selectedNodeId != null) {
            setState(() {
              selectedNodeId = null;
            });
            FocusScope.of(context).unfocus();
          }
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.1,
          maxScale: 4.0,
          panEnabled: enableCanvasPan,
          scaleEnabled: enableCanvasPan,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Grid
              Container(
                width: 10000,
                height: 10000,
                color: Colors.transparent,
              ),
              
              // Edges Layer
              RepaintBoundary(
                child: CustomPaint(
                  painter: MindMapConnectionsPainter(
                    nodes: mindMap.nodes,
                    edges: mindMap.edges,
                    activeDragStart: activeDragStart,
                    activeDragEnd: activeDragEnd,
                  ),
                  child: const SizedBox(width: 10000, height: 10000),
                ),
              ),
              
              // Nodes Layer
              ...mindMap.nodes.map((node) {
                return Positioned(
                  left: node.x,
                  top: node.y,
                  child: GestureDetector(
                    onPanStart: (_) {
                      setState(() {
                        isDraggingNode = true;
                      });
                    },
                    onPanUpdate: (details) {
                      _updateNodePosition(node.id, details.delta);
                    },
                    onPanEnd: (_) {
                      setState(() {
                        isDraggingNode = false;
                      });
                      _saveMap();
                    },
                    onPanCancel: () {
                      setState(() {
                        isDraggingNode = false;
                      });
                    },
                    child: MindMapNodeWidget(
                      node: node,
                      isSelected: selectedNodeId == node.id,
                      onTap: () {
                        setState(() {
                          selectedNodeId = node.id;
                        });
                      },
                      onTextChanged: (text) => _updateNodeText(node.id, text),
                    ),
                  ),
                );
              }),

              // Floating Toolbar Layer (Only for selected node)
              if (selectedNodeId != null)
                ...mindMap.nodes.where((n) => n.id == selectedNodeId).map((node) {
                  return Positioned(
                    left: node.x,
                    top: node.y - 65.h, // Float above the node
                    child: _buildFloatingToolbar(node),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingToolbar(MapNode node) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onPanStart: (details) => _onConnectDragStart(node.id, details.globalPosition),
            onPanUpdate: (details) => _onConnectDragUpdate(details.globalPosition),
            onPanEnd: (details) => _onConnectDragEnd(details.globalPosition),
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedLink01,
                color: AppColors.onPrimary,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 24.h,
            width: 1,
            color: AppColors.border,
          ),
          SizedBox(width: 12.w),
          _buildColorOption('#F44336', node), // Red
          _buildColorOption('#2196F3', node), // Blue
          _buildColorOption('#4CAF50', node), // Green
          _buildColorOption('#FFEB3B', node), // Yellow
          _buildColorOption('#FF9800', node), // Orange
          SizedBox(width: 12.w),
          Container(
            height: 24.h,
            width: 1,
            color: AppColors.border,
          ),
          SizedBox(width: 12.w),
          InkWell(
            onTap: () => _deleteNode(node.id),
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedDelete01,
                color: AppColors.error,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(String hexColor, MapNode node) {
    final Color color = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    final bool isSelected = (node.color == hexColor);

    return GestureDetector(
      onTap: () => _updateNodeColor(node.id, hexColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2.5,
          ),
        ),
      ),
    );
  }
}
