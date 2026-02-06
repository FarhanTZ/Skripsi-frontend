import 'dart:async';
import 'package:flutter/material.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/pages/post_activity_page.dart';

import 'package:glupulse/features/activity/domain/entities/activity_log.dart'; // Import ActivityLog

class ActiveSessionPage extends StatefulWidget {
  final ActivityType activityType;
  final int targetDurationMinutes;
  final int preActivityCarbs;
  final ActivityLog? resumeLog; // Log yang akan dilanjutkan (opsional)

  const ActiveSessionPage({
    super.key,
    required this.activityType,
    required this.targetDurationMinutes,
    this.preActivityCarbs = 0,
    this.resumeLog,
  });

  @override
  State<ActiveSessionPage> createState() => _ActiveSessionPageState();
}

class _ActiveSessionPageState extends State<ActiveSessionPage> {
  // ... (Timer logic sama) ...
  late Timer _timer;
  late int _elapsedSeconds; // Diinisialisasi di initState
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi _elapsedSeconds dengan durasi log sebelumnya jika resume
    _elapsedSeconds = (widget.resumeLog?.durationMinutes ?? 0) * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _finishActivity() {
    _timer.cancel();
    
    // _elapsedSeconds sudah akumulatif (durasi lama + durasi baru)
    // Gunakan round() untuk pembulatan total detik ke menit
    int totalDuration = (_elapsedSeconds / 60).round();
    
    // Pastikan durasi tidak berkurang jika sesi baru sangat pendek
    // Jika resumeLog ada dan totalDuration kurang dari durasi log sebelumnya, set ke durasi log sebelumnya.
    if (widget.resumeLog != null && totalDuration < widget.resumeLog!.durationMinutes) {
      totalDuration = widget.resumeLog!.durationMinutes;
    } else if (widget.resumeLog == null && totalDuration < 1) {
      // Untuk sesi baru, pastikan minimal 1 menit
      totalDuration = 1;
    }


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PostActivityPage(
          activityType: widget.activityType,
          actualDurationMinutes: totalDuration, 
          preActivityCarbs: widget.resumeLog?.preActivityCarbs ?? widget.preActivityCarbs,
          resumeLogId: widget.resumeLog?.activityId, 
          initialLog: widget.resumeLog, 
        ),
      ),
    );
  }
  
  // ... (dispose & build sama, hanya ubah UI sedikit jika resume) ...

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.activityType.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Target: ${widget.targetDurationMinutes} min',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Spacer(),
            // Timer Display
            Text(
              _formatTime(_elapsedSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.w700,
                fontFamily: 'Monospace',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Duration',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const Spacer(),
            // Controls
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Pusatkan tombol-tombol
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // CANCEL BUTTON (Left - Rounded Rectangle)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 60, // Ukuran lebih kecil
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15), // Sudut melengkung
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.close, size: 30, color: Colors.white), // Icon disesuaikan
                      ),
                    ),
                  ),

                  const SizedBox(width: 30), // Jarak lebih jauh

                  // PAUSE/RESUME BUTTON (Center - Rounded Rectangle, & Raised)
                  Transform.translate(
                    offset: const Offset(0.0, -20.0), // Tetap naik
                    child: GestureDetector(
                      onTap: _togglePause,
                      child: Container(
                        width: 80, // Ukuran disesuaikan
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20), // Sudut melengkung
                          border: Border.all(color: Colors.grey.shade600, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                            size: 50, // Icon disesuaikan
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 30), // Jarak lebih jauh

                  // FINISH BUTTON (Right - Rounded Rectangle)
                  GestureDetector(
                    onTap: _finishActivity,
                    child: Container(
                      width: 60, // Ukuran lebih kecil
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15), // Sudut melengkung
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.check, size: 30, color: Colors.white), // Icon disesuaikan
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
