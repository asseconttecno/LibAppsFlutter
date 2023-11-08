

import 'package:assecontservices/assecontservices.dart';
import 'package:flutter/material.dart';

class TutorController {
  List<TutorialItens> itens = [];

  final GlobalKey<PopupMenuButtonState<int>> keyMenu = GlobalKey();
  final GlobalKey keyMenu1 = GlobalKey();
  final GlobalKey keyMenu2 = GlobalKey();
  final GlobalKey keyMenu3 = GlobalKey();
  final GlobalKey keyMenu4 = GlobalKey();
  final GlobalKey keyMenu5 = GlobalKey();
  final GlobalKey keyResumo = GlobalKey();
  final GlobalKey keyListMenu = GlobalKey();
  final GlobalKey keyRegistro = GlobalKey();

  init(BuildContext context){
    itens.addAll({
      TutorialItens(
          globalKey: keyMenu1,
          touchScreen: true,
          top: WidgetsBinding.instance.window.padding.top,
          left: 10,
          right: 180,
          children: [
            Container(
              color: Colors.black54,
              child: CustomText.text(
                "Nesse menu é possível alterar o período para consultas.",
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
          widgetNext: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black12,
            child: CustomText.text(
              "Continuar",
              style: const TextStyle(
                color: Config.corPri,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shapeFocus: ShapeFocus.square),
      TutorialItens(
          globalKey: keyMenu2,
          touchScreen: true,
          top: 30 + (WidgetsBinding.instance.window.padding.top),
          left: 10,
          right: 180,
          children: [
            Container(
              color: Colors.black54,
              child: CustomText.text(
                "Nesse menu é possível alterar a senha do usuário.",
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
          widgetNext: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black12,
            child: CustomText.text(
              "Continuar",
              style: const TextStyle(
                color: Config.corPri,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
            ),
          ),
          shapeFocus: ShapeFocus.square),
      TutorialItens(
          globalKey: keyMenu3,
          touchScreen: true,
          top: 60 + (WidgetsBinding.instance.window.padding.top),
          left: 10,
          right: 180,
          children: [
            Container(
              color: Colors.black54,
              child: CustomText.text(
                "Nesse menu é possível verificar versão do app, alterar modo escuro e autenticação.",
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
          widgetNext: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black12,
            child: CustomText.text(
              "Continuar",
              style: const TextStyle(
                color: Config.corPri,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shapeFocus: ShapeFocus.square),
      if (!Config.isWin)
        TutorialItens(
            globalKey: keyMenu4,
            touchScreen: true,
            top: 120 + (WidgetsBinding.instance.window.padding.top),
            left: 10,
            right: 180,
            children: [
              Container(
                color: Colors.black54,
                child: CustomText.text(
                  "Nesse menu é possível avaliar o app na loja.",
                  softWrap: true,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
            widgetNext: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: CustomText.text(
                "Continuar",
                style: const TextStyle(
                  color: Config.corPri,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            shapeFocus: ShapeFocus.square),
      TutorialItens(
          globalKey: keyMenu5,
          touchScreen: true,
          top: 160 + (WidgetsBinding.instance.window.padding.top),
          left: 10,
          right: 180,
          children: [
            Container(
              color: Colors.black54,
              child: CustomText.text(
                "Nesse menu é possível deslogar do usuário atual.",
                softWrap: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
          widgetNext: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black12,
            child: CustomText.text(
              "Continuar",
              style: const TextStyle(
                color: Config.corPri,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shapeFocus: ShapeFocus.square),
      TutorialItens(
        globalKey: keyListMenu,
        touchScreen: true,
        bottom: 100,
        right: 0,
        left: 0,
        children: [
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
            child: Center(
              child: CustomText.text(
                "Lista de menu deslizável na horizontal.",
                softWrap: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
        widgetNext: Container(
          padding: const EdgeInsets.all(5),
          //margin: EdgeInsets.only(right: 30),
          color: Colors.black12,
          child: CustomText.text(
            "Continuar",
            style: const TextStyle(
              color: Config.corPri,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        shapeFocus: ShapeFocus.square,
      ),
      TutorialItens(
        globalKey: keyResumo,
        touchScreen: true,
        top: 300,
        right: 0,
        left: 0,
        children: [
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            child: Center(
              child: CustomText.text(
                "Resumo dos resultados do período.",
                softWrap: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
        widgetNext: Container(
          padding:
          const EdgeInsets.all(5), //margin: EdgeInsets.only(right: 30),
          color: Colors.black12,
          child: CustomText.text(
            "Continuar",
            style: const TextStyle(
              color: Config.corPri,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        shapeFocus: ShapeFocus.square,
      ),
      TutorialItens(
        globalKey: keyRegistro,
        touchScreen: true,
        bottom: 220,
        right: 20,
        left: 20,
        children: [
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.only(top: 20, bottom: 20, right: 50),
            child: Center(
              child: CustomText.text(
                "Clicando em Registrar é possível realizar a marcação de ponto.",
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
        widgetNext: Container(
          padding:
          const EdgeInsets.all(5), //margin: EdgeInsets.only(right: 30),
          color: Colors.black12,
          child: CustomText.text(
            "Sair",
            style: const TextStyle(
              color: Config.corPri,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      ),
    });

    keyStatus(context);
  }

  void keyStatus(BuildContext context) async {
    Future.delayed(const Duration(microseconds: 200)).then((value) async {
      keyMenu.currentState?.showButtonMenu();
      Future.delayed(const Duration(seconds: 1)).then((value) async {
        Tutorial.showTutorial(context, itens, (v) {
          if (v == (Config.isWin ? 3 : 4) &&
              (keyMenu.currentState?.mounted ?? false)) {
            //keyMenu.currentState!.showButtonMenu();
            Navigator.pop(
              keyMenu.currentState!.context,
            );
          } else if (v == (Config.isWin ? 5 : 6)) {
            Config().priacesso();
          } else if (v == (Config.isWin ? 6 : 7)) {
            BiometriaAlert(context);
            itens.clear();
          }
        });
      });
    });
  }


}