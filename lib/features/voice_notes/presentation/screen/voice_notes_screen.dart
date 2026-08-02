import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';

class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.voiceNotes,
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulse Animation when recording
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 150.w + (_isRecording ? (_pulseController.value * 30.w) : 0),
                  height: 150.w + (_isRecording ? (_pulseController.value * 30.w) : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording 
                        ? Colors.red.withValues(alpha: 0.2 - (_pulseController.value * 0.1))
                        : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  ),
                  child: child,
                );
              },
              child: Center(
                child: GestureDetector(
                  onTap: _toggleRecording,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? Colors.red : Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: _isRecording ? Colors.red.withValues(alpha: 0.4) : Theme.of(context).primaryColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: _isRecording ? HugeIcons.strokeRoundedStop : HugeIcons.strokeRoundedMic01,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              _isRecording ? 'جاري التسجيل...' : 'اضغط للتسجيل',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: _isRecording ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12.h),
            if (!_isRecording)
              Text(
                'سجل أفكارك بصوتك وسنحتفظ بها لك',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
