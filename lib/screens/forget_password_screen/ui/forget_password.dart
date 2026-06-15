import 'package:cineluxe/utils/app_assets.dart';
import 'package:cineluxe/utils/app_styles.dart';
import 'package:cineluxe/widgets/customized_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../widgets/alert_dialouge_widget.dart';
import '../../../widgets/customized_text_form_field.dart';
import '../logic/reset_functions.dart';
import '../logic/reset_states/reset_states.dart';
import '../logic/reset_view_model.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        title: Text('forgetPassword'.tr(), style: AppStyles.yellow16W400),
        foregroundColor: AppColors.yellowColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: context.locale.languageCode == 'en'
              ? Image.asset(AppAssets.arrowBack)
              : const Icon(Icons.arrow_back_outlined),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: BlocConsumer<ResetViewModel, ResetStates>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              AppDialogs.showMessageDialog(
                context: context,
                text: "success".tr(),
                message: "reset_email_sent".tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }

            if (state is ResetPasswordError) {
              AppDialogs.showMessageDialog(
                context: context,
                text: "error".tr(),
                message: state.message.tr(),
              );
            }
          },

          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;

            return AbsorbPointer(
              absorbing: isLoading,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset(AppAssets.forgetPassPic),

                      SizedBox(height: height * 0.03),

                      CustomizedTextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.done,
                        hintText: 'email'.tr(),
                        prefixIcon: Image.asset(AppAssets.emailLogo),
                        keyboardType: TextInputType.emailAddress,
                        onValidate: (email) =>
                            ResetFunctions.emailValidation(email: email),
                      ),

                      SizedBox(height: height * 0.03),

                      SizedBox(
                        width: double.infinity,
                        child: CustomizedElevatedButton(
                          isLoading: isLoading,
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              context
                                  .read<ResetViewModel>()
                                  .resetPassword(emailController.text);
                            }
                          },
                          child: Text(
                            'verify_email'.tr(),
                            style: AppStyles.black20W400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}