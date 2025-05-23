import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/app.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/custom_textfield.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/common_widgets/gradient_scaffold.dart';
import 'package:flutter_cubit/core/constants/constants.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_cubit/core/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  void simulateSuccess() {
    context.router.push(
      InfoRoute(
        button: CustomButton(
          text: "Back to Login",
          onTap: () {
            appRouter.replaceAll([LoginRoute()]);
          },
          backgroundColor: ColorConstants.primaryColor700,
        ),
        headingIcon: "✅",
        heading: RESETLINKTEXT,
        body: CHECKINBOX,
      ),
    );
  }

  void simulateFailure() {
    context.router.push(
      InfoRoute(
        button: CustomButton(
          text: "Back to Reset",
          onTap: () {
            appRouter.pop();
          },
          backgroundColor: ColorConstants.secondaryColor500,
        ),
        headingIcon: "⚠️",
        heading: INCORRECTMAIL,
        body: NOACCOUNTFOUND,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      gradientColors: [
        ColorConstants.linearGradient1,
        ColorConstants.linearGradient2,
        ColorConstants.linearGradient3,
      ],
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [getHeader()],
          ),
        ),
      ),
    );
  }

  Widget getHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        100.verticalSpace,
        Text("Forgot Password?", style: textWith24W600(ColorConstants.white1)),
        4.verticalSpace,
        Text(
          "No worries, we’ll help you reset it.",
          style: textWith12W400(Colors.white),
        ),
        52.verticalSpace,
        Form(
          key: formKey,
          child: CustomTextField(
            controller: controller,
            label: "Enter your registered email",
            hintText: "you@example.com",
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (e) => emailValidator(e),
          ),
        ),
        20.verticalSpace,
        CustomButton(
          text: "Send Reset Link",
          onTap: () {
            if (formKey.currentState!.validate()) {
              if (controller.text == "test@gmail.com") {
                simulateSuccess();
              } else {
                simulateFailure();
              }
            }
          },
          backgroundColor: ColorConstants.primaryColor700,
        ),
      ],
    );
  }
}
