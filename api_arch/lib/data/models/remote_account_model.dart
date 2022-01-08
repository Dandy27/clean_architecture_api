import '../../domain/entities/entities.dart';
import '../http/http_error.dart';

class RemoteAccountModel {
  final String accesstoken;

  RemoteAccountModel(this.accesstoken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(accesstoken);
}
