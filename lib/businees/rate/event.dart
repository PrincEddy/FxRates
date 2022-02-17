import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fxrates/model/rate/rate.dart';

part 'event.freezed.dart';

@freezed
abstract class RateEvent with _$RateEvent {
  const factory RateEvent.loadRate()=LoadRate;
  const factory RateEvent.onError()= OnError;
  const factory RateEvent.rateLoaded(Rate rate)=RateLoaded;
  const factory RateEvent.rateUpdate(Rate rate)=RateUpdate;
}