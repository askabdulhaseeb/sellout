import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sellout_team/src/blocs/auth/auth_cubit/auth_cubit.dart';
import 'package:sellout_team/src/blocs/auth/auth_states/auth_states.dart';
import 'package:sellout_team/src/constants/constants.dart';
import 'package:sellout_team/src/views/auth/forgotpassword_screen.dart';
import 'package:sellout_team/src/views/auth/register_screen.dart';
import 'package:sellout_team/src/views/components/components.dart';
import 'package:sellout_team/src/views/widgets/auth/auth_text.dart';
import 'package:sellout_team/src/views/widgets/auth/field_label.dart';
import 'package:sellout_team/src/views/widgets/auth/social_media_login_button.dart';
import 'package:sellout_team/src/views/widgets/circular_indicator/circular_indicator.dart';
import 'package:sellout_team/src/views/widgets/auth/default_button_widget.dart';
import 'package:sellout_team/src/views/widgets/auth/text_form_field_widget.dart';
import 'package:sellout_team/src/views/widgets/indicator/show_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginComponents {
// the logo section in login screen.
  static Widget logo(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(K_ICON, width: 120, height: 120),
    );
  }
  // the login card.

  static Widget loginField({
    required BuildContext context,
    required AuthCubit cubit,
    required AuthStates state,
    required formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(
              text: ' Email address',
            ),
            TextFormFieldWidget(
              controller: emailController,
              suffixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 8),
            FieldLabel(text: ' Password'),
            TextFormFieldWidget(
              controller: passwordController,
              isPassword: cubit.isObsecure,
              suffixIcon: IconButton(
                onPressed: () {
                  cubit.onChanged();
                },
                icon: Icon(
                  cubit.isObsecure
                      ? Icons.remove_red_eye
                      : Icons.visibility_off,
                  size: 20,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
            Components.kDivider,
            state is AuthLoginLoadingState
                ? CircularIndicator()
                : DefaultButtonWidget(
                    text: 'Log in',
                    isTextWeightThick: false,
                    isSmallerHeight: true,
                    function: () {
                      if (formKey.currentState!.validate()) {
                        cubit.login(
                          email: emailController.text,
                          passwords: passwordController.text,
                        );
                      }
                    },
                    color: kPrimaryColor,
                  ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => Components.navigateTo(context, ForgotPassword()),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -1))],
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // last section the social media buttons with the register text.

  static Widget buttonsSection(
      BuildContext context, AuthCubit cubit, AuthStates state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Components.kDivider,
        Text('or'.toUpperCase(), style: Components.kBodyOne(context)),
        Components.kDivider,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                showLoadingDislog(context);
                cubit.loginWithFacebook();
              },
              child: const SocialMediaLoginButton(
                text: 'Facebook',
                icon: Icon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showLoadingDislog(context);
                cubit.signInWithApple();
              },
              child: const SocialMediaLoginButton(
                text: 'Apple',
                icon: Icon(
                  FontAwesomeIcons.apple,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showLoadingDislog(context);
                cubit.loginWithGoogle();
              },
              child: const SocialMediaLoginButton(
                text: 'Google',
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        AuthText(
          sentence: 'Don\'t have an account? ',
          text: 'Register.',
          function: () {
            Components.navigateTo(context, Register());
          },
        ),
        const SizedBox(height: 6),
        // const SizedBox(
        //   height: 10,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     String url =
        //         "https://app.termly.io/document/terms-of-use-for-ios-app/0ba486f6-86c7-48c7-a116-f8c5aa4017cc";
        //     _launchURL(url);
        //   },
        //   child: const Text(
        //     'By registrating you accept Customer Agreement conditions and Privacy Policy and accept all risks inherent',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontSize: 12,
        //       decoration: TextDecoration.underline,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  static _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
