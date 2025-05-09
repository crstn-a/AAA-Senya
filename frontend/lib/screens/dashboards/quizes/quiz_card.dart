// Enhanced QuizCard with fixed video tap, null safety, and centered confetti
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import '../../../themes/color.dart';

class QuizCard extends StatefulWidget {
  final Map<String, dynamic> quizItem;
  final void Function(bool isCorrect) onAnswered;

  const QuizCard({super.key, required this.quizItem, required this.onAnswered});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> with TickerProviderStateMixin {
  String? selectedOption;
  bool isAnswered = false;
  bool showFeedback = false;
  bool isCorrectAnswer = false;
  bool confirmVisible = false;
  Map<String, VideoPlayerController> _controllers = {};
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
    _initializeControllers();
  }

  void _initializeControllers() {
    final item = widget.quizItem;
    final isVideoToText = item['type'] == 'video_to_text';
    final options = isVideoToText ? item['choices'] : item['options'];

    for (final url in options) {
      if (url != null &&
          url.toString().isNotEmpty &&
          !_controllers.containsKey(url)) {
        final controller = VideoPlayerController.network(url);
        controller
            .initialize()
            .then((_) {
              controller.setLooping(true);
              controller.setVolume(0);
              controller.play();
              setState(() {});
            })
            .catchError((_) {
              setState(() {
                _controllers.remove(url);
              });
            });
        _controllers[url] = controller;
      }
    }

    if (isVideoToText &&
        item['video_url'] != null &&
        item['video_url'].toString().isNotEmpty) {
      final previewUrl = item['video_url'];
      if (!_controllers.containsKey(previewUrl)) {
        final controller = VideoPlayerController.network(previewUrl);
        controller
            .initialize()
            .then((_) {
              controller.setLooping(true);
              controller.setVolume(0);
              controller.play();
              setState(() {});
            })
            .catchError((_) {
              setState(() {
                _controllers.remove(previewUrl);
              });
            });
        _controllers[previewUrl] = controller;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAnswer(String option, bool isCorrect) {
    setState(() {
      selectedOption = option;
      isAnswered = true;
      showFeedback = true;
      isCorrectAnswer = isCorrect;
    });

    if (!isCorrect) {
      HapticFeedback.vibrate();
      setState(() => confirmVisible = true);
    } else {
      _confettiController.play();
      Future.delayed(const Duration(seconds: 1), () {
        widget.onAnswered(true);
        setState(() => showFeedback = false);
      });
    }
  }

  void _confirmContinue() {
    setState(() {
      confirmVisible = false;
      showFeedback = false;
    });
    widget.onAnswered(false);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.quizItem;
    final isVideoToText = item['type'] == 'video_to_text';
    final options =
        isVideoToText
            ? List<String>.from(item['choices'] ?? [])
            : List<String>.from(
              (item['options'] ?? []).where(
                (opt) => _controllers[opt]?.value.isInitialized ?? false,
              ),
            );

    if (options.isEmpty) {
      return const Center(
        child: Text(
          '⚠️ Skipping: No valid quiz options available.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    final correctAnswer =
        isVideoToText ? item['correct_answer'] : item['correct_video'];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isVideoToText
                      ? "What does this sign mean?"
                      : item['question'] ??
                          "Which video shows the correct sign?",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                if (isVideoToText &&
                    _controllers.containsKey(item['video_url']) &&
                    _controllers[item['video_url']]?.value.isInitialized ==
                        true)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: VideoPlayer(_controllers[item['video_url']]!),
                    ),
                  )
                else if (isVideoToText)
                  const Icon(Icons.error_outline, color: Colors.red),

                const SizedBox(height: 24),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  children:
                      options.map<Widget>((option) {
                        final isCorrect = option == correctAnswer;
                        final isSelected = selectedOption == option;

                        Color borderColor() {
                          if (!isAnswered) return AppColors.accentOrange;
                          if (isSelected && isCorrect) return Colors.green;
                          if (isSelected && !isCorrect) return Colors.red;
                          return AppColors.accentOrange;
                        }

                        return SizedBox(
                          width: isMobile ? double.infinity : 260,
                          child: GestureDetector(
                            onTap:
                                isAnswered
                                    ? null
                                    : () => _handleAnswer(option, isCorrect),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderColor(),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(8),
                              child:
                                  isVideoToText
                                      ? Text(
                                        option,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),
                                      )
                                      : GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap:
                                            isAnswered
                                                ? null
                                                : () => _handleAnswer(
                                                  option,
                                                  isCorrect,
                                                ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: SizedBox(
                                            height: 120,
                                            child: AspectRatio(
                                              aspectRatio:
                                                  _controllers[option]!
                                                      .value
                                                      .aspectRatio,
                                              child: VideoPlayer(
                                                _controllers[option]!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),

        if (showFeedback)
          Center(
            child: AnimatedOpacity(
              opacity: showFeedback ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCorrectAnswer ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isCorrectAnswer ? "✅ Correct!" : "❌ Wrong",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!isCorrectAnswer)
                      _controllers.containsKey(correctAnswer) &&
                              _controllers[correctAnswer]
                                      ?.value
                                      .isInitialized ==
                                  true
                          ? Column(
                            children: [
                              Text(
                                "Correct Answer:",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: 120,
                                  child: AspectRatio(
                                    aspectRatio:
                                        _controllers[correctAnswer]!
                                            .value
                                            .aspectRatio,
                                    child: VideoPlayer(
                                      _controllers[correctAnswer]!,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Text(
                            "Correct Answer: $correctAnswer",
                            style: const TextStyle(color: Colors.white),
                          ),
                    if (confirmVisible)
                      TextButton(
                        onPressed: _confirmContinue,
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

        if (showFeedback && isCorrectAnswer)
          Positioned.fill(
            child: IgnorePointer(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.2,
                numberOfParticles: 20,
                gravity: 0.3,
                colors: const [Colors.white, Colors.green, Colors.orange],
              ),
            ),
          ),
      ],
    );
  }
}
