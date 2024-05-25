import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import 'column_or_row.dart';
import 'custom_list_tile.dart';



class CustomLiveList<T> extends StatefulWidget {
  const CustomLiveList({super.key, required this.list, this.isLoad = false, this.padding, this.endScroll,
    required this.onTap, this.isList = true, this.scrollController, required this.content});
  final List list;
  final Widget Function(T item) content;
  final Function(T item) onTap;
  final Function()? endScroll;
  final ScrollController? scrollController;
  final bool isList;
  final bool isLoad;
  final EdgeInsets? padding;

  @override
  State<CustomLiveList<T>> createState() => _CustomLiveListState<T>();
}

class _CustomLiveListState<T> extends State<CustomLiveList<T>> {

  bool load = false;

  listner() async {
    if(widget.scrollController!.position.atEdge){
      setState(() {
        load = true;
      });
      try {
        await widget.endScroll!();
      } catch (e) {}
      setState(() {
        load = false;
      });
    }
  }

  @override
  void initState() {
    if(widget.scrollController != null && widget.endScroll != null){
      widget.scrollController!.addListener(listner);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.scrollController != null && widget.endScroll != null){
      widget.scrollController!.removeListener(listner);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.isLoad ? Shimmer.fromColors(
        baseColor: context.watch<Config>().darkTemas ?  Colors.grey[800]! : Colors.grey.shade200,
        highlightColor: context.watch<Config>().darkTemas ?  Colors.grey[600]! : Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ColumnOrRow(
            isColumn: widget.isList, isWrap: true,
            children: List<Widget>.generate(6,
              (index) => SizedBox(
                width:  widget.isList ? null : 80,
                child: CustomListTile(
                    padding: widget.padding,
                    child: Container()
                ),
              )
            )
          ),
        ),
      ) : LayoutBuilder(
          builder: (_, constraints){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListOrGrid(
                      width: constraints.maxWidth,
                      itemCount: widget.list.length,
                      controller: widget.scrollController,
                      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                        final item = widget.list[index];
                        return FadeTransition(
                          opacity: Tween<double>(
                            begin: 0,
                            end: 1,
                          ).animate(animation),
                          child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: GestureDetector(
                                  onTap: (){
                                    widget.onTap(item);
                                  },
                                  child: CustomListTile(
                                      padding: widget.padding,
                                      child: widget.content(item)
                                  )
                              )
                          ),
                        );
                      },
                    ),
                  ),
                  if(load)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),)
                ],
              ),
            );
          }
      ),
    );
  }

  ListOrGrid({required Widget Function(BuildContext, int, Animation<double>) itemBuilder,
    ScrollController? controller, required double width, required int itemCount,
  }){
    return widget.isList ? LiveList(
      showItemInterval: const Duration(milliseconds: 0),
      showItemDuration: const Duration(milliseconds: 180),
      itemBuilder: itemBuilder, controller: controller,
      itemCount: itemCount,
    ) : LiveGrid(
      showItemInterval: const Duration(milliseconds: 0),
      showItemDuration: const Duration(milliseconds: 200),
      itemBuilder: itemBuilder, controller: controller,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width ~/ 170 ,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
