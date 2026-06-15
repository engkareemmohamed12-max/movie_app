import 'dart:ui';

import 'package:cineluxe/data/repository/firestore/repository/impl/user_repository_impl.dart';
import 'package:cineluxe/data/repository/firestore/repository/user_repository.dart';
import 'package:cineluxe/utils/app_styles.dart';
import 'package:cineluxe/widgets/alert_dialouge_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/repository/firestore/data_sources/remote/impl/user_remote_data_source_impl.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/app_sizes.dart';
import '../../../widgets/customized_elevated_button.dart';
import '../../../widgets/customized_text_form_field.dart';
import '../logic/states/update_profile_states.dart';
import '../logic/update_profile_functions.dart';
import '../logic/update_profile_view_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState
    extends State<UpdateProfileScreen> {
  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  String avatar = "";
  final formKey = GlobalKey<FormState>();

  final List<String> avatars = List.generate(
    9,
        (i) => "avatar${i + 1}",
  );

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(
        UserRepositoryImpl(
          UserRemoteDataSourceImpl(FirebaseFirestore.instance),
        ),
      )..loadUser(),

      child: Scaffold(
        backgroundColor: const Color(0xFF121212),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),

            child: BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  nameController.text = state.user.name ?? "";
                  phoneController.text = state.user.phone ?? "";
                  setState(() {
                    avatar = state.user.avatar ?? "";
                    print("Check Avatar Value: ${state.user.avatar}");
                  });
                }

                if (state is UserUpdated) {
                  AppDialogs.showMessageDialog(
                    context: context,
                    text: "Success",
                    message: "Profile updated successfully",
                    buttonText: "OK",
                  );
                }

                if (state is UserDeleted) {
                  AppDialogs.showMessageDialog(
                    context: context,
                    text: "Deleted",
                    message: "Account deleted successfully",
                    buttonText: "OK",
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.loginScreen,
                            (route) => false,
                      );
                    },
                  );
                }

                if (state is UserError) {
                  AppDialogs.showMessageDialog(
                    context: context,
                    text: "Error",
                    message: state.message,
                    buttonText: "OK",
                  );
                }
              },

              builder: (context, state) {
                if (state is UserLoading) {
                  return Center(
                    child:
                    LoadingAnimationWidget
                        .staggeredDotsWave(
                      color: AppColors.yellowColor,
                      size: 50,
                    ),
                  );
                }

                if (state is UserError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return Form(
                  key: formKey,

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.015,
                        ),

                        _buildHeader(width),

                        SizedBox(
                          height: height * 0.04,
                        ),

                        _buildMainAvatar(width),

                        SizedBox(
                          height: height * 0.05,
                        ),

                        CustomizedTextFormField(
                          hintText: "Enter Name",

                          textInputAction:
                          TextInputAction.next,

                          prefixIcon: Image.asset(AppAssets.personLogo,width: width*0.02,),

                          controller:
                          nameController,

                          onValidate: (name) {
                            return UpdateProfileFunctions
                                .nameValidation(
                              name,
                            );
                          },
                        ),

                        SizedBox(
                          height: height * 0.025,
                        ),

                        CustomizedTextFormField(
                          hintText:
                          "Enter Number",

                          textInputAction:
                          TextInputAction.done,

                          keyboardType:
                          TextInputType.phone,

                          prefixIcon: Image.asset(AppAssets.phoneLogo,width: width*0.02,),


                          controller:
                          phoneController,

                          onValidate: (phone) {
                            return UpdateProfileFunctions
                                .phoneValidation(
                              phone: phone,
                            );
                          },
                        ),

                        SizedBox(
                          height: height * 0.015,
                        ),

                        Align(
                          alignment:
                          Alignment.centerLeft,

                          child: TextButton(
                            onPressed: () {},

                            child: Text(
                              "Reset Password",

                              style: AppStyles.regular20WhiteColorW400
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.26,
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: CustomizedElevatedButton(
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                            backgroundColor: Colors.redAccent,
                            child: Text(
                              "Delete Account",
                              style: AppStyles.white20W400,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.02,
                        ),

                        SizedBox(
                          width: double.infinity,

                          child:
                          CustomizedElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<UserCubit>().updateUser(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  avatar: avatar,
                                );
                              }
                            },

                            child: Text(
                              "Update Data",

                              style: AppStyles.black20W400,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.02,
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
    );
  }

  Widget _buildHeader(double width) {
    return Row(
      children: [
        IconButton(
          icon: ImageIcon(AssetImage(AppAssets.arrowBack),color: AppColors.yellowColor),

          onPressed: () =>
              Navigator.pop(context),
        ),

        Expanded(
          child: Center(
            child: Text(
              "Pick Avatar",

              style: TextStyle(
                color: AppColors.yellowColor,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(width: width * 0.12),
      ],
    );
  }

  Widget _buildMainAvatar(double width) {
    return GestureDetector(
      onTap: _showAvatarPicker,
      child: Container(
        width: width * 0.36,
        height: width * 0.36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: avatar.isNotEmpty
              ? Image.asset(
            UpdateProfileFunctions.getAvatarPath(avatar),
            fit: BoxFit.cover,
          )
              : Icon(
            Icons.person,
            size: width * 0.2,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    var width = context.width;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(width * 0.05),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: avatars.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: width * 0.04,
              crossAxisSpacing: width * 0.04,
            ),
            itemBuilder: (context, index) {
              bool isSelected = avatar == avatars[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    avatar = avatars[index];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ?  AppColors.yellowColor.withValues(alpha: 0.56) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.yellowColor.withValues(alpha: 0.56),
                      width: 2,
                    )
                  ),
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      UpdateProfileFunctions.getAvatarPath(avatars[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  void _showDeleteDialog(BuildContext pageContext) {
    AppDialogs.showMessageDialog(
      context: pageContext,
      text: "Delete Account",
      message: "Are you sure you want to delete your account? ",
      buttonText: "Delete",
      onPressed: () {
        pageContext.read<UserCubit>().deleteUser();
      },
    );
  }

}