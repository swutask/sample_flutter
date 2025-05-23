import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/dashboard_cubit/dashboard_cubit.dart';
import 'package:flutter_cubit/application/dashboard_cubit/dashboard_cubit_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/core/constants/image_constants.dart';
import 'package:flutter_cubit/core/models/dashboard_helper_model.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/theme/app_colors.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<DashboardItem> icons = [
    DashboardItem(label: "Home", icon: AppIcons.homeIcon),
    DashboardItem(label: "Track", icon: AppIcons.trackIcon),
    DashboardItem(label: "Remind", icon: AppIcons.notificationsIcon),
    DashboardItem(label: "Learn", icon: AppIcons.bookIcon),
    DashboardItem(label: "Profile", icon: AppIcons.profileIcon),
  ];

  final List<PageRouteInfo> routes = [
    HomeRoute(),
    TrackerRoute(),
    RemindRoute(),
    LearnRoute(),
    ProfileRoute(),
  ];

  @override
  void initState() {
    context.read<DashboardCubit>().resetCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              // This ensures consistent background color during transitions
              scaffoldBackgroundColor: ColorConstants.white1,
              canvasColor: ColorConstants.white1,
            ),
            child: CommonScaffold(
              bottomNavBar: bottomBar(context, state),
              backgroundColor: ColorConstants.white1,
              child: AutoRouter(), // Key change here
            ),
          ),
        );
      },
    );
  }

  Widget bottomBar(BuildContext context, DashboardState state) {
    return Container(
      decoration: BoxDecoration(color: ColorConstants.gray100),
      child: SafeArea(
        child: Container(
          height: 62.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: ColorConstants.gray100),
          child: Row(
            children: List.generate(icons.length, (index) {
              final item = icons[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (state.currentIndex != index) {
                      context.read<DashboardCubit>().updateIndex(index);
                      context.router.replaceAll([routes[index]]);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item.icon,
                        height: 30.h,
                        width: 30.w,
                        color:
                            state.currentIndex == index
                                ? ColorConstants.primaryColor700
                                : ColorConstants.gray600,
                      ),
                      Text(
                        item.label,
                        style: textWith10W600(
                          state.currentIndex == index
                              ? ColorConstants.secondaryColor600
                              : ColorConstants.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
