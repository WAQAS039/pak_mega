import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_mega_mcqs/common/routes/routes_helper.dart';
import 'package:pak_mega_mcqs/common/utils/app_colors.dart';
import 'package:pak_mega_mcqs/screens/init_setup/init_setup_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InitSetUp extends StatefulWidget {
  const InitSetUp({Key? key}) : super(key: key);

  @override
  State<InitSetUp> createState() => _InitSetUpState();
}

class _InitSetUpState extends State<InitSetUp> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<InitSetUpProvider>().getMCQsAndTestData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<InitSetUpProvider>(
        builder: (context, setup, child) {
          if (setup.gotAll) {
            Future.delayed(Duration.zero,()=>Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.loginPage, (route) => false));
          } else {
            // in case of error
          }
          return setup.isError ? Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/internet.png',height: 150.h,),
                SizedBox(height: 18.h,),
                Text("No Internet Connection",style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'aileron',
                    fontWeight: FontWeight.w200,

                ),),
                Container(
                  margin: EdgeInsets.only(
                      bottom: 30.h, left: 15.w, right: 15.w, top: 20.h),
                  child: Text(
                    "Please make sure your are connected to Internet To Setup App for First Use",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: "aileron",
                        fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<InitSetUpProvider>().getMCQsAndTestData(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.h),
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.mainColor)),
                    child: Text('Refresh',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: "aileron",
                            fontWeight: FontWeight.w500,
                        )),
                  ),
                )
              ],
            ),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 300.h),
                child: const SpinKitFadingCube(
                  color: AppColors.mainColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: 30.h, left: 15.w, right: 15.w, top: 20.h),
                child: Text(
                  'Please Wait While We Setup App For First Use',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: "aileron",
                      fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
