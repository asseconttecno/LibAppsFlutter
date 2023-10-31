
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DrawerWebView extends StatefulWidget {
  Widget foto;
  String? titulo;
  List<Widget> children;

  DrawerWebView(this.children, this.foto, this.titulo, {Key? key}) : super(key: key);

  @override
  State<DrawerWebView> createState() => _DrawerWebViewState();
}

class _DrawerWebViewState extends State<DrawerWebView> {
  final GlobalKey<State<Tooltip>> keyTooltip = GlobalKey<State<Tooltip>>();


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: widget.foto,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Expanded(
          child: ListView(
            children: widget.children
          ),
        )
      ],
    );
  }
}
