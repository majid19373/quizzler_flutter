import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  List<Widget> scoreKeeper = [];

  int scoreTrueAnswer = 0;
  int scoreFalseAnswer = 0;

  void reset() {
    quizBrain.reset();
    setState(() {
      scoreTrueAnswer = 0;
      scoreFalseAnswer = 0;
      scoreKeeper = [];
      quizBrain.nextQuestion();
    });
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    Widget icon;
    if(correctAnswer == userPickedAnswer){
      icon = const Icon(
        Icons.check,
        color: Colors.green,
      );
    }else{
      icon = const Icon(
        Icons.close,
        color: Colors.red,
      );
    }
    setState(() {
      if(!quizBrain.getLastQuestion()) {
        if(correctAnswer == userPickedAnswer){
          scoreTrueAnswer++;
        }else{
          scoreFalseAnswer++;
        }
        scoreKeeper.add(icon);
      }
      quizBrain.nextQuestion();
    });
    if(quizBrain.getLastQuestion()){
      final int answer = quizBrain.getAnswer();
      Alert(
          context: context,
          type: scoreTrueAnswer >= answer ? AlertType.success : AlertType.error,
          title: scoreTrueAnswer >= answer ? 'Perfect' : 'try harder',
          content: Column(
            children: <Widget>[
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                      'True Answers:',
                    style: TextStyle(
                      color: Colors.green
                    ),
                  ),
                  Text(
                      '$scoreTrueAnswer',
                    style: const TextStyle(
                        color: Colors.green
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                      'False Answers:',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                  Text(
                      '$scoreFalseAnswer',
                    style: const TextStyle(
                        color: Colors.red
                    ),
                  )
                ],
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () {
                  Navigator.pop(context);
                  reset();
              },
              width: 120,
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}