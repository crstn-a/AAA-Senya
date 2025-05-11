// 📄 lesson_screen.dart (patched)
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../dashboards/lessonScreen/learning_top_bar.dart';
import '../../dashboards/lessonScreen/video_section.dart';
import '../../../screens/dashboards/quizzes/quiz_card.dart';

class LessonModuleScreen extends StatefulWidget {
  final int lessonId;
  final String? lessonTitle;

  const LessonModuleScreen({
    super.key,
    required this.lessonId,
    this.lessonTitle,
  });

  @override
  State<LessonModuleScreen> createState() => _LessonModuleScreenState();
}

class _LessonModuleScreenState extends State<LessonModuleScreen> {
  int hearts = 3;
  List<Map<String, dynamic>> lessonContent = [];
  int currentIndex = 0;
  bool isLoading = true;
  double _videoSpeed = 1.0;
  String? lessonTitle;

  @override
  void initState() {
    super.initState();
    lessonTitle = widget.lessonTitle;
    _loadLessonData();
  }

  Future<void> _loadLessonData() async {
    try {
      final rawData = await ApiService().fetchGeneratedQuiz(widget.lessonId);

      if (rawData.isEmpty) {
        print('Error: No quiz data returned from API');
        setState(() {
          isLoading = false;
        });
        return;
      }

      print('Loaded ${rawData.length} items from API');

      final List<Map<String, dynamic>> signs = [];
      final List<Map<String, dynamic>> quizzes = [];

      for (final item in rawData) {
        print('Processing item type: ${item['type']}');

        if (item['type'] == 'video_to_text') {
          signs.add({
            "type": "sign",
            "word": item['correct_answer'],
            "videoUrl": item['video_url'],
          });
        }

        // Allow both types of quizzes even if no signs
        if (item['type'] == 'video_to_text' ||
            item['type'] == 'text_to_video') {
          quizzes.add(item);
        }
      }

      final List<Map<String, dynamic>> mixedContent = [];

      // 🧠 New logic: If no signs, proceed only with quizzes
      if (signs.isEmpty) {
        mixedContent.addAll(quizzes);
      } else {
        int signIndex = 0;
        int quizIndex = 0;

        while (signIndex < signs.length || quizIndex < quizzes.length) {
          if (signIndex < signs.length) {
            mixedContent.add(signs[signIndex]);
            signIndex++;

            if (quizIndex < quizzes.length) {
              mixedContent.add(quizzes[quizIndex]);
              quizIndex++;
            }
          } else if (quizIndex < quizzes.length) {
            mixedContent.add(quizzes[quizIndex]);
            quizIndex++;
          }
        }
      }

      print('Final content length: ${mixedContent.length}');

      if (mounted) {
        setState(() {
          lessonContent = mixedContent;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching quiz: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _showCongratsDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "🎉 Congratulations!",
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "You've completed the lesson!",
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/user',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Back to Home"),
              ),
            ],
          ),
    );
  }

  void handleNext() {
    if (currentIndex < lessonContent.length - 1) {
      setState(() => currentIndex++);
    } else if (currentIndex == lessonContent.length - 1) {
      setState(() => currentIndex++);
      _showCongratsDialog();
    }
  }

  void handleSlowMotion() {
    setState(() {
      _videoSpeed = (_videoSpeed == 1.0) ? 0.5 : 1.0;
    });
  }

  void handleMirror() {
    print("Mirror pressed");
  }

  void checkAnswer(bool isCorrect) {
    if (!isCorrect) {
      setState(() {
        hearts = (hearts > 0) ? hearts - 1 : 0;
      });
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) handleNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (lessonContent.isEmpty || currentIndex >= lessonContent.length) {
      return Scaffold(
        appBar: AppBar(title: Text(lessonTitle ?? "Lesson ${widget.lessonId}")),
        body: const Center(child: Text("No content available for this lesson")),
      );
    }

    final currentItem = lessonContent[currentIndex];
    print('Current index: $currentIndex/${lessonContent.length - 1}');
    print('Current item type: ${currentItem['type']}');

    return Scaffold(
      appBar: AppBar(title: Text(lessonTitle ?? "Lesson ${widget.lessonId}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LearningTopBar(
              currentStep: currentIndex + 1,
              totalSteps: lessonContent.length,
              hearts: hearts,
            ),
            const SizedBox(height: 20),

            if (currentItem['type'] == 'sign')
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VideoSection(
                        videoUrl: currentItem['videoUrl'],
                        playbackSpeed: _videoSpeed,
                        onMirrorPressed: handleMirror,
                        onSlowMotionPressed: handleSlowMotion,
                        height: 240,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        currentItem['word'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: handleNext,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (currentItem['type'] == 'video_to_text' ||
                currentItem['type'] == 'text_to_video')
              QuizCard(quizItem: currentItem, onAnswered: checkAnswer)
            else
              FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 500), () {
                  handleNext();
                }),
                builder:
                    (context, snapshot) => const Center(
                      child: Text("Skipping unsupported content..."),
                    ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
