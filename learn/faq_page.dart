import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/common_widgets/common_header.dart';
import '../../components/common_widgets/common_scaffold.dart';
import '../../components/common_widgets/focus_widget.dart';
import '../../components/learn/faq_tile.dart';

@RoutePage()
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHeader(heading: "FAQ’s"),
              16.verticalSpace,
              CommonContainer(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FaqTile(
                      heading: "When will I start seeing results?",
                      body:
                          "Yes, but apply the serum first and allow it to absorb before layering other products.",
                    );
                  },
                  separatorBuilder: (context, index) => 12.verticalSpace,
                  itemCount: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
