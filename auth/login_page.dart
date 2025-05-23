import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/app.dart';
import 'package:flutter_cubit/application/auth_cubit/login_cubit/login_cubit_bloc.dart';
import 'package:flutter_cubit/application/auth_cubit/login_cubit/login_state.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/custom_textfield.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/theme/app_colors.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_cubit/core/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/common_widgets/gradient_scaffold.dart';
import '../../components/common_widgets/focus_widget.dart';
import '../../core/constants/image_constants.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void checkValidation() {
    context.read<LoginCubit>().checkFormState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context,state){
        if(state is UserLoggedIn){
          appRouter.replaceAll([DashboardRoute()]);
        }
      },
      builder: (context, state) {
        return GradientScaffold(
          child: FocusWidget(
            child: Column(children: [getAppLogo(state), getFields(state)]),
          ),
        );
      },
    );
  }

  Widget getAppLogo(LoginState state) {
    return Expanded(
      child: SizedBox(
        child: Image.asset(AppImages.appLogo, height: 52.h, width: 132.w),
      ),
    );
  }

  Widget getFields(LoginState state) {
    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: context.read<LoginCubit>().formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'Enter Your Username or Email',
                  label: 'Username',
                  controller: emailController,
                  validator: (value) => nameValidator(value),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                12.verticalSpace,
                CustomTextField(
                  controller: passwordController,
                  onChanged: (e) => checkValidation(),
                  hintText: "Enter Your Password",
                  isPasswordField: true,
                  label: "Password",
                  obscureText: true,
                  validator: (value) => passwordValidator(value),
                ),
                12.verticalSpace,
                getRememberMe(state),
                24.verticalSpace,
                CustomButton(
                  text: "Log In",
                  isLoading: state.isLoading,
                  onTap: () {
                    if (context
                        .read<LoginCubit>()
                        .formKey
                        .currentState!
                        .validate()) {
                      context.read<LoginCubit>().loginUser(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    }
                  },
                  textColor:
                      state.isValidated
                          ? ColorConstants.white1
                          : ColorConstants.gray500,
                  backgroundColor:
                      state.isValidated
                          ? ColorConstants.secondaryColor500
                          : ColorConstants.secondaryColor300,
                ),
                12.verticalSpace,
                CustomButton(
                  text: "Sign Up",
                  onTap: () {
                    context.router.push(SignupRoute());
                  },
                  backgroundColor: ColorConstants.primaryColor700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRememberMe(LoginState state) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context.read<LoginCubit>().updateRememberMe();
          },
          child: SvgPicture.asset(
            state.shouldRememberUser
                ? AppIcons.checkedBox
                : AppIcons.uncheckedBox,
            height: 18.h,
            width: 18.w,
          ),
        ),
        8.horizontalSpace,
        Text(
          "Remember my Login Info",
          style: textWith12W500(ColorConstants.primaryColor300),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            context.router.push(ForgotPasswordRoute());
          },
          child: Text(
            "Forgot Login Details?",
            style: textWith12W500(ColorConstants.primaryColor500).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: ColorConstants.primaryColor500,
            ),
          ),
        ),
      ],
    );
  }
}
