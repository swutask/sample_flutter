import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/app.dart';
import 'package:flutter_cubit/components/common_widgets/gradient_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/core/constants/image_constants.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/preference/preference_helper.dart';
import 'package:flutter_cubit/core/repository/auth/auth_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/di/injectable.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  void checkUserLoggedIn() async {
    final data = await PreferenceHelper.getUser();
    if (data != null) {
      await getIt<AuthRepository>().checkAndGenerateTasks();
      appRouter.replace(DashboardRoute());
    } else {
      appRouter.replace(LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: FocusWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [imageSizedBox()],
        ),
      ),
    );
  }

  Widget imageSizedBox() {
    return SizedBox(
      child: Image.asset(AppImages.appLogo, height: 52.h, width: 132.w),
    );
  }
}
