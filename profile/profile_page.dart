import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/profile/profile_cubit.dart';
import 'package:flutter_cubit/application/profile/profile_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_loader.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/order/order_widget.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/network/dio_client.dart';
import 'package:flutter_cubit/core/preference/preference_helper.dart';
import 'package:flutter_cubit/core/utils/app_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app.dart';
import '../../components/common_widgets/focus_widget.dart';
import '../../core/di/injectable.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/common_textstyles.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    getProfileData(isLoading: true);
    super.initState();
  }

  void getProfileData({bool isLoading = false}) {
    context.read<ProfileCubit>().getUser(isLoading: isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CommonScaffold(
          backgroundColor: ColorConstants.white1,
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child:
                state.isLoading
                    ? Center(child: CommonLoader())
                    : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Profile",
                            style: textWith24W600(ColorConstants.black),
                          ),
                          20.verticalSpace,
                          profileContainer(state),
                          20.verticalSpace,
                          Text(
                            "My Orders",
                            style: textWith16W600(ColorConstants.black),
                          ),
                          20.verticalSpace,
                          ordersWidget(),
                          12.verticalSpace,
                          CustomButton(
                            text: "Log Out",
                            onTap: () async {
                              await getIt<DioClient>().auth.signOut();
                              await PreferenceHelper.clearAllPreferences();
                              appRouter.replaceAll([LoginRoute()]);
                            },
                            backgroundColor: ColorConstants.secondaryColor500,
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }

  Widget profileContainer(ProfileState state) {
    return CommonContainer(
      child: Column(
        children: [
          userDetail(state),
          16.verticalSpace,
          subProfileContainer(
            text: "Edit Profile",
            icon: Icons.person,
            onTap: () async {
              context.router
                  .push(EditProfileRoute())
                  .then((e) => getProfileData());
            },
          ),
          16.verticalSpace,
          subProfileContainer(
            text: "Notification",
            icon: Icons.notifications,
            onTap: () {
              context.router.push(NotificationRoute());
            },
          ),
          16.verticalSpace,
          subProfileContainer(
            text: "Privacy & Policy",
            icon: Icons.policy,
            onTap: () {
              context.router.push(PrivacyPolicyRoute());
            },
          ),
          16.verticalSpace,
          subProfileContainer(
            text: "Change Password",
            icon: Icons.password,
            onTap: () {
              context.router
                  .push(ChangePasswordRoute())
                  .then((e) => getProfileData());
            },
          ),
        ],
      ),
    );
  }

  Widget userDetail(ProfileState state) {
    return Row(
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
                    image: AppUtils.getProfile(state.user?.profilePhoto),
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
                  context.router
                      .push(EditProfileRoute())
                      .then((e) => getProfileData());
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${state.user?.displayName}",
                style: textWith14W600(ColorConstants.black),
              ),
              4.verticalSpace,
              Text(
                "${state.user?.email}",
                style: textWith10W400(ColorConstants.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget ordersWidget() {
    return Column(
      children: [
        ...List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: OrderWidget(),
          ),
        ),
        CustomButton(
          height: 36.h,
          text: "View All Orders",
          onTap: () {
            context.router.push(OrderRoute());
          },
          textStyle: textWith12W500(ColorConstants.primaryColor700),
          borderColor: ColorConstants.primaryColor700,
        ),
        20.verticalSpace,
        CommonContainer(
          color: ColorConstants.gray100,
          borderColor: ColorConstants.gray200,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(
                Icons.headset_mic_rounded,
                color: ColorConstants.primaryColor700,
                size: 20.sp,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact us via mail",
                      style: textWith10W400(ColorConstants.black),
                    ),
                    Text(
                      "hello@fleava.shop",
                      style: textWith12W500(ColorConstants.black).copyWith(
                        decorationColor: ColorConstants.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              12.horizontalSpace,
              Icon(Icons.navigate_next, color: ColorConstants.gray700),
            ],
          ),
        ),
      ],
    );
  }

  Widget subProfileContainer({
    required String text,
    required IconData icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CommonContainer(
        color: ColorConstants.gray100,
        borderColor: ColorConstants.gray200,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Icon(icon, color: ColorConstants.primaryColor700),
            12.horizontalSpace,
            Text(text, style: textWith12W500(ColorConstants.black)),
            Spacer(),
            Icon(Icons.navigate_next, color: ColorConstants.gray700),
          ],
        ),
      ),
    );
  }
}
