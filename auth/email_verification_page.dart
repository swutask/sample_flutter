import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/app.dart';
import 'package:flutter_cubit/application/auth_cubit/email_verify_cubit/email_verify_cubit_bloc.dart';
import 'package:flutter_cubit/application/auth_cubit/email_verify_cubit/email_verify_state.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/common_widgets/gradient_scaffold.dart';
import 'package:flutter_cubit/core/constants/constants.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_cubit/core/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../core/theme/app_colors.dart';

@RoutePage()
class EmailVerificationPage extends StatefulWidget {
  final String email;
  final String password;

  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context.read<EmailVerifyCubit>().sendOtp(email: widget.email);
    super.initState();
  }

  void navigateToVerification() {
    context.read<EmailVerifyCubit>().stopTimer();
    context.router.popAndPush(
      InfoRoute(
        headingIcon: "🎉",
        heading: EMAILVERIFIED,
        body: EVERIFIEDTEXT,
        button: CustomButton(
          text: "Continue",
          onTap: () {
            appRouter.replaceAll([DashboardRoute()]);
          },
          backgroundColor: ColorConstants.primaryColor700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailVerifyCubit, EmailVerifyState>(
      listener: (context, state) {
        if (state is UserVerified) {
          navigateToVerification();
        }
      },
      builder: (context, state) {
        return GradientScaffold(
          gradientColors: [
            ColorConstants.linearGradient1,
            ColorConstants.linearGradient1,
            ColorConstants.linearGradient2,
            ColorConstants.linearGradient3,
          ],
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getHeader(state), 24.verticalSpace, body(state)],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getHeader(EmailVerifyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        100.verticalSpace,
        Text(
          state.hasError ? "⚠️ Verification Failed" : "Enter Verification Code",
          style: textWith24W600(ColorConstants.white1),
        ),
        4.verticalSpace,
        Text(
          state.hasError
              ? "The code you entered is incorrect. Please \ntry again."
              : "We’ve sent a 6-digit code to abc@gmail.com. Please enter it below.",
          style: textWith14W400(ColorConstants.white1),
        ),
      ],
    );
  }

  Widget body(EmailVerifyState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Form(
                key: context.read<EmailVerifyCubit>().formKey,
                child: Pinput(
                  controller: controller,
                  length: 6,
                  validator: (e) => otpValidator(e),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  forceErrorState: state.hasError,
                  onChanged: (e) {
                    context.read<EmailVerifyCubit>().updateHasError(false);
                  },
                  onCompleted: (e) {
                    context.read<EmailVerifyCubit>().checkFormState();
                  },
                  separatorBuilder: (v) => 8.horizontalSpace,
                  errorPinTheme: PinTheme(
                    height: 80.h,
                    textStyle: textWith24W600(ColorConstants.red),
                    decoration: BoxDecoration(
                      color: ColorConstants.white1.withValues(alpha: 0.1),
                      border: Border.all(
                        color: ColorConstants.red.withValues(alpha: 0.5),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  errorTextStyle: textWith16W500(ColorConstants.red),
                  defaultPinTheme: PinTheme(
                    height: 80.h,
                    textStyle: textWith24W600(ColorConstants.white1),
                    decoration: BoxDecoration(
                      color: ColorConstants.white1.withValues(alpha: 0.1),
                      border: Border.all(
                        color: ColorConstants.white1.withValues(alpha: 0.2),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        24.verticalSpace,
        state.hasError
            ? CustomButton(
              text: "Try Again",
              onTap: () {
                controller.clear();
                context.read<EmailVerifyCubit>().updateHasError(false);
                context.read<EmailVerifyCubit>().checkFormState();
              },
              textColor: ColorConstants.white1,
              borderColor: ColorConstants.red,
              backgroundColor: Colors.transparent,
            )
            : CustomButton(
              text: "Verify",
              onTap: () {
                if (state.isValidated) {
                  context.read<EmailVerifyCubit>().checkOtp(controller.text);
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
        24.verticalSpace,
        if (!state.hasError) getResendCode(state),
      ],
    );
  }

  Widget getResendCode(EmailVerifyState state) {
    return Row(
      children: [
        Text(
          "Didn’t get the code?",
          style: textWith12W500(ColorConstants.white1),
        ),
        4.horizontalSpace,
        GestureDetector(
          onTap: () {
            if (state.timer == 0) {
              context.read<EmailVerifyCubit>().startTimer();
            }
          },
          child: Text(
            "Resend Code",
            style: textWith14W500(ColorConstants.secondaryColor600).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: ColorConstants.secondaryColor600,
            ),
          ),
        ),
        Spacer(),
        if (state.timer != 0)
          Text(
            "${(state.timer ~/ 60)}:${(state.timer % 60).toString().padLeft(2, '0')}",
            style: textWith12W500(ColorConstants.white1),
          ),
      ],
    );
  }
}
