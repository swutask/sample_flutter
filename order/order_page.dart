import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/components/common_widgets/common_scaffold.dart';
import 'package:flutter_cubit/components/common_widgets/custom_button.dart';
import 'package:flutter_cubit/components/common_widgets/custom_textfield.dart';
import 'package:flutter_cubit/components/common_widgets/focus_widget.dart';
import 'package:flutter_cubit/components/order/order_widget.dart';
import 'package:flutter_cubit/core/constants/image_constants.dart';
import 'package:flutter_cubit/core/utils/common_textstyles.dart';
import 'package:flutter_cubit/core/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';

@RoutePage()
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: FocusWidget(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeader(),
              12.verticalSpace,
              Text(
                "Order History",
                style: textWith24W600(ColorConstants.black),
              ),
              12.verticalSpace,
              ...List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: OrderWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            context.router.pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: ColorConstants.black,
            size: 30.sp,
          ),
        ),
        GestureDetector(
          onTap: () {
            showAddOrder();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor100,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: ColorConstants.primaryColor300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppIcons.addIcon, height: 24.h, width: 24.w),
                12.horizontalSpace,
                Text(
                  "Add Order",
                  style: textWith12W500(ColorConstants.primaryColor700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showAddOrder() {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          surfaceTintColor: ColorConstants.white1,
          backgroundColor: ColorConstants.primaryColor100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            height: 552.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: CustomTextField(
                    label: "Order ID",
                    labelColor: ColorConstants.gray700,
                    hintText: "e.g. #123456789",
                    validator: (e) => orderIDValidator(e),
                  ),
                ),
                20.verticalSpace,
                CustomButton(
                  text: "Add Order",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      context.pop();
                    }
                  },
                  backgroundColor: ColorConstants.primaryColor700,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
