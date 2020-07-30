import 'package:dio/dio.dart';
import 'package:mobile/config/config.dart';
import 'package:mobile/models/auth_user.dart';
import 'package:mobile/models/elector.dart';
import 'package:mobile/models/info.dart';
import 'package:mobile/repository/api/api.dart';
import 'package:logger/logger.dart';
import 'package:mobile/repository/dto/login_response.dart';

class APIExtend extends API {
  Dio _dio;

  static const String BASE_URL = API_BASE_URL;

  APIExtend() : _dio = Dio();

  @override
  Future<LoginResponse> signIn(AuthUser user) {
    // Mock response
    return Future.delayed(Duration(seconds: 2))
        .then((value) => LoginResponse.just());

    return _dio
        .post(BASE_URL + "/auth/login", data: user.toMap())
        .then((response) => LoginResponse(response.data))
        .catchError((error) {
      Logger().e(error);
    });
  }

  @override
  Future<List<Info>> fetchMeta(String token, String election) {
    return _dio.get(BASE_URL + "/info/" + election).then((response) {
      List<dynamic> data = response.data as List;

      List<Info> _toReturn = data.map((meta) => Info.fromJson(meta)).toList();

      return _toReturn;
    }).catchError((error) {
      Logger().e(error);
      return List.from([Info.error()]);
    });
  }

  @override
  Future<List<Elector>> fetcElectors(String token, String election,
      String district, String division, String station) {
    return _dio
        .get(BASE_URL +
            "/electors/" +
            election +
            "/" +
            district +
            "/" +
            division +
            "/" +
            station)
        .then((response) {
      List<dynamic> data = response.data as List;

      List<Elector> _toReturn =
          data.map((elector) => Elector.fromJson(elector)).toList();

      return _toReturn;
    }).catchError((error) {
      Logger().e(error);
      return List.from([Elector.error()]);
    });
  }
}
