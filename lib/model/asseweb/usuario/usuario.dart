

import 'dart:ffi';

import 'package:assecontservices/assecontservices.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class UsuarioAsseweb {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? ddd;
  String? password;
  DateTime? lastAcess;
  DateTime? birthday;
  String? version;
  DateTime? resignation;
  String? uid;
  Bool? master;
  List<Companies>? companies;

  UsuarioAsseweb({this.id, this.name, this.email, this.phoneNumber, this.ddd, this.password, this.lastAcess, this.birthday, this.version,
    this.resignation, this.uid, this.master, this.companies});

    UsuarioAsseweb copyWith({

    int? id, String? name, String? email, String? phoneNumber, String? ddd, String? password, DateTime? lastAcess, DateTime? birthday,
      String? version, DateTime? resignation, String? uid, Bool? master, List<Companies>? companies

  }) => UsuarioAsseweb(

                id: id ?? this.id,
                name: name ?? this.name,
                email: email ?? this.email,
                phoneNumber: phoneNumber ?? this.phoneNumber ,
                ddd: ddd ?? this.ddd ,
                password: password ?? this.password,
                lastAcess: lastAcess ?? this.lastAcess,
                birthday: birthday ?? this.birthday,
                version: version ?? this.version,
                resignation: resignation ?? this.resignation,
                uid: uid ?? this.uid,
                master: master ?? this.master,
                companies: companies ?? this.companies


  );



  UsuarioAsseweb.fromMap(Map map){
    this.id =   map["id"] == null ? null : map["id"];
    this.name = map["name"] == null ? null : map["name"];
    this.email = map["email"] == null ? null : map["email"];
    this.phoneNumber = map["phoneNumber"] == null ? null : map["phoneNumber"];
    this.ddd = map["ddd"] == null ? null : map["ddd"];
    this.password = map["password"] == null ? null : map["password"];
    this.lastAcess = map["lastAcess"] == null ? null : map["lastAcess"];
    this.birthday = map["birthday"] == null ? null : map["birthday"];
    this.version = map["version"] == null ? null : map["version"];
    this.resignation = map["resignation"] == null ? null : map["resignation"];
    this.uid = map["uid"] == null ? null : map["uid"];
    this.master = map["master"] == null ? null : map["master"];
    this.companies = map["companies"] == null ? null : map["companies"].map((e) => Companies.fromMap(e)).toList();

  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'ddd': ddd,
      'password': password,
      'lastAcess': lastAcess,
      'birthday': birthday,
      'version': version,
      'resignation': resignation,
      'uid': uid,
      'master': master,
      'companies': companies,

    };
  }
}

class Companies{
  int? id;
  String? number;
  String? name;
  String? fantasyName;
  String? cnpj;

  Companies({this.id, this.number, this.name, this.fantasyName, this.cnpj});

  Companies copyWith({
    int? id, String? number, String? name, String? fantasyName, String? cnpj
  }) => Companies(

        id: id ?? this.id,
        number: number ?? this.number,
        name: name ?? this.name,
        fantasyName: fantasyName ?? this.fantasyName,
        cnpj: cnpj ?? cnpj ?? this.cnpj,
  );

  Companies.fromMap(Map map){

    this.id = map["id"] == null ? null : map["id"];
    this.number = map["number"] == null ? null : map["number"];
    this.name = map["name"] == null ? null : map["name"];
    this.fantasyName = map["fantasyName"] == null ? null : map["fantasyName"];
    this.cnpj = map["cnpj"] == null ? null : map["cnpj"];

  }
}