import 'package:flutter/material.dart';
import 'package:start_project/grad/signInForBrand.dart';
import 'package:start_project/grad/signUpForBrand.dart';
import 'package:start_project/grad/sign_in.dart';
import 'package:start_project/grad/sign_up.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/welcom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   height: 400,
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 0,
            //     horizontal: 40.0,
            //   ),
            //   child: Center(
            //     child: RichText(
            //       textAlign: TextAlign.center,
            //       text: const TextSpan(
            //         children: [
            //           TextSpan(
            //             text: 'Welcome',
            //             style: TextStyle(
            //               fontSize: 45.0,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.black, // تغيير لون الكلمة إلى الأسود
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Image.asset(
                'images/—Pngtree—online shop digital shopping logo_7265985.png'),
            const Text(
              'SHOPY',
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // إضافة مسافة بين بداية مساحة الأزرار وجوانب الشاشة
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Login',
                          onTap: SignInScreen(),
                          color: Color(0xFF684399),
                          textColor: Colors.white,
                          buttonSize: 0.9, // تعديل حجم الزر بنسبة 10٪ أصغر
                        ),
                      ),
                      SizedBox(width: 8), // إضافة مسافة بين الأزرار
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Sign up',
                          onTap: SignUpScreen(),
                          color: Color(0xFF684399),
                          textColor: Colors.white,
                          buttonSize: 0.9,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Login as brand',
                          onTap: SignInForBrand(),
                          color: Color(0xFF684399),
                          textColor: Colors.white,
                          buttonSize: 0.9,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Sign up as brand',
                          onTap: SignUpForBrand(),
                          color: Color(0xFF684399),
                          textColor: Colors.white,
                          buttonSize: 0.9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
