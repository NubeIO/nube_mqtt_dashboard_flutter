import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/network/network_info.dart';
import '../exceptions.dart';

@injectable
class NetworkConnectionInterceptor extends Interceptor {
  final NetworkInfo networkInfo;

  NetworkConnectionInterceptor(this.networkInfo);

  @override
  Future onRequest(RequestOptions options) async {
    if (await networkInfo.isConnected) {
      return super.onRequest(options);
    }
    return DioError(request: options, error: ConnectionException());
  }
}
