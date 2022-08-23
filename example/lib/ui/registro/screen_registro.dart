import 'dart:async';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:shimmer/shimmer.dart';
import 'package:assecontservices/assecontservices.dart';

import '../../controller/hora/gethora.dart';
import '../camera/foto_screen.dart';




class RegistroScreen extends StatefulWidget {
 @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<RegistroScreen> {
  String txt = "Ponto Registrado com Sucesso";
  List<int>? img;

  @override
  void initState() {
    print('// TODO: implement initState');
    super.initState();
  }


/*  @override
  void initState() {
    super.initState();
    img = context.read<CameraManager>().img;
    mapa = GoogleMap(
        buildingsEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        myLocationButtonEnabled: false,
        tiltGesturesEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: context.read<Gps>().cam,
        onMapCreated: onMapCreated
    );
  }*/

  @override
  Widget build(BuildContext context) {
    dynamic data = DateFormat( 'EEEE d MMM y', 'pt_BR').format(DateTime.now()) ;
    double height = MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    img = context.read<CameraPontoManager>().img;

    return Scaffold(
          appBar: AppBar(
            title: const Text('Marcação de Ponto'),
            centerTitle: true,
            actions: [
              actions(context, registro: true),
            ],
          ),

          body: Container(
              height: height,
              child: SingleChildScrollView(
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Container(
                        height: height,
                        width: width,
                        child: Mapa(),
                      ),
                      Container(
                        height: 270,
                        decoration: BoxDecoration(
                            color: context.watch<Config>().darkTemas ?
                            Theme.of(context).primaryColor :
                            Config.corPribar,
                            borderRadius: const BorderRadius.only(
                              bottomRight: const Radius.circular(45),
                              bottomLeft: const Radius.circular(45),
                            )
                        ),
                        alignment: Alignment.topCenter,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: width * 0.6,
                                  padding: const EdgeInsets.only(left: 15, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Olá, ' + (context.read<UserPontoManager>().usuario?.nome ?? ''),
                                        maxLines: 1,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Config.corPri
                                        ),
                                      ),
                                      Text(context.read<UserPontoManager>().usuario?.cargo ?? '',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Config.corPri,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Hero(tag: "foto",
                                    child: GestureDetector(
                                      onTap: () async {
                                        List<int>? _img = await Navigator.push(context, MaterialPageRoute(
                                            builder: (context) =>
                                                ImageHero(img) ) );
                                        print(_img);
                                        if(_img != null ) {
                                          context.read<CameraPontoManager>().img = _img;
                                        }

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 115,
                                        width: 115,
                                        decoration: BoxDecoration(
                                            border: img != null ?
                                            Border.all(color: Config.corPri, width: 2) :
                                            Border.all(color: Colors.white, width: 5),
                                            borderRadius: BorderRadius.circular(100),
                                            color: Config.corPri,
                                            image: img != null ?
                                            DecorationImage(
                                                image: MemoryImage(Uint8List.fromList(img!)),
                                                fit: BoxFit.fitWidth
                                            ): null
                                        ),child: img == null ?
                                      const Icon(CupertinoIcons.person,
                                        color: Colors.white,
                                        size: 105,) : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Consumer<GetHora>(
                              builder: (_,hora,__){
                                return Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 20,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(bottom: 5), child:
                                      Text(data.toUpperCase().toString().replaceAll("-FEIRA", ""),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white,
                                            letterSpacing: 1
                                        ),
                                      ),
                                      ),

                                      Text(hora.horarioAtual,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 70, color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2
                                        ),
                                      ),
                                    ],),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],)
              )
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: context.watch<UserPontoManager>().regButtom ?
              Config.corPri.withOpacity(0.7) : Config.corPri,
              onPressed: context.watch<UserPontoManager>().regButtom ? null : () async {
                context.read<UserPontoManager>().regButtom = true;

                if(context.read<UserPontoManager>().usuario?.permitirLocalizacao ?? false){
                  await context.read<Gps>().localizacao();
                }
                double? lat = context.read<Gps>().locationData?.latitude;
                double? long = context.read<Gps>().locationData?.longitude;

                if(!(context.read<UserPontoManager>().usuario?.permitirLocalizacao ?? true)
                    || ((await context.read<Gps>().serviceEnabled)) ){
                  if(!(context.read<UserPontoManager>().usuario?.permitirLocalizacao ?? true)
                      || context.read<Gps>().locationData != null ){
                    await context.read<RegistroManger>().postPontoMarcar(
                      context, context.read<UserPontoManager>().usuario!, lat, long,
                    );


                  }else{
                    CustomAlert.info(
                        context: context,
                        mensage: 'Aguarde carregar o mapa!',
                    );
                  }

                }else{
                  Navigator.pop(context);
                  CustomAlert.info(
                      context: context,
                      mensage: 'Ative seu GPS!',
                  );
                }
                context.read<UserPontoManager>().regButtom = false;
              },
              label: Center(child: context.watch<UserPontoManager>().regButtom
                  ? Shimmer.fromColors(
                baseColor: context.watch<Config>().darkTemas ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: context.watch<Config>().darkTemas ? Colors.grey : Colors.white,
                child: const Text('AGUARDE..', style: const TextStyle(fontSize: 20, color: Colors.white),),
              ) : const Text('CONFIRMAR', style: TextStyle(fontSize: 20, color: Colors.white),))
          ),
        );
  }
}

class Mapa extends StatefulWidget {

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();


  onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  moveCam(BuildContext context, CameraPosition cam) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate?.newCameraPosition(cam));
  }

  @override
  void initState() {
    if (!Config.isIOS) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<Gps>(
      builder: (_, gps, __) {
        moveCam(context, gps.cam);

        return Container(
                padding: const EdgeInsets.only(top: 200),
                child: GoogleMap(
                    buildingsEnabled: false,
                    liteModeEnabled: !Config.isIOS,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    tiltGesturesEnabled: false,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: gps.cam,
                    onMapCreated: onMapCreated
                )
          );
      }
    );
  }
}
