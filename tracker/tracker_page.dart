import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/tracker_cubit/tracker_cubit.dart';
import 'package:flutter_cubit/application/tracker_cubit/tracker_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/track/progress_timeline_widget.dart';
import 'package:flutter_cubit/components/track/upload_photo_widget.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/track/ai_widget.dart';
import '../../core/theme/app_colors.dart';

@RoutePage()
class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  @override
  void initState() {
    context.read<TrackerCubit>().initialState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backgroundColor: ColorConstants.white1,
      child: BlocBuilder<TrackerCubit, TrackerState>(
        builder: (context, state) {
          return FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hair Tracker",
                    style: textWith24W600(ColorConstants.black),
                  ),
                  20.verticalSpace,
                  UploadPhotoWidget(),
                  20.verticalSpace,
                  ProgressTimelineWidget(
                    onTapViewAll: (){
                      context.router.push(ProgressTimelineRoute());
                    },
                    showViewAll: true,
                    startDate: DateTime(2025, 5, 10),
                    endDate: DateTime(2025, 6, 31),
                  ),
                  20.verticalSpace,
                  AiWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
