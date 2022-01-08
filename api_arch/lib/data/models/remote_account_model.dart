import 'package:api_arch/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accesstoken;

  RemoteAccountModel(this.accesstoken);

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(json['accessToken']);

  AccountEntity toEntity() => AccountEntity(accesstoken);
}
