import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/profile/profile_cubit.dart';
import 'package:flutter_cubit/application/profile/profile_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/core/models/privacy_policy_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/common_textstyles.dart';

@RoutePage()
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final policyPoints = [
    PolicyHelper(
      heading: "Information We Collect",
      body:
          "We collect your email address, uploaded photos, and hair serum usage details to improve your experience.",
    ),
    PolicyHelper(
      heading: "How We Use Your Information",
      body:
          "We use your data to track hair progress, send reminders, suggest reorders, and offer personalized hair care tips.",
    ),
    PolicyHelper(
      heading: "Photo Usage",
      body:
          "Your uploaded photos are used solely for AI hair growth predictions and progress tracking. We do not share them publicly.",
    ),
    PolicyHelper(
      heading: "Shopify Integration",
      body:
          "We connect with Shopify to manage your serum purchases and alert you when it’s time to reorder.",
    ),
    PolicyHelper(
      heading: "Notifications",
      body:
          "You may receive reminders, progress updates, and helpful hair care tips via push notifications.",
    ),
    PolicyHelper(
      heading: "Data Security",
      body: "We use secure methods to protect your personal information.",
    ),
    PolicyHelper(
      heading: "Your Choices",
      body:
          "You can update your profile information, opt-out of notifications, or request data deletion anytime.",
    ),
    PolicyHelper(
      heading: "Contact Us",
      body:
          "Have questions about your privacy? Contact us at [support@fleavaapp.com].",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CommonScaffold(
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  20.verticalSpace,
                  body(state),
                  16.verticalSpace,
                  termsAndService(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget header() {
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
        Text("Privacy Policy", style: textWith24W600(ColorConstants.black)),
        4.verticalSpace,
        Text(
          "Your privacy is important to us.",
          style: textWith10W400(ColorConstants.gray700),
        ),
      ],
    );
  }

  Widget body(ProfileState state) {
    return CommonContainer(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = policyPoints[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index + 1}.${item.heading}",
                style: textWith12W500(ColorConstants.black),
              ),
              Text(item.body, style: textWith10W400(ColorConstants.black)),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return 8.verticalSpace;
        },
        itemCount: policyPoints.length,
      ),
    );
  }

  Widget termsAndService(ProfileState state) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (!state.isChecked) {
              context.read<ProfileCubit>().updatePrivacyPolicy();
            }
          },
          child: SvgPicture.asset(
            state.isChecked ? AppIcons.checkedBox : AppIcons.uncheckedBox,
            height: 18.h,
            width: 18.w,
            color: ColorConstants.gray700,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            "By using Fleava, you agree to our Privacy Policy and Terms of Service",
            style: textWith12W500(ColorConstants.gray700),
          ),
        ),
      ],
    );
  }
}
