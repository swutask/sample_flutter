import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/common_container.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/learn/article_container.dart';
import 'package:flutter_cubit/components/learn/article_tile.dart';
import 'package:flutter_cubit/components/learn/faq_tile.dart';
import 'package:flutter_cubit/core/constants/global_constants.dart';
import 'package:flutter_cubit/core/models/article_helper.dart';
import 'package:flutter_cubit/core/navigator/app_router.gr.dart';
import 'package:flutter_cubit/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app.dart';
import '../../core/utils/common_textstyles.dart';

@RoutePage()
class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final article = GlobalConstants.dummyArticles[0];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backgroundColor: ColorConstants.white1,
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Blog Articles",
                style: textWith24W600(ColorConstants.black),
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: () {
                  appRouter.push(
                    ArticleDetailRoute(
                      body: article.body,
                      heading: article.heading,
                      image: article.image,
                    ),
                  );
                },
                child: ArticleContainer(
                  body: article.body,
                  heading: article.heading,
                  image: article.image,
                ),
              ),
              20.verticalSpace,
              relatedArticles(),
              20.verticalSpace,
              faqWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget relatedArticles() {
    final newList = getList();
    return CommonContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Related Articles", style: textWith12W600(ColorConstants.black)),
          ListView.separated(
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
          CustomButton(
            text: "Read More",
            onTap: () {
              context.router.push(RelatedArticlesRoute());
            },
            height: 36.h,
            textStyle: textWith12W600(ColorConstants.primaryColor700),
            borderColor: ColorConstants.primaryColor700,
          ),
        ],
      ),
    );
  }

  Widget faqWidget() {
    return CommonContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("FAQ Section", style: textWith12W600(ColorConstants.black)),
          ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 12.h),
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
            itemCount: 4,
          ),
          CustomButton(
            text: "Read More",
            onTap: () {
              context.router.push(FaqRoute());
            },
            height: 36.h,
            textStyle: textWith12W600(ColorConstants.primaryColor700),
            borderColor: ColorConstants.primaryColor700,
          ),
        ],
      ),
    );
  }

  List<ArticleHelper> getList() {
    final item = GlobalConstants.dummyArticles.first;
    return GlobalConstants.dummyArticles.where((e) => e != item).toList();
  }
}
