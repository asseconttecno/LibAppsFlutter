import 'dart:async';
import 'dart:typed_data';

import '../../../services/camera/camera_manager.dart';
import '../../../services/gethora.dart';
import '../../../services/registro/gps.dart';
import '../../../services/registro/registro_manager.dart';
import '../../../services/usuario/users_manager.dart';
import '../../../settintgs.dart';
import '../../../ui/smartphone/camera/foto_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/actions/actions.dart';


class RegistroScreen extends StatelessWidget {
/*  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<RegistroScreen> {*/
  String txt = "Ponto Registrado com Sucesso";
  List<int>? img;



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
    img = context.read<CameraManager>().img;

    return Scaffold(
          appBar: AppBar(
            title: Text('Marcação de Ponto'),
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
                            color: context.watch<Settings>().darkTemas ?
                            Theme.of(context).primaryColor :
                            Settings.corPribar,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(45),
                              bottomLeft: Radius.circular(45),
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
                                  padding: EdgeInsets.only(left: 15, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Olá, ' + (context.read<UserManager>().usuario?.nome ?? ''),
                                        maxLines: 1,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Settings.corPri
                                        ),
                                      ),
                                      Text(context.read<UserManager>().usuario?.cargo ?? '',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Settings.corPri,
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
                                          context.read<CameraManager>().img = _img;
                                        }

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 115,
                                        width: 115,
                                        decoration: BoxDecoration(
                                            border: img != null ?
                                            Border.all(color: Settings.corPri, width: 2) :
                                            Border.all(color: Colors.white, width: 5),
                                            borderRadius: BorderRadius.circular(100),
                                            color: Settings.corPri,
                                            image: img != null ?
                                            DecorationImage(
                                                image: MemoryImage(Uint8List.fromList(img!)),
                                                fit: BoxFit.fitWidth
                                            ): null
                                        ),child: img == null ?
                                      Icon(CupertinoIcons.person,
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
                                  padding: EdgeInsets.only(top: 20,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(bottom: 5), child:
                                      Text(data.toUpperCase().toString().replaceAll("-FEIRA", ""),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white,
                                            letterSpacing: 1
                                        ),
                                      ),
                                      ),

                                      Text(hora.horarioAtual,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 70, color: Colors.white,
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
              backgroundColor: context.watch<UserManager>().regButtom ?
              Settings.corPri.withOpacity(0.7) : Settings.corPri,
              onPressed: context.watch<UserManager>().regButtom ? null : () async {
                context.read<UserManager>().regButtom = true;

                if(context.read<UserManager>().usuario?.permitirLocalizacao ?? false){
                  await context.read<Gps>().localizacao();
                }
                double? lat = context.read<Gps>().locationData?.latitude;
                double? long = context.read<Gps>().locationData?.longitude;

                if(!(context.read<UserManager>().usuario?.permitirLocalizacao ?? true) || ((await context.read<Gps>().serviceEnabled)) ){
                  if(!(context.read<UserManager>().usuario?.permitirLocalizacao ?? true) || context.read<Gps>().locationData != null ){
                    await context.read<RegistroManger>().postPontoMarcar(
                      lat, long,
                      sucess: () async {
                        print('sucess');
                        Navigator.pop(context);
                        SuccessAlertBox(
                            context: context,
                            title: 'Sucesso',
                            messageText: 'Marcação registrada!',
                            buttonText: 'ok'
                        );
                      },
                      error: (off) {
                        if(!off){
                          DangerAlertBox(
                              context: context,
                              title: 'Falha',
                              messageText: 'Marcação não registrada, tente novamente!',
                              buttonText: 'ok'
                          );
                        }else{
                          InfoAlertBox(
                              context: context,
                              title: 'Atenção',
                              infoMessage: 'Você não tem permissão para marca o ponto sem internet!',
                              buttonText: 'ok'
                          );
                        }
                      },
                    );
                  }else{
                    InfoAlertBox(
                        context: context,
                        title: 'Atenção',
                        infoMessage: 'Aguarde carregar o mapa!',
                        buttonText: 'ok'
                    );
                  }

                }else{
                  Navigator.pop(context);
                  InfoAlertBox(
                      context: context,
                      title: 'Atenção',
                      infoMessage: 'Ative seu GPS!',
                      buttonText: 'ok'
                  );
                }
                context.read<UserManager>().regButtom = false;
              },
              label: Center(child: context.watch<UserManager>().regButtom
                  ? Shimmer.fromColors(
                baseColor: context.watch<Settings>().darkTemas ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: context.watch<Settings>().darkTemas ? Colors.grey : Colors.white,
                child: Text('AGUARDE..', style: TextStyle(fontSize: 20, color: Colors.white),),
              ) : Text('CONFIRMAR', style: TextStyle(fontSize: 20, color: Colors.white),))
          ),
        );
  }
}

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

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
    if (defaultTargetPlatform == TargetPlatform.android) {
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
                padding: EdgeInsets.only(top: 200),
                child: GoogleMap(
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
                    initialCameraPosition: gps.cam,
                    onMapCreated: onMapCreated
                )
          );
      }
    );
  }
}
