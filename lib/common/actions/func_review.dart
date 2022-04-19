import 'package:flutter/material.dart';

import 'package:in_app_review/in_app_review.dart';

import '../../settintgs.dart';

funcReview(BuildContext context){
  final InAppReview inAppReview = InAppReview.instance;

  inAppReview.openStoreListing(appStoreId: Settings.appStoreId);
}