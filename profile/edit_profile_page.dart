import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/app.dart';
import 'package:flutter_cubit/application/profile/profile_cubit.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_header.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/custom_textfield.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/utils/app_utils.dart';
import 'package:flutter_cubit/core/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/profile/profile_state.dart';
import '../../core/constants/image_constants.dart';
import '../../core/di/injectable.dart';
import '../../core/network/dio_client.dart';
import '../../core/preference/preference_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/common_textstyles.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    assignValues();
    super.initState();
  }

  void assignValues() {
    final data = context.read<ProfileCubit>().state.user;
    userNameController.text = data?.displayName ?? "";
    emailController.text = data?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdate) {
          context.router.pop();
        }
      },
      builder: (context, state) {
        return CommonScaffold(
          resizeToAvoidBottomInset: false,
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader(heading: "Edit Profile"),
                12.verticalSpace,
                profileContainer(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget profileContainer(ProfileState state) {
    return Expanded(
      child: CommonContainer(
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              userDetail(state),
              20.verticalSpace,
              CustomTextField(
                label: "Username",
                labelColor: ColorConstants.primaryColor700,
                hintText: "Username",
                controller: userNameController,
                validator: (e) => nameValidator(e),
              ),
              12.verticalSpace,
              CustomTextField(
                label: "Email",
                enabled: false,
                filledColor: ColorConstants.gray100,
                labelColor: ColorConstants.primaryColor700,
                hintText: "email",
                controller: emailController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (e) => emailValidator(e),
              ),
              // 12.verticalSpace,
              // CustomTextField(hintText: "•••••••••", enabled: false),
              20.verticalSpace,
              CustomButton(
                isLoading: state.isLoading,
                text: "Save Changes",
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    context.read<ProfileCubit>().updateUserDetails(
                      email: emailController.text,
                      displayName: userNameController.text,
                    );
                  }
                },
                backgroundColor: ColorConstants.secondaryColor500,
              ),
              Spacer(),
              CustomButton(
                text: "Log out",
                onTap: () async {
                  await getIt<DioClient>().auth.signOut();
                  await PreferenceHelper.clearAllPreferences();
                  appRouter.replaceAll([LoginRoute()]);
                },
                backgroundColor: ColorConstants.primaryColor700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userDetail(ProfileState state) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4.sp),
              child: Container(
                height: 60.h,
                width: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        state.localImage != null
                            ? FileImage(File(state.localImage!.path))
                            : AppUtils.getProfile(state.user?.profilePhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4.w,
              bottom: 0.h,
              child: GestureDetector(
                onTap: () {
                  showImagePickerDialogue(context);
                },
                child: CircleAvatar(
                  radius: 11.r,
                  backgroundColor: ColorConstants.secondaryColor600,
                  child: Center(
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        12.horizontalSpace,
        Text(
          "${state.user?.displayName}",
          style: textWith16W600(ColorConstants.black),
        ),
      ],
    );
  }

  void showImagePickerDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.gray100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: CircleAvatar(
                          backgroundColor: ColorConstants.primaryColor700,
                          radius: 10.r,
                          child: Icon(
                            Icons.close,
                            color: ColorConstants.white1,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  AppIcons.addCameraIcon,
                  height: 36.h,
                  width: 36.w,
                ),
                Text(
                  "Take a photo or upload from your gallery",
                  style: textWith10W400(ColorConstants.gray700),
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppUtils.customRec(
                      borderColor: ColorConstants.primaryColor700,
                      backgroundColor: ColorConstants.primaryColor700,
                      onTap: () {
                        context.pop();
                        context.read<ProfileCubit>().uploadImage(
                          source: ImageSource.camera,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.cameraIcon,
                            color: ColorConstants.white1,
                            height: 14.h,
                            width: 14.w,
                          ),
                          4.horizontalSpace,
                          Text(
                            "Camera",
                            style: textWith12W500(ColorConstants.white1),
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    AppUtils.customRec(
                      borderColor: ColorConstants.primaryColor700,
                      backgroundColor: Colors.transparent,
                      onTap: () {
                        context.pop();
                        context.read<ProfileCubit>().uploadImage(
                          source: ImageSource.gallery,
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.galleryIcon,
                            color: ColorConstants.primaryColor700,
                            height: 14.h,
                            width: 14.w,
                          ),
                          4.horizontalSpace,
                          Text(
                            "Gallery",
                            style: textWith12W500(
                              ColorConstants.primaryColor700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
