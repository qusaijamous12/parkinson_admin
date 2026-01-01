import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parknson_admin/shared/color_manager.dart';
import '../../controller/login_controller.dart';
import '../../shared/app_styles.dart';
import '../../shared/utils.dart';
import '../../shared/widget/ResponsiveWidget.dart';
import '../../shared/widget/my_button.dart';


class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _loginController = Get.find<LoginController>(tag: 'login_controller');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                  child: Container(
                    height: height,
                    color: ColorManager.kPrimary,
                    child: Center(
                      child: Text(
                        'AdminDasboard',
                        style: ralewayStyle.copyWith(
                          fontSize: 48.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                  horizontal:
                      ResponsiveWidget.isSmallScreen(context)
                          ? height * 0.032
                          : height * 0.12,
                ),
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Let’s',
                              style: ralewayStyle.copyWith(
                                fontSize: 25.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' Sign In 👇',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Hey, Enter your details to get sign in \nto your account.',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: height * 0.064),

                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Email',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: ColorManager.kPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: ColorManager.kPrimary,
                            fontSize: 12.0,
                          ),

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email_outlined),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Email',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorManager.kPrimary.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.014),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Password',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            color: ColorManager.kPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        height: 50.0,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        child: TextFormField(
                          controller: _passwordController,

                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          obscureText: true,

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:const Icon(Icons.lock_open),
                            contentPadding: const EdgeInsets.only(top: 16.0),
                            hintText: 'Enter Password',
                            hintStyle: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorManager.kPrimary.withOpacity(0.5),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      SizedBox(height: height * 0.05),
                      MyButton(
                        title: 'Sign In',
                        onTap: ()async{
                          if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                            await _loginController.adminLogin(email: _emailController.text, password: _passwordController.text);
                          }else{
                            Utils.myToast(title: 'Email And Password Are Required');
                          }
                        },
                        btnColor: ColorManager.kPrimary,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
