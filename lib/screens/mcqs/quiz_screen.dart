import 'dart:core';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pak_mega_mcqs/Screens/home/main_screen.dart';
import 'package:pak_mega_mcqs/Screens/results/quiz_result_screen.dart';
import 'package:pak_mega_mcqs/Widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/Widgets/text_widget.dart';
import 'package:pak_mega_mcqs/providers/coins_provider.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/providers/points_provider.dart';
import 'package:pak_mega_mcqs/providers/setting_provider.dart';
import 'package:pak_mega_mcqs/providers/user_information_provider.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';
import 'package:provider/provider.dart';
import '../../model/options_model.dart';
import '../../model/questions_model.dart';
import '../../utils/app_colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  PageController pageController = PageController(initialPage: 0);
  CountDownController countDownController = CountDownController();
  int currentQuestion = 2;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int attemptedQuestion = 0;
  int totalQuestion = 0;
  int score = 0;
  String correct = "audios/correct.mp3";
  String wrong = "audios/wrong.mp3";
  // final assetsAudioPlayer = AssetsAudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  List<QuestionModel> questionList = [];
  bool isSoundON = false;
  String? review = "";

  @override
  void initState() {
    super.initState();
    // assetsAudioPlayer.open(Audio('assets/audios/tik_sound.mp3'),
    //   autoStart: true,
    // );
    // getData(context);
    isSoundON = context.read<SettingsProvider>().isSoundON!;
  }
  @override
  void dispose() {
    pageController.dispose();
    if(!isSoundON){
      audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // questionList = ModalRoute.of(context)!.settings.arguments as List<QuestionModel>;
    review = (ModalRoute.of(context)?.settings.arguments ?? "") as String?;
    questionList = context.watch<MCQsDbProvider>().questionList;
    String? result = (ModalRoute.of(context)?.settings.arguments ?? "") as String?;
    print(review);
    return WillPopScope(
      onWillPop: () async {
        context.read<MCQsDbProvider>().changeState(false);
        context.read<MCQsDbProvider>().resetQuestionsList();
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => const SubCategoriesScreen()));
        Navigator.of(context).pop();
        return true;
      },
      child: CustomScreenWidget(
          title: "QUIZ",
          onPress: () {
            context.read<MCQsDbProvider>().changeState(false);
            context.read<MCQsDbProvider>().resetQuestionsList();
            Navigator.of(context).pop();
          },
          child: questionList.isEmpty ? const Center(child: SpinKitCubeGrid(
            color: Colors.orangeAccent,
            size: 50.0,
          )) : Consumer<MCQsDbProvider>(
            builder: (context, value, child) {
              return PageView.builder(
                  itemCount: value.questionList.length,
                  controller: pageController,
                  physics: result == "" ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    QuestionModel model = value.questionList[index];
                    return Container(
                      // color: Colors.red,
                      // bottom: Dimensions.height30
                      margin: EdgeInsets.only(
                        top: Dimensions.height50 + 10,
                        left: Dimensions.height10 + 1,
                        right: Dimensions.height10 + 1,),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.height10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(blurRadius: 5,
                                      color: Colors.grey.withOpacity(0.8),
                                      offset: const Offset(1, 1)),
                                  // BoxShadow(color: Colors.grey,offset: Offset(0.5,0.5)),
                                ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.height10),
                                        topRight: Radius.circular(
                                            Dimensions.height10)),
                                    // boxShadow: [BoxShadow(color: Colors.grey,offset: Offset(1,1))]
                                  ),
                                  child: Column(
                                    children: [
                                      // First Row timer, and question number
                                      SizedBox(
                                        height: Dimensions.height30,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              top: 6,
                                              right: 5,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(Dimensions.height10)
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,),
                                                  TextWidget(
                                                    text: incorrectAnswers
                                                        .toString(),
                                                    textColor: Colors
                                                        .red,)
                                                ],
                                              ),
                                            ),
                                             Positioned.fill(
                                              top: -Dimensions.height50 + 10,
                                              child: review == "" ? Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  height: Dimensions.height50 + 20,
                                                  width: Dimensions.height50 + 20,
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(Dimensions.height50 + 20),
                                                      boxShadow: const[
                                                        BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(0.1, -0.1),),
                                                        BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(-0.1, 0.1),)
                                                      ]
                                                  ),
                                                  child: CircularCountDownTimer(
                                                    width: Dimensions.height50,
                                                    height: Dimensions.height50,
                                                    duration: 60,
                                                    fillColor: Colors.grey.shade400,
                                                    ringColor: Colors.orange,
                                                    controller: countDownController,
                                                    backgroundColor: Colors.white54,
                                                    strokeWidth: 5,
                                                    strokeCap: StrokeCap.round,
                                                    textStyle: TextStyle(
                                                        fontSize: Dimensions.height20,
                                                        color: Colors.black),
                                                    isTimerTextShown: true,
                                                    isReverse: true,
                                                    onComplete: () {
                                                      countDownController.reset();
                                                      gotoNext(index);
                                                    },
                                                  ) ,
                                                ),
                                              ) : const SizedBox.shrink(),
                                            ),
                                            Positioned(
                                              top: 6,
                                              left: 5,
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                    text: correctAnswers.toString(),
                                                    textColor: Colors.greenAccent,),
                                                  const SizedBox(width: 4,),
                                                  Container(
                                                    height: 10,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.greenAccent,
                                                        borderRadius: BorderRadius.circular(Dimensions.height10)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: Dimensions.height10,
                                              bottom: Dimensions
                                                  .height15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              TextWidget(
                                                  text: 'Question ',
                                                  textColor: Colors.black,
                                                  fontSize: Dimensions
                                                      .height20,
                                                  fontWeight: FontWeight
                                                      .w500),
                                              Text((index + 1).toString(),
                                                style: TextStyle(
                                                    fontSize: Dimensions
                                                        .height30 + 2,
                                                    fontWeight: FontWeight
                                                        .bold),),
                                              TextWidget(
                                                  text: ' / ${questionList
                                                      .length}',
                                                  textColor: Colors.black,
                                                  fontSize: Dimensions
                                                      .height20,
                                                  fontWeight: FontWeight
                                                      .w500)
                                            ],)),

                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: Dimensions.height30 + 6,
                                        left: Dimensions.height10,
                                        right: Dimensions.height10,
                                        bottom: Dimensions.height30 + 6),
                                    // padding: EdgeInsets.only(bottom: Dimensions.height30),
                                    child: TextWidget(
                                      text: model.questionText!,
                                      textColor: Colors.black,
                                      fontSize: Dimensions.height20,)),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height35 + 5,),
                          Flexible(
                              child: ListView.builder(
                                  itemCount: model.options!.length,
                                  itemBuilder: (context, index) {
                                    List<Options> optionsList = model
                                        .options!;
                                    Options option = optionsList[index];
                                    Color color = getColorsForOptions(
                                        option, model);
                                    return InkWell(
                                      onTap: () {
                                        int coins = context.read<CoinsProvider>().coins;
                                        print('--------$coins---------');
                                        if (model.isLock!) {
                                          return;
                                        } else {
                                          setState(() {
                                            model.isLock = true;
                                            model.selectedOption = option;
                                          });
                                          attemptedQuestion++;
                                          // isLocked = widget.questionModel.isLock!;
                                          if (model.selectedOption!.isCorrect!) {
                                            correctAnswers++;
                                            score++;
                                            if(!isSoundON){
                                              audioPlayer.play(AssetSource(correct));
                                              // audioPlayer.onPlayerComplete.listen((event) {
                                              //   audioPlayer.play(AssetSource('audios/tik_sound.mp3'));
                                              // });
                                            }
                                          } else {
                                            if(!isSoundON){
                                              audioPlayer.play(AssetSource(wrong));
                                              // audioPlayer.onPlayerComplete.listen((event) {
                                              //   audioPlayer.play(AssetSource('audios/tik_sound.mp3'));
                                              // });
                                            }
                                            context.read<CoinsProvider>().reduceCoins(context);
                                            incorrectAnswers++;
                                          }
                                          // countCorrectAndIncorrectAnswer(option, model);
                                          if(coins != 0){
                                            gotoNext(index);
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: Dimensions.height20,
                                            left: Dimensions.height10,
                                            right: Dimensions.height10),
                                        padding: EdgeInsets.all(
                                            Dimensions.height15 + 4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius
                                                .circular(
                                                Dimensions.height10),
                                            border: Border.all(
                                                color: color),
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey
                                                  .withOpacity(0.8),
                                                  offset: const Offset(
                                                      1, 1),
                                                  blurRadius: 5),
                                              // BoxShadow(color: Color(0xFFD6DFE6FF),offset: Offset(-1,0),spreadRadius: 1)
                                            ]
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(child: TextWidget(
                                              text: option.text!,
                                              textColor: Colors.black,
                                              fontSize: Dimensions
                                                  .height15 + 2,)),
                                            getIconForOptions(
                                                option, model)
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    );
                  });
            },
          )),
    );
  }

  void gotoNext(int questionNumber) {
    // assetsAudioPlayer.stop();
    if (questionNumber < questionList.length) {
      pageController.nextPage(duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInExpo);
    }
    if (pageController.page!.toInt() == questionList.length - 1) {
      context.read<PointsProvider>().setResult(questionList.length, score);
      context.read<PointsProvider>().setObtainScore();
      context.read<PointsProvider>().changeTotalScore();
      var newPoints = context.read<PointsProvider>().obtainScore;
      var oldPoints = context.read<UserInformationProvider>().userModel!.points;
      context.read<PointsProvider>().checkOldScore(newPoints, oldPoints!);
      // assetsAudioPlayer.stop();
      // assetsAudioPlayer.dispose();
      // _timer.cancel();
      Future.delayed(const Duration(milliseconds: 200),(){
        context.read<MCQsDbProvider>().changeState(false);
        context.read<MCQsDbProvider>().resetQuestionsList();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return QuizResultScreen(score: score,
                  correct: correctAnswers,
                  incorrect: incorrectAnswers,
                  total: questionList.length,
                  attempted: attemptedQuestion,
                  questions: questionList);
            },));
      });
    }
  }

  Color getColorsForOptions(Options option, QuestionModel questionModel) {
    final isSelected = option == questionModel.selectedOption;
    if (questionModel.isLock!) {
      if (isSelected) {
        return option.isCorrect! ? Colors.green : Colors.red;
      } else if (option.isCorrect!) {
        return Colors.green;
      }
    }
    return Colors.white;
  }

  Widget getIconForOptions(Options option, QuestionModel questionModel) {
    final isSelected = option == questionModel.selectedOption;
    if (questionModel.isLock!) {
      if (isSelected) {
        return option.isCorrect!
            ? const Icon(
          Icons.check_circle,
          color: Colors.green,
        )
            : const Icon(
          Icons.cancel,
          color: Colors.red,
        );
      } else if (option.isCorrect!) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }
    }
    return const Icon(Icons.circle_outlined);
  }

// FontWeight getFontWeight(Options option, QuestionModel questionModel) {
//   final isSelected = option == questionModel.selectedOption;
//   if (questionModel.isLock!) {
//     if (isSelected) {
//       return option.isCorrect! ? FontWeight.bold : FontWeight.normal;
//     } else if (option.isCorrect!) {
//       return FontWeight.bold;
//     }
//   }
//   return FontWeight.normal;
// }

// void countCorrectAndIncorrectAnswer(Options option, QuestionModel questionModel){
//   final isSelected = option == questionModel.selectedOption;
//   if (questionModel.isLock!) {
//     if(isSelected){
//       if(option.isCorrect!){
//         setState(() {
//           correctAnswers++;
//         });
//       }else{
//         setState(() {
//           incorrectAnswers++;
//         });
//       }
//     }
//   }
// }
}
