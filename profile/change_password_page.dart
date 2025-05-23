import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/profile/profile_cubit.dart';
import '../../application/profile/profile_state.dart';
import '../../components/common_widgets/common_scaffold.dart';
import '../../components/common_widgets/custom_button.dart';
import '../../components/common_widgets/custom_textfield.dart';
import '../../components/common_widgets/focus_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/common_textstyles.dart';
import '../../core/utils/validators.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final currentPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? confirmPassValidator(String? value) {
    final passValue = passwordController.text;
    final confirmPassValue = confirmPassController.text;
    if (value == null || passValue != confirmPassValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is PasswordUpdated) {
          context.router.pop();
        }
      },
      builder: (context, state) {
        return CommonScaffold(
          resizeToAvoidBottomInset: false,
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(state),
                  20.verticalSpace,
                  passwordContainer(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget header(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.router.pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ColorConstants.black,
            size: 30.sp,
          ),
        ),
        16.verticalSpace,
        Text(
          getHeadingText(state),
          style: textWith24W600(ColorConstants.black),
        ),
        4.verticalSpace,
        Text(
          getSubHeading(state),
          style: textWith10W400(ColorConstants.gray700),
        ),
      ],
    );
  }

  Widget passwordContainer(ProfileState state) {
    return CommonContainer(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            getPasswordField(state),
            20.verticalSpace,
            CustomButton(
              isLoading: state.isLoading,
              text: state.isPassValidated ? "Change Password": "Submit",
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if(state.isPassValidated){
                    context.read<ProfileCubit>().changePassword(
                      password: confirmPassController.text,
                    );
                  }else{
                    context.read<ProfileCubit>().checkCurrentPassword(
                      password: currentPassword.text,
                    );
                  }
                }
              },
              backgroundColor: ColorConstants.secondaryColor500,
            ),
          ],
        ),
      ),
    );
  }

  Widget getPasswordField(ProfileState state) {
    return !state.isPassValidated
        ? CustomTextField(
          label: "Password",
          labelColor: ColorConstants.black,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          hintText: "Enter current password",
          isPasswordField: true,
          obscureText: true,
          controller: currentPassword,
          validator: passwordValidator,
        )
        : Column(
          children: [
            CustomTextField(
              label: "Password",
              labelColor: ColorConstants.black,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              hintText: "Enter Your Password",
              isPasswordField: true,
              obscureText: true,
              controller: passwordController,
              validator: passwordValidator,
            ),
            12.verticalSpace,
            CustomTextField(
              labelColor: ColorConstants.black,
              label: "Confirm Password",
              autoValidateMode: AutovalidateMode.onUserInteraction,
              hintText: "Enter Your Password",
              isPasswordField: true,
              obscureText: true,
              controller: confirmPassController,
              validator: confirmPassValidator,
            ),
          ],
        );
  }

  String getHeadingText(ProfileState state) {
    return state.isPassValidated ? "Change Password" : "Enter Current Password";
  }

  String getSubHeading(ProfileState state) {
    return state.isPassValidated
        ? "Set a new password to enhance your\n account security"
        : "Let us check if that's you for\n secure experience";
  }
}
