import 'dart:ui';
import 'package:cineluxe/screens/login_screen/logic/login_states/login_states.dart';
import 'package:cineluxe/widgets/choose_locale.dart';
import 'package:cineluxe/widgets/customized_text_form_field.dart';
import 'package:cineluxe/widgets/customized_elevated_button.dart';
import 'package:cineluxe/utils/app_assets.dart';
import 'package:cineluxe/utils/app_colors.dart';
import 'package:cineluxe/utils/app_routes.dart';
import 'package:cineluxe/utils/app_sizes.dart';
import 'package:cineluxe/utils/app_styles.dart';
import 'package:cineluxe/screens/login_screen/logic/login_functions.dart';
import 'package:cineluxe/screens/login_screen/logic/login_view_model.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widgets/alert_dialouge_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: SingleChildScrollView(
                child: BlocConsumer<LoginViewModel, LoginStates>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.homeScreen,
                      );
                    }

                    if (state is LoginError) {
                      AppDialogs.showMessageDialog(
                        context: context,
                        message: state.message.tr(), text: 'login_failed'.tr(),
                      );
                    }
                      if (state is GoogleSuccess) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.homeScreen,
                        );
                      }

                      if (state is GoogleError) {
                        AppDialogs.showMessageDialog(
                          context: context,
                          message: state.message.tr(),
                          text: 'login_failed'.tr(),
                        );
                      }
                  },
                  builder: (context, state) {
                    final isLoading = state is LoginLoading||state is GoogleLoading;

                    return AbsorbPointer(
                      absorbing: isLoading,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.07),
                            Image.asset(AppAssets.playLogo),
                            SizedBox(height: height * 0.07),

                            CustomizedTextFormField(
                              controller: emailController,
                              hintText: 'email'.tr(),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Image.asset(
                                AppAssets.emailLogo,
                                width: width * 0.02,
                              ),
                              onValidate: (email) {
                                return LoginFunctions.emailValidation(
                                  email: email,
                                );
                              },
                            ),

                            SizedBox(height: height * 0.03),

                            CustomizedTextFormField(
                              controller: passwordController,
                              hintText: 'password'.tr(),
                              textInputAction: TextInputAction.done,
                              obscureText: isHidden,
                              prefixIcon: Image.asset(
                                AppAssets.passwordLogo,
                                width: width * 0.02,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHidden = !isHidden;
                                  });
                                },
                                icon: Icon(
                                  isHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              onValidate: (password) {
                                return LoginFunctions.passwordValidation(
                                  password: password,
                                );
                              },
                            ),

                            SizedBox(height: height * 0.02),

                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.forgetPasswordScreen,
                                  );
                                },
                                child: Text(
                                  'forget_password'.tr(),
                                  style: AppStyles.yellow14W400,
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.04),

                            SizedBox(
                              width: double.infinity,
                              child: CustomizedElevatedButton(
                                isLoading: isLoading,
                                onPressed: () {
                                  if (formKey.currentState?.validate() ==
                                      true) {
                                    context
                                        .read<LoginViewModel>()
                                        .login(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  }
                                },
                                child: Text(
                                  'login'.tr(),
                                  style: AppStyles.black20W400,
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'do_not_have_an_account'.tr(),
                                  style: AppStyles.white14W400,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.registerScreen,
                                    );
                                  },
                                  child: Text(
                                    'create_one'.tr(),
                                    style: AppStyles.yellow14W900,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.03),

                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.yellowColor,
                                    indent: width * 0.18,
                                    endIndent: width * 0.03,
                                  ),
                                ),
                                Text(
                                  'or'.tr(),
                                  style: AppStyles.yellow15W400,
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.yellowColor,
                                    indent: width * 0.03,
                                    endIndent: width * 0.18,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.03),

                            CustomizedElevatedButton(
                              isLoading: isLoading,
                              onPressed: () {
                                context.read<LoginViewModel>().googleLogin();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: width * 0.03,
                                children: [
                                  Image.asset(AppAssets.googleLogo),
                                  Text(
                                    'google_login'.tr(),
                                    style: AppStyles.black16W400,
                                  ),
                                ],
                              ),
                            ),

                            ChooseLocale(
                              onTap1: () {
                                context.setLocale(const Locale('en'));
                              },
                              onTap2: () {
                                context.setLocale(const Locale('ar'));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          BlocBuilder<LoginViewModel, LoginStates>(
            builder: (context, state) {
              if (state is! LoginLoading) {
                return const SizedBox.shrink();
              }

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: 1,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.yellowColor,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}