import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/common_header.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/track/progress_timeline_widget.dart';

@RoutePage()
class ProgressTimelinePage extends StatefulWidget {
  const ProgressTimelinePage({super.key});

  @override
  State<ProgressTimelinePage> createState() => _ProgressTimelinePageState();
}

class _ProgressTimelinePageState extends State<ProgressTimelinePage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            CommonHeader(heading: "Timeline History"),
            20.verticalSpace,
            body(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ProgressTimelineWidget(
            showViewAll: false,
            startDate: DateTime(2025, 5, 10),
            endDate: DateTime(2025, 6, 31),
          );
        },
        separatorBuilder: (context, index) {
          return 16.verticalSpace;
        },
        itemCount: 4,
      ),
    );
  }
}
