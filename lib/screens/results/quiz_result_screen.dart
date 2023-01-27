import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pak_mega_mcqs/model/questions_model.dart';
import 'package:pak_mega_mcqs/providers/coins_provider.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/providers/points_provider.dart';
import 'package:pak_mega_mcqs/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/utils/app_colors.dart';
import 'package:pak_mega_mcqs/widgets/circular_icon_widget.dart';
import 'package:pak_mega_mcqs/widgets/icon_text_widget.dart';
import 'package:pak_mega_mcqs/widgets/text_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/dimensions.dart';
import 'dart:io';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int correct;
  final int incorrect;
  final int attempted;
  final int total;
  final List<QuestionModel> questions;
  const QuizResultScreen({Key? key,
    required this.score,
    required this.correct,
    required this.incorrect,
    required this.attempted,
    required this.total,
    required this.questions}) : super(key: key);

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  File? _file = null;

  @override
  void initState() {
    getImagePath();
    context.read<CoinsProvider>().increaseCoins(context.read<PointsProvider>().result);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
          body: Stack(
            children: [
              Container(),
              Container(
                height: Dimensions.height360 + Dimensions.height50,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Dimensions.height135-20),
                      bottomLeft: Radius.circular(
                          Dimensions.height135-20)),
                ),
              ),
              Positioned(
                top: Dimensions.height50,
                left: Dimensions.height15 + 1,
                child: _file != null ? Image.file(_file!,height: 100,width: 100,): const SizedBox.shrink(),) ,
              Positioned(
                  top: Dimensions.height50,
                  left: Dimensions.height15 + 1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                top: Dimensions.height98-Dimensions.height15,
                left: 0,
                right: 0,
                child: CircularPercentIndicator(
                  radius: Dimensions.height98+5,
                  lineWidth: Dimensions.height25,
                  animationDuration: 2000,
                  percent: widget.score / widget.total * 1.0,
                  animation: true,
                  progressColor: AppColors.circleColor,
                  center: CircleAvatar(
                    backgroundColor: AppColors.mainColor,
                    radius: Dimensions.height80,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: Dimensions.height50+10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<PointsProvider>(
                            builder: (context, value, child) {
                              return TextWidget(
                                text: value.result.toString(),
                                textColor: AppColors.mainColor,
                                fontSize: Dimensions.height25,
                              );
                            },
                          ),
                          const TextWidget(
                              text: 'Your Score', textColor: AppColors.mainColor)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: Dimensions.height360-Dimensions.height30,
                  child: Container(
                    margin: EdgeInsets.only(left: Dimensions.height15,right: Dimensions.height15),
                    padding: EdgeInsets.all(Dimensions.height10),
                    height: Dimensions.height200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.height10),
                        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    child: Container(
                      margin: EdgeInsets.all(Dimensions.height15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconTextWidget(circleColor: AppColors.mainColor,textColor: AppColors.mainColor,result: '${((widget.attempted/widget.total)*100).toInt()}%' , title: 'Completion'),
                              IconTextWidget(circleColor: AppColors.mainColor,textColor: AppColors.mainColor, result: widget.total.toInt().toString(), title: 'Total Question')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconTextWidget(circleColor: Colors.green, textColor: Colors.green,result: widget.correct.toString(), title: 'Correct'),
                              IconTextWidget(circleColor: Colors.red, textColor: Colors.red,result: widget.incorrect.toString(), title: 'Wrong               ')
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                left: 0,
                right: 0,
                bottom: Dimensions.height15,
                child: Container(
                  height: Dimensions.height80,
                  margin: EdgeInsets.only(
                      left: Dimensions.height30,
                      right: Dimensions.height30,
                      top: Dimensions.height80),
                  padding: EdgeInsets.only(left: Dimensions.height20),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius:
                      BorderRadius.circular(Dimensions.height10)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/achive.png',
                        height: Dimensions.height50,
                        width: Dimensions.height50,
                      ),
                      Expanded(
                        child: Consumer<PointsProvider>(
                          builder: (context, value, child) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.height10,
                                  right: Dimensions.height10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height30)),
                              child: LinearPercentIndicator(
                                // animation: true,
                                lineHeight: 20.0,
                                animationDuration: 2500,
                                padding: const EdgeInsets.all(0),
                                percent: value.obtainScore/value.totalScore,
                                center: Text("${value.obtainScore}/${value.totalScore}"),
                                barRadius: Radius.circular(Dimensions.height30),
                                progressColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(left: Dimensions.height10,right: Dimensions.height10,bottom: Dimensions.height10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularIconWidget(
                    onPress: (){
                      // context.read<QuestionListProvider>().getQuestionList(questions: questions);
                      context.read<MCQsDbProvider>().addQuestionList(questions: widget.questions);
                      Navigator.of(context).pushReplacementNamed(RouteHelper.quizPage);
                    },
                    circleColor: AppColors.greyBlue,
                    title: "Play Again",
                    icon: Icons.history,),
                  Consumer<PointsProvider>(
                    builder: (context, value, child) {
                      return CircularIconWidget(
                        onPress: () async{
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                            Future.delayed(const Duration(milliseconds: 10),(){
                              screenshotController.captureFromWidget(shareWidget(context,value)).then((value) {
                                saveAndShare(value);
                                Navigator.of(context).pop();
                              });
                            });
                            return const AlertDialog(
                              title: Center(child: SpinKitCircle(color: Colors.blue,),),);
                          },);
                        },
                        circleColor: AppColors.darkGrey,
                        title: "Share",
                        icon: Icons.share,);
                    },
                  ),
                ],),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularIconWidget(
                    onPress: (){
                      context.read<MCQsDbProvider>().addQuestionList(questions: widget.questions);
                      context.read<MCQsDbProvider>().changeState(true);
                      Navigator.of(context).pushNamed(RouteHelper.quizPage,arguments: "review");
                    },
                    circleColor: AppColors.greyBlue,
                    title: "Review Answer",
                    icon: Icons.remove_red_eye_outlined,),
                  CircularIconWidget(
                    onPress: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.mainScreen, (route) => false);
                    },
                    circleColor: AppColors.blue,
                    title: "Home",
                    icon: CupertinoIcons.home,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget shareWidget(BuildContext context, PointsProvider value){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(),
            Container(
              height: Dimensions.height360 + Dimensions.height50,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Dimensions.height135-20),
                    bottomLeft: Radius.circular(
                        Dimensions.height135-20)),
              ),
            ),
            Positioned(
                top: Dimensions.height50,
                left: Dimensions.height15 + 1,
                child: TextWidget(text: value.attemptCategoryName,)),
            Positioned(
              top: Dimensions.height98-Dimensions.height15,
              left: 0,
              right: 0,
              child: CircularPercentIndicator(
                radius: Dimensions.height98+5,
                lineWidth: Dimensions.height25,
                animationDuration: 2000,
                percent: widget.score / widget.total * 1.0,
                animation: true,
                progressColor: AppColors.circleColor,
                center: CircleAvatar(
                  backgroundColor: AppColors.mainColor,
                  radius: Dimensions.height80,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: Dimensions.height50+10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: value.result.toString(),
                          textColor: AppColors.mainColor,
                          fontSize: Dimensions.height25,
                        ),
                        const TextWidget(
                            text: 'Your Score', textColor: AppColors.mainColor)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: Dimensions.height360-Dimensions.height30,
                child: Container(
                  margin: EdgeInsets.only(left: Dimensions.height15,right: Dimensions.height15),
                  padding: EdgeInsets.all(Dimensions.height10),
                  height: Dimensions.height200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.height10),
                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                  child: Container(
                    margin: EdgeInsets.all(Dimensions.height15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconTextWidget(circleColor: AppColors.mainColor,textColor: AppColors.mainColor,result: '${((widget.attempted/widget.total)*100).toInt()}%' , title: 'Completion'),
                            IconTextWidget(circleColor: AppColors.mainColor,textColor: AppColors.mainColor, result: widget.total.toInt().toString(), title: 'Total Question')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconTextWidget(circleColor: Colors.green, textColor: Colors.green,result: widget.correct.toString(), title: 'Correct'),
                            IconTextWidget(circleColor: Colors.red, textColor: Colors.red,result: widget.incorrect.toString(), title: 'Wrong               ')
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
              left: 0,
              right: 0,
              bottom: Dimensions.height170,
              child: Container(
                height: Dimensions.height80,
                margin: EdgeInsets.only(
                    left: Dimensions.height30,
                    right: Dimensions.height30,
                    top: Dimensions.height80),
                padding: EdgeInsets.only(left: Dimensions.height20),
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius:
                    BorderRadius.circular(Dimensions.height10)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/achive.png',
                      height: Dimensions.height50,
                      width: Dimensions.height50,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Dimensions.height10,
                            right: Dimensions.height10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(
                                Dimensions.height30)),
                        child: LinearPercentIndicator(
                          // animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          padding: const EdgeInsets.all(0),
                          percent: value.obtainScore/value.totalScore,
                          center: Text("${value.obtainScore}/${value.totalScore}"),
                          barRadius: Radius.circular(Dimensions.height30),
                          progressColor: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(Dimensions.height10),
          child: Row(
            children: [
              const Icon(Icons.send,color: AppColors.mainColor,),
              SizedBox(width: Dimensions.height10,),
              const TextWidget(text: "PakMegaMCQs",textColor: AppColors.mainColor,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAndShare(Uint8List image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final newFolder = Directory('$path/screen_shots');
    if (!await newFolder.exists()) {
      await newFolder.create(recursive: true);
    }
    final imageFile = File('$path/screen_shots/quizResult.png');
    if(!await imageFile.exists()){
      await imageFile.create();
      await Share.shareFiles([imageFile.path]);
    }
  }


  Future<void> getImagePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File('${directory.path}/screen_shots/quizResul.png');
    if(await imageFile.exists()){
      imageFile.readAsBytesSync();
      setState(() {
        _file = imageFile;
      });
      print("reading ${imageFile.path}");
    }else{
      print("notExist");
    }
  }
}