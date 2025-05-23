import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/profile/notification/notification_cubit.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_loader.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/common_widgets/switcher_tile.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/profile/notification/notification_state.dart';
import '../../core/theme/app_colors.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    context.read<NotificationCubit>().getNotificationResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return CommonScaffold(
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [header(), 16.verticalSpace, body(state)],
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
        Text("Notifications", style: textWith24W600(ColorConstants.black)),
        4.verticalSpace,
        Text(
          "Stay updated with your hair journey, daily reminders, \nand important alerts.",
          style: textWith10W400(ColorConstants.gray700),
        ),
      ],
    );
  }

  Widget body(NotificationState state) {
    return CommonContainer(
      child:
          state.isLoading
              ? SizedBox(
                width: double.infinity,
                height: 200.h,
                child: Center(child: CommonLoader()),
              )
              : Column(
                spacing: 12.h,
                children: [
                  SwitcherTile(
                    heading: "Daily Serum Reminder",
                    keyName: "dailySerumReminder",
                    body: "Stay consistent to boost your hair growth results.",
                    value: state.notificationData?.dailySerumReminder ?? false,
                  ),
                  SwitcherTile(
                    heading: "Progress Update Available",
                    body: "View AI-predicted hair growth based on your photos.",
                    keyName: "progressUpdateAvailable",
                    value:
                        state.notificationData?.progressUpdateAvailable ??
                        false,
                  ),
                  SwitcherTile(
                    heading: "Low Stock Alert",
                    body: "Keep your serum supply steady for best progress.",
                    keyName: "lowStockAlert",
                    value: state.notificationData?.lowStockAlert ?? false,
                  ),
                  SwitcherTile(
                    heading: "Order Confirmation",
                    body: "Your Fleava Hair Serum is on its way!",
                    keyName: "orderConfirmation",
                    value: state.notificationData?.orderConfirmation ?? false,
                  ),
                  SwitcherTile(
                    heading: "New Hair Care Article",
                    keyName: "newHairArticle",
                    body:
                        "Learn quick tips to strengthen and protect your hair.",
                    value: state.notificationData?.newHairArticle ?? false,
                  ),
                  SwitcherTile(
                    heading: "Weekly Progress Tip",
                    keyName: "weeklyProgressTip",
                    body:
                        "Use natural light and same angles for clearer progress.",
                    value: state.notificationData?.weeklyProgressTip ?? false,
                  ),
                ],
              ),
    );
  }
}
