import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth_android/local_auth_android.dart';

import '../enums/enums.dart';
import '../config.dart';

class BiometriaServices {
  final LocalAuthentication localAuth = LocalAuthentication();

  void supportedBio() {
    if(!Config.isWin){
      try{
        localAuth.isDeviceSupported().then((isSupported) {
          debugPrint('Biometria suportado: $isSupported');
          Config.bioState = isSupported ? BioSupportState.supported : BioSupportState.unsupported;
        });
      }catch (e){
        debugPrint(e.toString());
      }
    }
  }


  Future<bool> checkBio() async {
    if(Config.bioState == BioSupportState.supported) {
      try {
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;
        debugPrint('Tem biometria cadastrada: $canCheckBiometrics');
        if (canCheckBiometrics) {
          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          debugPrint('Lista de biometria cadastrada: $availableBiometrics.isNotEmpty');
          if (availableBiometrics.isNotEmpty) {
            return true;
          } 
        } 
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return false;
  }

  Future<bool> authbiometria() async {
    if(Config.bioState == BioSupportState.supported){
      bool didAuthenticate = false;
      try{
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;
        if(canCheckBiometrics){

          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if (availableBiometrics.isNotEmpty){
            const iosStrings =  IOSAuthMessages(
                cancelButton :  'Cancelar' ,
                goToSettingsButton :  'Configurações' ,
                goToSettingsDescription :  'Configure seu ID' ,
                lockOut :  ' Reative seu ID' );

            const andStrings = AndroidAuthMessages(
              cancelButton: 'Cancelar',
              goToSettingsButton: 'Ir para definir',
              biometricNotRecognized: 'Falha ao autenticar',
              goToSettingsDescription: 'Por favor, defina sua autenticação.',
              biometricHint: '',
              biometricSuccess: 'Autenticado com Sucesso',
              signInTitle: 'Aguardando..',
              biometricRequiredTitle: 'Realize sua autenticação',
            );

            didAuthenticate = await localAuth.authenticate(
                localizedReason: 'Por favor autentique-se para continuar',
                authMessages: [
                  iosStrings,
                  andStrings,
                ],
                options: const AuthenticationOptions(
                  useErrorDialogs: true,
                  stickyAuth: true,
                  sensitiveTransaction: false,
                  biometricOnly: false,
                ),
            );
          }
        }
        return didAuthenticate;
      }catch(e){
        debugPrint(e.toString());
      }
    }
    return false;
  }
}