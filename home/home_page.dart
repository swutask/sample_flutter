import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/home/home_cubit.dart';
import 'package:flutter_cubit/application/home/home_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_loader.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/home/hair_growth_widget.dart';
import 'package:flutter_cubit/components/home/serum_status_widget.dart';
import 'package:flutter_cubit/components/home/task_card.dart';
import 'package:flutter_cubit/core/constants/image_constants.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/theme/app_colors.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() {
    context.read<HomeCubit>().getData();
  }

  void getTasks() {
    context.read<HomeCubit>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return CommonScaffold(
          backgroundColor: ColorConstants.white1,
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child:
                state.isLoading
                    ? Center(child: CommonLoader())
                    : SingleChildScrollView(
                      child: Column(
                        children: [
                          36.verticalSpace,
                          headerWidget(state),
                          24.verticalSpace,
                          HairGrowthWidget(startDate: DateTime(2025, 5, 10)),
                          24.verticalSpace,
                          taskWidget(state),
                          16.verticalSpace,
                          serumStatus(),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }

  Widget headerWidget(HomeState state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey ${state.user?.displayName}",
                style: textWith24W600(ColorConstants.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Welcome Back!",
                style: textWith14W500(ColorConstants.gray600),
              ),
            ],
          ),
        ),
        16.horizontalSpace,
        GestureDetector(
          onTap: () {
            context.router.push(NotificationRoute());
          },
          child: Container(
            height: 36.h,
            width: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants.primaryColor100,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.notificationsIcon,
                height: 24.h,
                width: 24.w,
                color: ColorConstants.primaryColor700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget taskWidget(HomeState state) {
    return Column(
      children: [
        Row(
          children: [
            Text("Today’s Tasks", style: textWith16W600(ColorConstants.black)),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                await context.router.push(TaskRoute()).then((e) => getTasks());
              },
              child: Container(
                padding: EdgeInsets.all(6.sp),
                decoration: BoxDecoration(
                  color: ColorConstants.secondaryColor100,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "View All",
                  style: textWith10W600(ColorConstants.secondaryColor600),
                ),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        ListView.separated(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => 4.verticalSpace,
          shrinkWrap: true,
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            final item = state.tasks[index];
            return TaskCard(
              isActive: item.isCompleted,
              task: item,
            );
          },
        ),
      ],
    );
  }

  Widget serumStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Serum Status", style: textWith16W600(ColorConstants.black)),
        20.verticalSpace,
        SerumStatusWidget(remainingVal: 12, totalVal: 100),
      ],
    );
  }
}
