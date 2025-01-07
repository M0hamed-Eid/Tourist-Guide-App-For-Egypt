import 'package:flutter/material.dart';
import 'package:tourist_guide/core/theme/text_themes.dart';
import 'package:tourist_guide/core/utils/responsive_utils.dart';

class ProfileInfo extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String hashedPassword;

  const ProfileInfo(
      {super.key,
      required this.fullName,
      required this.email,
      required this.phone,
      required this.hashedPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveUtils.screenHeight(context) * 0.25,
      width: ResponsiveUtils.screenWidth(context),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: Colors.grey,
              maxRadius: 50,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            // Info
            Expanded(
              child: Column(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: AppTextTheme.textTheme.displaySmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    phone,
                    style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    email,
                    style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    hashedPassword,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
