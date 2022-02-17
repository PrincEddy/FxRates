



import 'package:dio/dio.dart';

class RateService {

 var options = BaseOptions(
   baseUrl: 'https://min-api.cryptocompare.com',
  connectTimeout: 5000,
  receiveTimeout: 3000,
 );
Future<Map<String,dynamic>>  get({String pair="BTCUSD",String resolution="minute"}) async {
   Dio dio = Dio(options);
   try {
    Response data = await dio.get(
        '/data/v2/histo$resolution?fsym=BTC&tsym=USD&limit=99&toTs=-1&api_key=91fea23150f8cf565ba7d90634df54e58de9f341bc8c4ed3157edc5f65b63d5b');
    if (data.statusCode == 200) {
     return data.data;
    } else {
      throw(data.statusMessage??"Unknown Error Please Try again!!!");
    }
   }on DioError catch(e){
     throw(e.message);
   }
  }
}