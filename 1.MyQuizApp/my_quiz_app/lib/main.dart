import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QuizApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizApp extends StatefulWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  State createState() {
    return _QuizAppState();
  }
}

class SingleQuestionModel {
  final String? question;
  final List<String>? options;
  final int? answerIndex;

  const SingleQuestionModel({this.question, this.options, this.answerIndex});
}

class _QuizAppState extends State<QuizApp> {
  List allQuestions = [
    const SingleQuestionModel(
      question: "Who is the Founder of the Microsoft?",
      options: ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      answerIndex: 2,
    ),
    const SingleQuestionModel(
      question: "Who is the Founder of the Apple?",
      options: ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      answerIndex: 0,
    ),
    const SingleQuestionModel(
      question: "Who is the Founder of the Amazon?",
      options: ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      answerIndex: 1,
    ),
    const SingleQuestionModel(
      question: "Who is the Founder of the Tesla?",
      options: ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      answerIndex: 3,
    ),
    const SingleQuestionModel(
      question: "Who is the Founder of the Google?",
      options: ["Steve Jobs", "Larry Page", "Bill Gates", "Elon Musk"],
      answerIndex: 1,
    ),
  ];

  bool welcomeScreen = true;
  bool quizScreen = false;
  bool congratulationScreen = false;

  int questionIndex = 0;
  int selectedAnswerIndex = -1;
  int noOfCorrectedAnswers = 0;

  String userName = '';

  MaterialStateProperty<Color?> checkAnswer(int buttonIndex) {
    if (selectedAnswerIndex != -1) {
      if (buttonIndex == allQuestions[questionIndex].answerIndex) {
        return const MaterialStatePropertyAll(Colors.green);
      } else if (buttonIndex == selectedAnswerIndex) {
        return const MaterialStatePropertyAll(Colors.red);
      } else {
        return const MaterialStatePropertyAll(null);
      }
    } else {
      return const MaterialStatePropertyAll(null);
    }
  }

  void validateCurrentPage() {
    if (selectedAnswerIndex == -1) {
      return;
    }

    if (selectedAnswerIndex == allQuestions[questionIndex].answerIndex) {
      noOfCorrectedAnswers += 1;
    }

    if (selectedAnswerIndex != -1) {
      if (questionIndex == allQuestions.length - 1) {
        setState(() {
          congratulationScreen = true;
          quizScreen = false;
        });
        return;
      }

      selectedAnswerIndex = -1;
      setState(() {
        questionIndex += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: welcomeScreen
            ? const Text(
                "Quiz-App",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              )
            : Text(
                "Welcome, $userName!",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 9, 96, 134), // Deep Orange
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: welcomeScreen
          ? _buildWelcomeScreen()
          : quizScreen
              ? _buildQuizScreen()
              : congratulationScreen
                  ? _buildCongratulationScreen()
                  : const SizedBox(),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter your name to start the Quiz",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
            
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              
              decoration: const InputDecoration(
                
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (userName.isNotEmpty) {
                setState(() {
                  welcomeScreen = false;
                  quizScreen = true;
                });
              }
            },
            child: const Text(
              "Let's Start",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Questions",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${questionIndex + 1}/${allQuestions.length}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  allQuestions[questionIndex].question!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ...List.generate(
                  allQuestions[questionIndex].options!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: checkAnswer(index),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                      ),
                      onPressed: () {
                        if (selectedAnswerIndex == -1) {
                          setState(() {
                            selectedAnswerIndex = index;
                          });
                        }
                      },
                      child: Text(
                        "${String.fromCharCode(65 + index)}.${allQuestions[questionIndex].options![index]}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              validateCurrentPage();
            },
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.forward,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCongratulationScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXoQv-7jqDp7BeeJ-3sAKv4MASv4iK7Qw3Sg&usqp=CAU",
            height: 200,
            width: 380,
          ),
          const SizedBox(height: 20),
          const Text(
            "Congratulations!!!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "You have completed the Quiz",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 10),
          const Text("Your Score is"),
          const SizedBox(height: 10),

          Text(
            "$noOfCorrectedAnswers/${allQuestions.length}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                questionIndex = 0;
                welcomeScreen = true;
                congratulationScreen = false;
                noOfCorrectedAnswers = 0;
                selectedAnswerIndex = -1;
                userName = '';
              });
            },
            
            child: const Text(
              "Reset",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
