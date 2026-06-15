import 'dart:ui';

import 'package:cineluxe/screens/register_screen/logic/register_functions.dart';
import 'package:cineluxe/screens/register_screen/logic/register_states/register_states.dart';
import 'package:cineluxe/screens/register_screen/logic/register_view_model.dart';
import 'package:cineluxe/utils/app_assets.dart';
import 'package:cineluxe/utils/app_colors.dart';
import 'package:cineluxe/utils/app_routes.dart';
import 'package:cineluxe/utils/app_sizes.dart';
import 'package:cineluxe/utils/app_styles.dart';
import 'package:cineluxe/utils/app_resources.dart';
import 'package:cineluxe/widgets/choose_locale.dart';
import 'package:cineluxe/widgets/customized_text_form_field.dart';
import 'package:cineluxe/widgets/customized_elevated_button.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widgets/alert_dialouge_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isHidden1 = true;
  bool isHidden2 = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedAvatar = 'avatar_1';

  final PageController controller = PageController(
    viewportFraction: 0.33,
    initialPage: 1000,
  );

  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,

      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        title: Text('register'.tr(), style: AppStyles.yellow16W400),
        foregroundColor: AppColors.yellowColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: context.locale.languageCode == 'en'
              ? Image.asset(AppAssets.arrowBack)
              : const Icon(Icons.arrow_back_outlined),
        ),
      ),

      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.15,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index){
                    final avatars = AppResources.avatarList;
                    final realIndex = index % avatars.length;
                    selectedAvatar = 'avatar${realIndex + 1}';
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final avatars = AppResources.avatarList;
                    final realIndex = index % avatars.length;

                    final diff = (controller.hasClients
                        ? (controller.page ?? controller.initialPage) - index
                        : 0)
                        .abs();

                    double scale = (1 - (diff * 0.3)).clamp(0.7, 1.0);

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.1,
                              child: avatars[realIndex],
                            ),
                            if ((currentPage - index).abs() < 0.5)
                              Text(
                                'avatar'.tr(),
                                style: AppStyles.white16W400,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: BlocConsumer<RegisterViewModel, RegisterStates>(
                      listener: (context, state) {
                        if (state is RegisterSuccess) {
                          AppDialogs.showMessageDialog(
                            context: context,
                            text: 'success'.tr(),
                            message: 'register_success'.tr(),
                            buttonText: 'go_to_login'.tr(),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.loginScreen,
                              );
                            },
                          );
                        }

                        if (state is RegisterError) {
                          AppDialogs.showMessageDialog(
                            context: context,
                            text: 'error'.tr(),
                            message: state.message.tr(),
                            buttonText: 'try_again'.tr(),
                          );
                        }
                      },

                      builder: (context, state) {
                        final isLoading = state is RegisterLoading;

                        return AbsorbPointer(
                          absorbing: isLoading,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomizedTextFormField(
                                  controller: nameController,
                                  hintText: 'name'.tr(),
                                  prefixIcon: Image.asset(AppAssets.nameLogo, width: width * 0.02),
                                  keyboardType: TextInputType.name,
                                  onValidate: RegisterFunctions.nameValidation,
                                  textInputAction: TextInputAction.next,
                                ),

                                SizedBox(height: height * 0.03),

                                CustomizedTextFormField(
                                  controller: emailController,
                                  hintText: 'email'.tr(),
                                  prefixIcon: Image.asset(AppAssets.emailLogo, width: width * 0.02),
                                  keyboardType: TextInputType.emailAddress,
                                  onValidate: (email) =>
                                      RegisterFunctions.emailValidation(email: email),
                                  textInputAction: TextInputAction.next,
                                ),

                                SizedBox(height: height * 0.03),

                                CustomizedTextFormField(
                                  controller: passwordController,
                                  hintText: 'password'.tr(),
                                  obscureText: isHidden1,
                                  prefixIcon: Image.asset(AppAssets.passwordLogo, width: width * 0.02),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() => isHidden1 = !isHidden1);
                                    },
                                    icon: Icon(isHidden1
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  onValidate: (p) =>
                                      RegisterFunctions.passwordValidation(password: p),
                                  textInputAction: TextInputAction.next,
                                ),

                                SizedBox(height: height * 0.03),

                                CustomizedTextFormField(
                                  controller: confirmPasswordController,
                                  hintText: 'confirm_password'.tr(),
                                  obscureText: isHidden2,
                                  prefixIcon: Image.asset(AppAssets.passwordLogo, width: width * 0.02),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() => isHidden2 = !isHidden2);
                                    },
                                    icon: Icon(isHidden2
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  onValidate: (cp) =>
                                      RegisterFunctions.confirmPasswordValidation(
                                        password: passwordController.text,
                                        confirmPassword: cp,
                                      ),
                                  textInputAction: TextInputAction.next,
                                ),

                                SizedBox(height: height * 0.03),

                                CustomizedTextFormField(
                                  controller: phoneController,
                                  hintText: 'phone'.tr(),
                                  prefixIcon: Image.asset(AppAssets.phoneLogo, width: width * 0.02),
                                  keyboardType: TextInputType.phone,
                                  onValidate: (phone) =>
                                      RegisterFunctions.phoneValidation(phone: phone),
                                  textInputAction: TextInputAction.done,
                                ),

                                SizedBox(height: height * 0.03),

                                SizedBox(
                                  width: double.infinity,
                                  child: CustomizedElevatedButton(
                                    isLoading: isLoading,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<RegisterViewModel>().register(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                          avatar: selectedAvatar,
                                        );
                                      }
                                    },
                                    child: Text(
                                      'create_account'.tr(),
                                      style: AppStyles.black20W400,
                                    ),
                                  ),
                                ),

                                SizedBox(height: height * 0.02),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'already_have_an_account'.tr(),
                                      style: AppStyles.white14W400,
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        'login'.tr(),
                                        style: AppStyles.yellow14W900,
                                      ),
                                    ),
                                  ],
                                ),

                                ChooseLocale(
                                  onTap1: () =>
                                      context.setLocale(const Locale('en')),
                                  onTap2: () =>
                                      context.setLocale(const Locale('ar')),
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
            ],
          ),
          BlocBuilder<RegisterViewModel, RegisterStates>(
            builder: (context, state) {
              if (state is! RegisterLoading) {
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