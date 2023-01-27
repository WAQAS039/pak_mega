import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/model/bookmark_model.dart';
import 'package:pak_mega_mcqs/model/questions_model.dart';
import 'package:pak_mega_mcqs/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/widgets/bookmarkWidget.dart';
import 'package:pak_mega_mcqs/widgets/custom_screen_widget.dart';
import 'package:pak_mega_mcqs/widgets/mcqs_question_widget.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScreenWidget(
        title: "Bookmarks",
        onPress: (){
          context.read<MCQsDbProvider>().resetBookmarkList();
          Navigator.of(context).pop();
        },
        child: Consumer<MCQsDbProvider>(
          builder: (context, value, child) {
            return value.bookmarkList.isNotEmpty ? ListView.builder(
              itemCount: value.bookmarkList.length,
              itemBuilder: (context, index) {
                BookmarkModel model = value.bookmarkList[index];
                QuestionModel questionModel = QuestionModel(questionText: model.question, options: model.options);
                return BookMarkWidget(questionModel: questionModel, index: index,fromWhich: "book",);
              },) : const Center(child: Text("No Bookmark Added Yet"),);
          },
        ));
  }
}
