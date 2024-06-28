
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config.dart';



class CustomButtom {

  static Widget custom({String? title, Function? onPressed, double? height,
    bool expand = false, Color? color, Color? borderColor, Widget? image, EdgeInsets? padding,
    IconData? icon, double? width, TextStyle? style, double radius = 8,}){

    return ChangeNotifierProvider(
      create: (BuildContext context) => LoadButtomProvider(),
      child: Consumer<LoadButtomProvider>(builder: (context, load, __) {
          return ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => states.any((e) =>
                        e == MaterialState.disabled || e == MaterialState.error)
                          ? (color ?? Config.corPri).withOpacity(0.8) : color ?? Config.corPri,
                ),
                padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
                      (Set<MaterialState> states) => padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                ),
                shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder?>(
                      (Set<MaterialState> states) => RoundedRectangleBorder(
                          side: BorderSide(color: borderColor ?? Colors.transparent), //the outline color
                          borderRadius: BorderRadius.all(Radius.circular(radius))),
                ),
                minimumSize: MaterialStateProperty.resolveWith<Size?>(
                      (Set<MaterialState> states) => const Size(0,0),
                ),
              ),
              onPressed: onPressed == null || load.isLoad ? null : () async {
                load.isLoad = true;
                try {
                  await onPressed();
                } finally {
                  load.isLoad = false;
                }
              },
              child: SizedBox(
                width: width,
                height: height,
                child: load.isLoad ? Row(
                  mainAxisSize: expand ? MainAxisSize.max:  MainAxisSize.min,
                  mainAxisAlignment: width != null && icon != null ?
                    MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: color == Colors.white ? Colors.grey : Colors.white,
                      highlightColor: Colors.grey[600]!,
                      child: title != null && title != '' ? Text(
                        width != null && width < 101 ? '...' : 'AGUARDE..',
                        textAlign: TextAlign.center, maxLines: 1,
                        style: style ?? TextStyle(
                            color: color == Colors.white ? Config.corPri : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ) : image ?? Padding(
                        padding: EdgeInsets.symmetric(horizontal: (title != null && title != '' ? 0 : 10)),
                        child: Icon(icon, size: 20,
                          color: color == Colors.white ? Config.corPri : Colors.white,),
                      ),
                    ),
                  ],
                ) : Row(
                  mainAxisSize: expand ? MainAxisSize.max:  MainAxisSize.min,
                  mainAxisAlignment: width != null && (icon != null || image != null) ?
                    MainAxisAlignment.start : MainAxisAlignment.center,
                  children:  [
                    if(icon != null || image != null)
                      image ?? Icon(icon, size: 20,
                        color: color == Colors.white ? Config.corPri : Colors.white,),
                    if(title != null && title != '')
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: (icon != null || width!= null ? 0 : 10)),
                            child: Text(title, textAlign: TextAlign.center, maxLines: 1,
                              style: style ?? TextStyle(
                                color: color == Colors.white ? Config.corPri : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              )
          );
        }
      )
    );
  }
}

class LoadButtomProvider extends ChangeNotifier {
  bool _isLoad = false;
  bool get isLoad => _isLoad;
  set isLoad(bool v) {
    try {
      _isLoad = v;
      notifyListeners();
    } catch (e) {
      // TODO
    }
  }
}