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
  bool _disposed = false;

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
    final options =
        isVideoToText
            ? List<String>.from(item['choices'] ?? [])
            : List<String>.from(item['options'] ?? []);

    print(
      'Initializing controllers for ${isVideoToText ? "video_to_text" : "text_to_video"} quiz',
    );
    print('Options count: ${options.length}');

    if (options.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_disposed && mounted) widget.onAnswered(false);
      });
      return;
    }

    for (final url in options) {
      if (!_controllers.containsKey(url)) {
        final controller = VideoPlayerController.network(url);
        controller
            .initialize()
            .then((_) {
              if (_disposed) return;
              controller.setLooping(true);
              controller.setVolume(0);
              controller.play();
              if (mounted) setState(() {});
            })
            .catchError((e) {
              print("Video init error: $e");
            });
        _controllers[url] = controller;
      }
    }

    if (isVideoToText &&
        item['video_url'] != null &&
        item['video_url'].toString().isNotEmpty) {
      final url = item['video_url'];
      if (!_controllers.containsKey(url)) {
        final controller = VideoPlayerController.network(url);
        controller
            .initialize()
            .then((_) {
              if (_disposed) return;
              controller.setLooping(true);
              controller.setVolume(0);
              controller.play();
              if (mounted) setState(() {});
            })
            .catchError((e) {
              print("Main video init error: $e");
            });
        _controllers[url] = controller;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAnswer(String option, bool isCorrect) {
    if (isAnswered) return;
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
        if (mounted && !_disposed) {
          widget.onAnswered(true);
        }
      });
    }
  }

  void _confirmContinue() {
    if (_disposed) return;
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
    List<String> options = [];
    if (isVideoToText) {
      options = List<String>.from(item['choices'] ?? []);
    } else {
      // For text_to_video, filter only initialized video controllers
      final allOptions = List<String>.from(item['options'] ?? []);
      options =
          allOptions
              .where(
                (opt) =>
                    _controllers.containsKey(opt) &&
                    _controllers[opt]?.value.isInitialized == true,
              )
              .toList();
    }

    print('Building QuizCard with ${options.length} options');
    print('Quiz type: ${isVideoToText ? "video_to_text" : "text_to_video"}');

    if (options.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_disposed && mounted) widget.onAnswered(false);
      });
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
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Video could not be loaded",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),

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
                                          child:
                                              _controllers.containsKey(
                                                        option,
                                                      ) &&
                                                      _controllers[option]
                                                              ?.value
                                                              .isInitialized ==
                                                          true
                                                  ? SizedBox(
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
                                                  )
                                                  : Container(
                                                    height: 120,
                                                    color: Colors.grey.shade300,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
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
