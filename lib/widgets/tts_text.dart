// lib/widgets/tts_text.dart
import 'package:flutter/material.dart';
import '../services/flutter_tts_service.dart';

class TTSText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool showButton; // Show/hide the speaker icon
  final Color? buttonColor;
  final double? buttonSize;

  const TTSText({
    super.key,
    required this.text,
    this.style,
    this.showButton = true,
    this.buttonColor,
    this.buttonSize = 20,
  });

  @override
  State<TTSText> createState() => _TTSTextState();
}

class _TTSTextState extends State<TTSText> {
  bool _isSpeaking = false;
  final TTSService _tts = TTSService.instance;

  Future<void> _toggleSpeak() async {
    if (!mounted) return;
    
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    } else if (_tts.isEnabled) {
      setState(() => _isSpeaking = true);
      await _tts.speak(widget.text);
      // Reset state when speech completes (optional)
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showButton || !_tts.isEnabled) {
      // Just return plain text if TTS is disabled or button hidden
      return Text(widget.text, style: widget.style);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The actual text content
        Expanded(
          child: Text(widget.text, style: widget.style),
        ),
        // TTS Toggle Button
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              _isSpeaking ? Icons.pause_circle_filled : Icons.volume_up_outlined,
              color: widget.buttonColor ?? Theme.of(context).primaryColor,
              size: widget.buttonSize,
            ),
            onPressed: _toggleSpeak,
            tooltip: _isSpeaking ? 'Stop reading' : 'Read aloud',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Stop speech if widget is removed while speaking
    if (_isSpeaking) _tts.stop();
    super.dispose();
  }
}