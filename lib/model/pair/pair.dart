import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair.freezed.dart';

part 'pair.g.dart';

@freezed
abstract class Pair with _$Pair {
const factory Pair({
    @JsonKey(name: "time", required: true, defaultValue: 0) required int time,
    @JsonKey(name: "high", required: true, defaultValue: 0.0)
        required double high,
    @JsonKey(name: "low", required: true, defaultValue: 0.0)
        required double low,
    @JsonKey(name: "open", required: true, defaultValue: 0.0)
        required double open,
    @JsonKey(name: "close", required: true, defaultValue: 0.0)
        required double close,
  }) = _Pair;

  factory Pair.fromJson(Map<String, dynamic> json) => _$PairFromJson(json);
}

///  {time: 1645018980, high: 43915.38, low: 43869.41, open: 43900.77, volumefrom: 20.5, volumeto: 899966.93, close: 43898.1, conversionType: direct, conversionSymbol: }