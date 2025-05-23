import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/common_widgets/gradient_scaffold.dart';
import 'package:flutter_cubit/core/theme/app_colors.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class InfoPage extends StatefulWidget {
  final Widget button;
  final String headingIcon;
  final String heading;
  final String body;

  const InfoPage({
    super.key,
    required this.button,
    required this.headingIcon,
    required this.heading,
    required this.body,
  });

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.headingIcon,
              style: textWith20W500(ColorConstants.white1),
            ),
            4.verticalSpace,
            Text(widget.heading, style: textWith24W600(ColorConstants.white1)),
            8.verticalSpace,
            Text(
              widget.body,
              textAlign: TextAlign.center,
              style: textWith12W400(Colors.white),
            ),
            24.verticalSpace,
            widget.button,
          ],
        ),
      ),
    );
  }
}
