String customButtonTemplate() {
  return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';
import '../../utils/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Widget? suffixIcon;
  final bool strech;
  final bool haveBorder;
  final Color borderColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppDimensions.radiusSmall)),
    this.suffixIcon,
    this.strech = true,
    this.haveBorder = false,
    this.borderColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: strech ? Get.context!.width : width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: .0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: haveBorder
                  ? BorderSide(color: borderColor)
                  : BorderSide.none),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (suffixIcon != null) SizedBox(),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor, fontSize: 16),
                ),
              ),
            ),
            if (suffixIcon != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  suffixIcon!,
                ],
              ),
          ],
        ),
      ),
    );
  }
}

''';
}
