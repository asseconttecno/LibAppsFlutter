import 'package:flutter/material.dart';

import 'package:in_app_review/in_app_review.dart';

import '../../config.dart';

funcReview(BuildContext context){
  final InAppReview inAppReview = InAppReview.instance;

  inAppReview.openStoreListing(appStoreId: Config.isIOS ? Config.conf.iosAppId : Config.conf.androidAppId);
}