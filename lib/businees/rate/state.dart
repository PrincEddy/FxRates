import 'package:fxrates/model/rate/rate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class RateState with _$RateState {
  const factory RateState() = Initial;

  const factory RateState.loading() = Loading;

  const factory RateState.success(Rate rate) = Success;
  const factory RateState.loadUpdate(Rate rate)= LoadUpdate;
  const factory RateState.failure(String message) = Failure;
}