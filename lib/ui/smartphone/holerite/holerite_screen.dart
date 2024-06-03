
import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';


import '../../../common/common.dart';
import '../../../common/custom_filter.dart';
import '../../../common/custom_livelist.dart';
import '../../../helper/helper.dart';
import '../../../controllers/controllers.dart';
import '../../../model/holerite/holerite/holerite.dart';
import '../../ui.dart';
import 'detelhes_holerite.dart';

class HoleriteScreen extends StatefulWidget {

  @override
  _HoleriteScreenState createState() => _HoleriteScreenState();
}

class _HoleriteScreenState extends State<HoleriteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<HoleriteManager>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<HoleriteManager>(
        builder: (_, holerite, __){
          return CustomScaffold.custom(
              key: _scaffoldKey,
              context: context,
              height: 30,
              appTitle: 'Meus Holerites',
              body: Column(
                children: [
                  FilterWidget(
                    onFiltro: (filtro ) {
                      holerite.pageSize = filtro;
                    },
                    filtro: holerite.pageSize,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  Container(
                      child: !connectionStatus.hasConnection ?
                        Center(child: CustomText.text('Verifique sua Conexão com Internet')) :
                        CustomLiveList<DatumHolerite>(
                          scrollController: scrollController,
                          list: holerite.listHolerites,
                          isLoad: holerite.load,
                          content: (DatumHolerite item) {
                            return ListTile(
                              leading: Text('${item.attributes?.month ?? ''}\n${item.attributes?.year ?? ''}',
                                textAlign: TextAlign.center,),
                              title: Text(item.attributes?.type.toName ?? ''),
                              subtitle: Text(item.attributes?.data?.funcionarioResumo?.liquido?.real() ?? '0'),
                            );
                          },
                          onTap: (DatumHolerite item) {
                            CustomNavigator.routeClass(context, DetalhesHolerite(item));
                          },
                          endScroll: () async {
                            if(holerite.pageSize == 0 && ((holerite.holerites?.meta?.pagination?.pageCount ?? 0) < holerite.page)){
                              await holerite.newPageHolerite();
                            }
                          },
                        )
                  ),
                ],
              )
          );
        }
    );
  }
}