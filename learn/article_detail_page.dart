import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/common_header.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/learn/article_container.dart';

@RoutePage()
class ArticleDetailPage extends StatefulWidget {
  final String image;
  final String heading;
  final String body;

  const ArticleDetailPage({
    super.key,
    required this.image,
    required this.heading,
    required this.body,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            CommonHeader(heading: "Article Detail"),
            16.verticalSpace,
            ArticleContainer(
              body: widget.body,
              heading: widget.heading,
              image: widget.image,
            ),
          ],
        ),
      ),
    );
  }
}
