import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/model/categories_model.dart';
import 'package:pak_mega_mcqs/Widgets/text_widget.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';

class CategoriesContainerWidget extends StatelessWidget {
  final CategoriesModel categoriesModel;
  const CategoriesContainerWidget({Key? key,required this.categoriesModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2,bottom: 5,right:7,top: 2),
      padding: EdgeInsets.only(top: Dimensions.height20,bottom: 2),
      width: Dimensions.height110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.height20),
          color: Colors.white,
          boxShadow: const[
            BoxShadow(
                color: Colors.grey, offset: Offset(0.5,0.5), blurRadius: 2,)
          ]
      ),
      child: Column(
        children: [
          Image.asset(categoriesModel.categoryIcon!,height: Dimensions.height50+5,width: Dimensions.height50+5,),
          const SizedBox(height: 8,),
          Expanded(child: TextWidget(text: categoriesModel.categoryName!, fontSize: Dimensions.height15-2,textColor: Colors.black,textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
}
