import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/common_widgets/common_container.dart';
import '../../components/common_widgets/common_header.dart';
import '../../components/common_widgets/common_scaffold.dart';
import '../../components/common_widgets/focus_widget.dart';
import '../../components/learn/article_tile.dart';
import '../../core/constants/global_constants.dart';
import '../../core/models/article_helper.dart';

@RoutePage()
class RelatedArticlesPage extends StatefulWidget {
  const RelatedArticlesPage({super.key});

  @override
  State<RelatedArticlesPage> createState() => _RelatedArticlesPageState();
}

class _RelatedArticlesPageState extends State<RelatedArticlesPage> {
  @override
  Widget build(BuildContext context) {
    final newList = getList();
    return CommonScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHeader(heading: "Recent Articles"),
              16.verticalSpace,
              CommonContainer(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = newList[index];
                    return ArticleTile(
                      image: item.image,
                      heading: item.heading,
                      body: item.body,
                    );
                  },
                  separatorBuilder: (context, index) => 12.verticalSpace,
                  itemCount: newList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  List<ArticleHelper> getList() {
    final item = GlobalConstants.dummyArticles.first;
    return GlobalConstants.dummyArticles.where((e) => e != item).toList();
  }
}
