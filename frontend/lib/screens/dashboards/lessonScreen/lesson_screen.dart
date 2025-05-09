import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../dashboards/lessonScreen/learning_top_bar.dart';
import '../../dashboards/lessonScreen/video_section.dart';
import '../../dashboards/quizes/quiz_card.dart'; // ✅ Updated path to QuizCard

class LessonModuleScreen extends StatefulWidget {
  final int lessonId;

  const LessonModuleScreen({super.key, required this.lessonId});

  @override
  State<LessonModuleScreen> createState() => _LessonModuleScreenState();
}

class _LessonModuleScreenState extends State<LessonModuleScreen> {
  int hearts = 3;
  List<Map<String, dynamic>> lessonContent = [];
  int currentIndex = 0;
  bool isLoading = true;
  double _videoSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadLessonData();
  }

  Future<void> _loadLessonData() async {
    try {
      final rawData = await ApiService().fetchGeneratedQuiz(widget.lessonId);
      final List<Map<String, dynamic>> signs = [];
      final List<Map<String, dynamic>> quizzes = [];

      for (final item in rawData) {
        if (item['type'] == 'video_to_text') {
          signs.add({
            "type": "sign",
            "word": item['correct_answer'],
            "videoUrl": item['video_url'],
          });
        }
        quizzes.add(item);
      }

      final List<Map<String, dynamic>> mixedContent = [];
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

      setState(() {
        lessonContent = mixedContent;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching quiz: $e');
      setState(() {
        isLoading = false;
      });
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
              "You’ve completed the lesson!",
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
    } else {
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
    Future.delayed(const Duration(seconds: 1), handleNext);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentItem = lessonContent[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Lesson ${widget.lessonId}")),
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
            else
              QuizCard(quizItem: currentItem, onAnswered: checkAnswer),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
