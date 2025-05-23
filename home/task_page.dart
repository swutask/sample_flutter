import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/application/home/task_cubit.dart';
import 'package:flutter_cubit/application/home/task_state.dart';
import 'package:flutter_cubit/components/common_widgets/common_header.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/common_widgets/common_loader.dart';
import '../../components/home/task_card.dart';

@RoutePage()
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    context.read<TaskCubit>().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return CommonScaffold(
          child: FocusWidget(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                CommonHeader(heading: "Task History"),
                20.verticalSpace,
                state.isLoading ? Expanded(child: Center(child: CommonLoader())) : body(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget body(TaskState state) {
    return ListView.separated(
      padding: EdgeInsets.zero,
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
    );
  }
}
