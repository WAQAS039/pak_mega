import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pak_mega_mcqs/common/database/offline_database.dart';
import 'package:pak_mega_mcqs/common/model/bookmark_model.dart';
import 'package:pak_mega_mcqs/common/model/options_model.dart';
import 'package:pak_mega_mcqs/common/model/questions_model.dart';
import 'package:pak_mega_mcqs/common/providers/mcqsdb_provider.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';
import 'package:pak_mega_mcqs/common/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';



class MCQsQuestionWidget extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  final String fromWhich;
  const MCQsQuestionWidget({Key? key, required this.questionModel, required this.index,required this.fromWhich}) : super(key: key);

  @override
  State<MCQsQuestionWidget> createState() => _MCQsQuestionWidgetState();
}

class _MCQsQuestionWidgetState extends State<MCQsQuestionWidget> {
  // Eye Work
  bool isEyeClick = false;
  Color eyeColor = Colors.black;
  String? eyeImage = 'assets/icons/mcqs_page_icons/notShow.png';

  // Share Work
  bool isShare = false;
  Color shareColor = Colors.black;
  String? shareImage = 'assets/icons/mcqs_page_icons/notShared.png';

  // BookMark work
  IconData bookmarkIcon = Icons.bookmark_border_outlined;
  bool isBookmark = false;
  Color bookmarkColor = Colors.black;
  String? bookmarkImage = 'assets/icons/mcqs_page_icons/notBookmark.png';

  // select a option
  bool isLock = false;



