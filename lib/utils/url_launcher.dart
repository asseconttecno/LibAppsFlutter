

//import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {

  static openUrl(String url) async {
    try{
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }catch(e){
      debugPrint('catch UrlLauncher - openUrl - ' + e.toString());
    }
  }

/*  static openApp(String androidPackageName, String appStoreLink) async {
    try {
      await LaunchApp.openApp(
        androidPackageName: androidPackageName,  //'net.pulsesecure.pulsesecure',
        iosUrlScheme: 'pulsesecure://',
        appStoreLink: 'itms-apps://' + appStoreLink,  //'itms-apps://apps.apple.com/br/app/pernambucanas/id1225391849',
        openStore: true
      );
    }catch(e){
      debugPrint('catch UrlLauncher - openApp - ' + e.toString());
    }
  }*/

  static openUrlHttp(String url, {bool isHttps = true}) async {
    try {
      final Uri launchUri = Uri(
        scheme: isHttps ? 'https' : 'http:',
        path: url,
      );
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }catch(e){
      debugPrint('catch UrlLauncher - openUrlHttp - ' + e.toString());
    }
  }

  static openMail(String url) async {
    try {
      await launchUrl(Uri.parse('mailto:' + url));
    }catch(e){
      debugPrint('catch UrlLauncher - openMail - ' + e.toString());
    }
  }

  static openTel(String num) async {
    try {
      final Uri telLaunchUri = Uri(
        scheme: 'tel',
        path: num,
      );
      await launchUrl(telLaunchUri);
    }catch(e){
      debugPrint('catch UrlLauncher - openTel - ' + e.toString());
    }
  }

  static openSms(String num) async {
    try {
      final Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: num,
      );
      await launchUrl(smsLaunchUri);
    }catch(e){
      debugPrint('catch UrlLauncher - openSms - ' + e.toString());
    }
  }

  static openFile(String filePath) async {
    try {
      await launchUrl(Uri.file(filePath));
    } catch(e){
      debugPrint('catch UrlLauncher - openFile - ' + e.toString());
    }
  }
}
