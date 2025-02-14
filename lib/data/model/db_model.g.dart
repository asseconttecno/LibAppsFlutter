// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDBAdapter extends TypeAdapter<UserDB> {
  @override
  final int typeId = 0;

  @override
  UserDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDB(
      databaseId: fields[19] as int?,
      cpf: fields[0] as String?,
      funcionarioId: fields[1] as int?,
      nome: fields[2] as String?,
      registro: fields[3] as String?,
      cargo: fields[4] as String?,
      foto: fields[5] as String?,
      email: fields[6] as String?,
      pis: fields[7] as String?,
      permitirMarcarPontoWeb: fields[8] as bool?,
      permitirMarcarPonto: fields[9] as bool?,
      permitirMarcarPontoOffline: fields[10] as bool?,
      capturarGps: fields[11] as bool?,
      ultimaMarcacao: fields[12] as DateTime?,
      setorId: fields[13] as int?,
      cnpj: fields[14] as String?,
      dataInicial: fields[15] as DateTime?,
      dataFinal: fields[16] as DateTime?,
      descricaoPeriodo: fields[17] as String?,
      app: fields[18] as bool?,
      senha: fields[20] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDB obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.cpf)
      ..writeByte(1)
      ..write(obj.funcionarioId)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.registro)
      ..writeByte(4)
      ..write(obj.cargo)
      ..writeByte(5)
      ..write(obj.foto)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.pis)
      ..writeByte(8)
      ..write(obj.permitirMarcarPontoWeb)
      ..writeByte(9)
      ..write(obj.permitirMarcarPonto)
      ..writeByte(10)
      ..write(obj.permitirMarcarPontoOffline)
      ..writeByte(11)
      ..write(obj.capturarGps)
      ..writeByte(12)
      ..write(obj.ultimaMarcacao)
      ..writeByte(13)
      ..write(obj.setorId)
      ..writeByte(14)
      ..write(obj.cnpj)
      ..writeByte(15)
      ..write(obj.dataInicial)
      ..writeByte(16)
      ..write(obj.dataFinal)
      ..writeByte(17)
      ..write(obj.descricaoPeriodo)
      ..writeByte(18)
      ..write(obj.app)
      ..writeByte(19)
      ..write(obj.databaseId)
      ..writeByte(20)
      ..write(obj.senha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