  @override
  void initState() {
    super.initState();
    checkIsBookmarked(widget.questionModel);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height10+3,left: Dimensions.height10,right: Dimensions.height10,bottom: Dimensions.height10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.height10),
        boxShadow: const[
          BoxShadow(color: Colors.grey, offset: Offset.zero, blurRadius: 1,spreadRadius: 1)
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height30,left: Dimensions.height15,right: Dimensions.height15,bottom: Dimensions.height30),
            decoration: BoxDecoration(
              color: AppColors.mainColor2,
              borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.height10), topLeft: Radius.circular(Dimensions.height10))
            ),
            child: TextWidget(text: widget.questionModel.questionText!,fontSize: Dimensions.height20,),
          ),
          SizedBox(height: Dimensions.height30,),
          Container(
            margin: EdgeInsets.only(left: Dimensions.height15),
            child: ListView.builder(
                itemCount: widget.questionModel.options!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                  List<Options> optionsList = widget.questionModel.options!;
                  Options options = optionsList[index];
                  Color? correctOptionColor;
                  FontWeight? fontWeight;
                  // correctOptionColor = getColorsForOptions(options);
                  // fontWeight = getFontWeight(options,widget.questionModel);
                  fontWeight = getFontWeight(options);
                  correctOptionColor = getColorsForOptions(options);
                  return InkWell(
                    onTap: (){
                      setState(() {
                        widget.questionModel.isLock = true;
                        widget.questionModel.selectedOption = options;
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height15, right: Dimensions.height10),
                        child: Text(options.text!, style: TextStyle(fontSize: Dimensions.height20,fontWeight: fontWeight, color: correctOptionColor),textAlign: TextAlign.justify,)),
                  );
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: Dimensions.height10,left: Dimensions.height40,right: Dimensions.height40,bottom: Dimensions.height20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      if(!isEyeClick){
                        isEyeClick = true;
                        setState(() {
                          eyeImage = 'assets/icons/mcqs_page_icons/showed.png';
                        });
                      }else{
                        isEyeClick = false;
                        setState(() {
                          eyeImage = 'assets/icons/mcqs_page_icons/notShow.png';
                        });
                      }
                    },
                    child: Image.asset(eyeImage!,height: Dimensions.height20+7  ,width: Dimensions.height20+7.0,)),
                InkWell(
                    onTap: () async{
                      if(!isShare){
                        List<Options> optionsList = widget.questionModel.options!;
                        String answer = "";
                        for(int i=0;i<optionsList.length;i++){
                          if(optionsList[i].isCorrect!){
                            answer = optionsList[i].text!;
                            break;
                          }
                        }
                        await Share.share('${widget.questionModel.questionText}\n${optionsList[0].text}\n${optionsList[1].text}\n${optionsList[2].text}\n${optionsList[3].text}\nanswer: $answer'
                        );
                        isShare = true;
                        setState(() {
                          // shareColor = AppColors.mainColor2;
                          shareImage = 'assets/icons/mcqs_page_icons/shared.png';
                        });
                      }else{
                        isShare = false;
                        setState(() {
                          shareImage = 'assets/icons/mcqs_page_icons/notShared.png';
                          // shareColor = Colors.black;
                        });
                      }
                    },
                    child: Image.asset(shareImage!,height: Dimensions.height20,width: Dimensions.height20,)),
                InkWell(
                    onTap: () async{
                      if(!isBookmark){
                        // int result = await OfflineDatabase().addBookmark(widget.index, widget.questionModel.questionText!, widget.questionModel.options.toString());
                        BookmarkModel model = BookmarkModel(position: widget.index, question: widget.questionModel.questionText, options: widget.questionModel.options);
                        int result = await OfflineDatabase().addBookmark(model);
                        if(result == 1){
                          Fluttertoast.showToast(msg: 'added');
                        }
                        isBookmark = true;
                        setState(() {
                          bookmarkImage = 'assets/icons/mcqs_page_icons/bookmarked.png';
                        });
                      }else{
                        if(widget.fromWhich == "book"){
                          var bookmarks = context.read<MCQsDbProvider>().bookmarkList;
                          if(bookmarks.isNotEmpty){
                            context.read<MCQsDbProvider>().deleteBookmark(widget.index);
                            deleteBookmark(widget.questionModel.questionText!);
                          }
                        }else{
                          isBookmark = false;
                          int result = await OfflineDatabase().deleteBookmark(widget.questionModel.questionText!);
                          if(result == 1){
                            Fluttertoast.showToast(msg: 'deleted');
                          }
                          setState(() {
                            bookmarkImage = 'assets/icons/mcqs_page_icons/notBookmark.png';
                          });
                        }
                      }
                    },
                    child: Image.asset(bookmarkImage!,height: Dimensions.height20,width: Dimensions.height20,)),
              ],
            ),
          )
        ],
      ),
    );
  }


  Color getColorsForOptions(Options option) {
    if(isEyeClick){
      if(option.isCorrect!) {
        return AppColors.mainColor2;
      }
    }
    return Colors.black;
  }

  FontWeight getFontWeight(Options option){
    if(isEyeClick){
      if(option.isCorrect!) {
        return FontWeight.bold;
      }
    }
    return FontWeight.normal;
  }

  void checkIsBookmarked(QuestionModel questions) async{
    List bookmarkList = <BookmarkModel>[];
    bookmarkList = await OfflineDatabase().getBookmark();
    BookmarkModel? bookmarkModel;
    if(bookmarkList.isNotEmpty){
      for(int i = 0;i<bookmarkList.length;i++){
        bookmarkModel = bookmarkList[i];
        // bookmarkModel.position == widget.index &&
        if(questions.questionText == bookmarkModel?.question){
          isBookmark = true;
          if(isBookmark){
            setState(() {
              bookmarkImage = 'assets/icons/mcqs_page_icons/bookmarked.png';
            });
          }
        }
      }
    }
  }

  Future<void> deleteBookmark(String questionText) async {
    List bookmarkList = <BookmarkModel>[];
    bookmarkList = await OfflineDatabase().getBookmark();
    BookmarkModel? bookmarkModel;
    if(bookmarkList.isNotEmpty){
      for(int i = 0;i<bookmarkList.length;i++){
        bookmarkModel = bookmarkList[i];
        if(questionText == bookmarkModel?.question){
          int result = await OfflineDatabase().deleteBookmark(widget.questionModel.questionText!);
          if(result == 1){
            Fluttertoast.showToast(msg: 'deleted');
          }
          isBookmark = false;
          if(isBookmark){
            setState(() {
              bookmarkImage = 'assets/icons/mcqs_page_icons/notBookmark.png';
            });
          }
        }
      }
    }
  }
}
