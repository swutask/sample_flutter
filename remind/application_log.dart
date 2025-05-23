import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_header.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/remind/application_log_card.dart';

@RoutePage()
class ApplicationLogPage extends StatefulWidget {
  const ApplicationLogPage({super.key});

  @override
  State<ApplicationLogPage> createState() => _ApplicationLogPageState();
}

class _ApplicationLogPageState extends State<ApplicationLogPage> {
  final List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().subtract(Duration(days: 3)),
    DateTime.now().subtract(Duration(days: 4)),
    DateTime.now().subtract(Duration(days: 5)),
    DateTime.now().subtract(Duration(days: 6)),
    DateTime.now().subtract(Duration(days: 7)),
    DateTime.now().subtract(Duration(days: 8)),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            CommonHeader(heading: "Daily Log History"),
            20.verticalSpace,
            getBody(),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return CommonContainer(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = dates[index];
          return ApplicationLogCard(date: item);
        },
        separatorBuilder: (context, index) => 12.verticalSpace,
        itemCount: dates.length,
      ),
    );
  }
}
