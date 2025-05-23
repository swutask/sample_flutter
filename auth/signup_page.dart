import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/auth_cubit/signup_cubit/signup_cubit_bloc.dart';
import 'package:flutter_cubit/application/auth_cubit/signup_cubit/signup_state.dart';
import 'package:flutter_cubit/components/common_widgets/custom_textfield.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/common_widgets/gradient_scaffold.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/common_widgets/custom_button.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void checkValidation() {
    context.read<SignUpCubit>().checkFormState();
  }

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
    return BlocConsumer<SignUpCubit, SignupState>(
      listener: (context,state){
        if(state is UserSignedUp){
          context.router.replaceAll([
            LoginRoute(),
          ], updateExistingRoutes: true);
        }
      },
      builder: (context, state) {
        return GradientScaffold(
          child: FocusWidget(
            child: Column(children: [getAppLogo(), getFields(state)]),
          ),
        );
      },
    );
  }

  Widget getAppLogo() {
    return Expanded(
      child: SizedBox(
        child: Image.asset(AppImages.appLogo, height: 52.h, width: 132.w),
      ),
    );
  }

  Widget getFields(SignupState state) {
    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: context.read<SignUpCubit>().formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: "Email",
                  hintText: "abc@gmail.com",
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  controller: usernameController,
                  validator: emailValidator,
                  onChanged: (e) => checkValidation(),
                ),
                8.verticalSpace,
                CustomTextField(
                  label: "Password",
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  hintText: "Enter Your Password",
                  isPasswordField: true,
                  obscureText: true,
                  controller: passwordController,
                  validator: passwordValidator,
                  onChanged: (e) => checkValidation(),
                ),
                8.verticalSpace,
                CustomTextField(
                  label: "Confirm Password",
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  hintText: "Enter Your Password",
                  isPasswordField: true,
                  obscureText: true,
                  controller: confirmPassController,
                  onChanged: (e) => checkValidation(),
                  validator: confirmPassValidator,
                ),
                24.verticalSpace,
                CustomButton(
                  text: "Create Account",
                  isLoading: state.isLoading,
                  onTap: () {
                    if (state.isValidated) {
                      // context.read<SignUpCubit>().createUser(
                      //   email: usernameController.text,
                      //   password: confirmPassController.text,
                      // );
                      context.pushRoute(
                        EmailVerificationRoute(
                          email: usernameController.text,
                          password: confirmPassController.text,
                        ),
                      );
                    }
                  },
                  textColor: ColorConstants.white1,
                  backgroundColor:
                      state.isValidated
                          ? ColorConstants.primaryColor700
                          : ColorConstants.primaryColor300,
                ),
                12.verticalSpace,
                CustomButton(
                  text: "Log In",
                  onTap: () {
                    context.router.replaceAll([
                      LoginRoute(),
                    ], updateExistingRoutes: true);
                  },
                  backgroundColor: ColorConstants.secondaryColor500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
