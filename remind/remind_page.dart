import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/profile/notification/notification_cubit.dart';
import 'package:flutter_cubit/application/profile/notification/notification_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_loader.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/common_widgets/switcher_tile.dart';
import 'package:flutter_cubit/components/remind/application_log_card.dart';
import 'package:flutter_cubit/components/remind/serum_tracker.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/common_textstyles.dart';

@RoutePage()
class RemindPage extends StatefulWidget {
  const RemindPage({super.key});

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  final List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().subtract(Duration(days: 3)),
  ];

  @override
  void initState() {
    context.read<NotificationCubit>().getNotificationResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backgroundColor: ColorConstants.white1,
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Serum Tracker",
                style: textWith24W600(ColorConstants.black),
              ),
              20.verticalSpace,
              SerumTracker(),
              20.verticalSpace,
              applicationLog(),
              20.verticalSpace,
              reminderSettings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget applicationLog() {
    return CommonContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Daily Application Log", style: textWith14W600(Colors.black)),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            itemBuilder: (context, index) {
              final item = dates[index];
              return ApplicationLogCard(date: item);
            },
            separatorBuilder: (context, index) => 12.verticalSpace,
            itemCount: dates.length,
          ),
          CustomButton(
            text: "View Complete History",
            onTap: () {
              context.router.push(ApplicationLogRoute());
            },
            height: 36.h,
            backgroundColor: ColorConstants.white1,
            borderColor: ColorConstants.secondaryColor700,
            textColor: ColorConstants.secondaryColor600,
          ),
        ],
      ),
    );
  }

  Widget reminderSettings() {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return CommonContainer(
          width: double.infinity,
          borderColor: ColorConstants.gray500,
          color: ColorConstants.gray100,
          child:
              state.isLoading
                  ? SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: CommonLoader(),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reminder Settings",
                        style: textWith14W500(ColorConstants.black),
                      ),
                      SwitcherTile(
                        value:
                            state.notificationData?.morningApplication ?? false,
                        keyName: "morningApplication",
                        heading: "Morning Application",
                        body: "9:00 AM every day",
                      ),
                      SwitcherTile(
                        value:
                            state.notificationData?.eveningApplication ?? false,
                        keyName: "eveningApplication",
                        heading: "Evening Application",
                        body: "9:00 PM every day",
                      ),
                      SwitcherTile(
                        value: state.notificationData?.lowSerumAlert ?? false,
                        keyName: "lowSerumAlert",
                        heading: "Low Serum Alert",
                        body: "Notify when 20% remaining",
                      ),
                      SwitcherTile(
                        value:
                            state.notificationData?.weeklyProgressPhoto ??
                            false,
                        keyName: "weeklyProgressPhoto",
                        heading: "Weekly Progress Photo",
                        body: "Sunday at 10:00 AM",
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
