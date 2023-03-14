import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pak_mega_mcqs/common/model/questions_model.dart';
import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/common/widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/common/widgets/mcqs_question_widget.dart';
import 'package:provider/provider.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';


class MCQsScreen extends StatelessWidget {
  const MCQsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<MCQsDbProvider>().resetQuestionsList();
        Navigator.of(context).pop();
        return true;
      },
      child: CustomScreenWidget(
        title: "MCQS",
        onPress: () {
          context.read<MCQsDbProvider>().resetQuestionsList();
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.only(top: Dimensions.height20 + 2),
          child: AnimationLimiter(
            child: Consumer<MCQsDbProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                    itemCount: value.questionList.length,
                    itemBuilder: (context, index) {
                      QuestionModel questionModel = value.questionList[index];
                      return MCQsQuestionWidget(
                        questionModel: questionModel,
                        index: index,
                        fromWhich: "mcq",
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}

