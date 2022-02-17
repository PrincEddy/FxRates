import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fxrates/model/pair/pair.dart';

part 'rate.freezed.dart';

part 'rate.g.dart';

@freezed
abstract class Rate with _$Rate {
  factory Rate({
    @JsonKey(name: "TimeFrom", required: true, defaultValue: 0)
        required int timeFrom,
    @JsonKey(name: "TimeTo", required: true, defaultValue: 0)
        required int timeTo,
 @JsonKey(name: "pairs", required: false, defaultValue: [])
       required List<Pair> pairs,
  @JsonKey(name: "avgClose", required: false, defaultValue: ' ')
   required String avgClose,
    @JsonKey(name: "avgOpen", required: false, defaultValue: ' ')
    required String avgOpen,
   @JsonKey(name: "pair", required: false )
    Pair? latestPair,
    @JsonKey(name: "percent", required: false,defaultValue: '0')
    required String percent,
    @JsonKey(name: "pairStart", required: false )
    Pair? startPair,

  }) = _Rate;

  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);
}