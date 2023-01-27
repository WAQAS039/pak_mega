import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/utils/dimensions.dart';


class LoginPageButtonContainer extends StatelessWidget {
  final String name;
  final String? icon;
  final Color containerColor;
  final VoidCallback onTap;
  const LoginPageButtonContainer({Key? key,required this.name,required this.containerColor,this.icon,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: Dimensions.height50+10,
          margin: EdgeInsets.only(left: Dimensions.height50+5,right: Dimensions.height50+5),
          decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(Dimensions.height30)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon == null ? const SizedBox.shrink() : Image.asset("assets/icons/login_page_icons/$icon.png",
                  height: icon == "FACEBOOK" ? Dimensions.height30:Dimensions.height20,width: Dimensions.height20,),
                SizedBox(
                  width: Dimensions.height20,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins"
                  ),
                )
              ],
            ),
          )),
    );
  }
}
