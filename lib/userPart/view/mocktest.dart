import 'dart:async';

import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:fast_quiz_tayari/userPart/repostory/firebaseApi.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/customButton.dart';
import '../widgets/questionwidget.dart';
import '../widgets/resultDailog.dart';
import 'score.dart';

class Mocktest extends StatefulWidget {
  final String subject;
  final String mock;

  const Mocktest({super.key, required this.subject, required this.mock});

  @override
  State<Mocktest> createState() => _MocktestState();
}

class _MocktestState extends State<Mocktest> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  double score = 0;
  Map<int, String?> selectedOptions =
      {}; // Track selected options for each question
  int remainingMinutes = 20; // Timer starting minutes
  int remainingSeconds = 0; // Timer starting seconds
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds == 0 && remainingMinutes > 0) {
          remainingMinutes--;
          remainingSeconds = 59;
        } else if (remainingSeconds > 0) {
          remainingSeconds--;
        } else if (remainingMinutes == 0 && remainingSeconds == 0) {
          timer.cancel();
          _navigateToScoreScreen();
        }
      });
    });
  }

  void _navigateToScoreScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreChart(
          avgScore: 15, // Replace with the actual average score if available
          topperScore: 35, // Replace with the actual topper score if available
          yourScore: score,
          subject: widget.subject,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Fetch the questions based on subject and mock
  void loadQuestions() async {
    List<Map<String, dynamic>> fetchedQuestions =
        await MyDb.fetchQuestions(subject: widget.subject, mock: widget.mock);

    questions = await fetchedQuestions; // Assign the returned list

    print("🔄 Questions assigned in initState: ${questions.length}");
  }

  void _submitAnswer(String selectedOption) {
    final currentQuestion = questions[currentQuestionIndex];
    if (selectedOption == currentQuestion['correctAnswer']) {
      setState(() {
        score += 1; // Correct answer: add 1 point
      });
    } else {
      setState(() {
        score = (score - 0.25)
            .clamp(0, double.infinity); // Ensures score doesn't go below 0
      });
    }

    // Navigate to the next question or finish the test
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Show dialog before navigating to the score screen
    }
  }

  // Function to show the result analysis dialog

  DateTime? _lastBackPressedTime;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Mock Test - ${widget.subject}")),
        body: Center(
          child: Text(
            'Upcoming Soon!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        const backButtonInterval = Duration(seconds: 2);

        if (_lastBackPressedTime == null ||
            now.difference(_lastBackPressedTime!) > backButtonInterval) {
          // Update the last pressed time
          _lastBackPressedTime = now;

          // Show a toast or snackbar message (optional)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );

          return false; // Do not exit the app
        }

        return true; // Exit the app on second tap within the interval
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mock Test - ${widget.subject}"),
          automaticallyImplyLeading: false, // Removes the default back button
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display current question
              SmokeyQuestionWidget(
                question: currentQuestion["question"],
                serialNumber: currentQuestionIndex + 1,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.timer, color: Colors.green),
                  const SizedBox(width: 10),
                  Text(
                    '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                    style: GoogleFonts.alike(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
              // Display options (Radio Buttons)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: currentQuestion['options'].length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(width: 0.5, color: Colors.grey.shade400),
                      ),
                      child: RadioListTile<String>(
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Reduces the size
                        activeColor: Colors.green,
                        value: currentQuestion['options'][index],
                        groupValue: selectedOptions[currentQuestionIndex],
                        title: Text(
                          currentQuestion['options'][index],
                          style: GoogleFonts.acme(
                              color: Colors.black.withOpacity(0.7),
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400),
                        ),
                        onChanged: (value) {
                          MyDb.fetchAndUpdateQuestion(
                            subject: widget.subject,
                            mock: widget.mock,
                            questionIndex: currentQuestionIndex,
                            selectedOption: value!,
                          );

                          setState(() {
                            selectedOptions[currentQuestionIndex] = value;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              // Show Previous Button and Next Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            if (currentQuestionIndex > 0)
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      currentQuestionIndex--;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: AppColor.redColor,
                                  ),
                                ),
                              ),
                            Spacer(),
                            Visibility(
                              visible:
                                  currentQuestionIndex < questions.length - 1,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (selectedOptions[currentQuestionIndex] !=
                                        null) {
                                      _submitAnswer(selectedOptions[
                                          currentQuestionIndex]!);
                                    } else {
                                      // Just move to next question even without selection
                                      _submitAnswer('');
                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: AppColor.theme,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Show Submit Button if it's the last question
                      Custombutton(
                          label: "summit",
                          onPressed: () async {
                            ResultDialog.show(
                                context, widget.subject, widget.mock, score);
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
