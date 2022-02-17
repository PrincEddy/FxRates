import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxrates/model/pair/pair.dart';
import 'package:fxrates/model/rate/rate.dart';
import 'package:fxrates/service/rate/RateService.dart';
import 'event.dart';
import 'state.dart';

class RateBloc extends Bloc<RateEvent,RateState> {
  RateService rateService = RateService();


  RateBloc() : super(RateState());

  @override
  Stream<RateState> mapEventToState(RateEvent event) {
    return event.when(loadRate: () async* {
        yield RateState.loading();
      yield*  mapLoadRateEventToState(event);

    }, onError: () async* {
      yield RateState.failure("Failed To Load Data");
    }, rateLoaded: (Rate rate) async* {
      yield RateState.success(rate);
    }, rateUpdate: (Rate rate) async* {
      yield RateState.loadUpdate(rate);
      yield*  mapLoadRateEventToState(event);
    });
  }
  Stream<RateState> mapLoadRateEventToState(RateEvent event) async* {
    try{
      Map<String,dynamic> data = await rateService.get();
      Rate rate = Rate.fromJson(data['Data']);
      double closeTotal = 0;
      double openTotal = 0;
      List pairJsonData = data['Data']['Data'];
      List<Pair> pairs = pairJsonData.map((e){
        Pair pair = Pair.fromJson(e);
        closeTotal+=pair.close;
        openTotal+=pair.open;
        return pair;
      }).toList();
    double percent =0;

      Pair pairOpen =pairs[0];
      pairs = pairs.reversed.toList();
      Pair pairClose = pairs[0];
      if(pairClose.close>=pairOpen.open){
        double difference = pairClose.close-pairOpen.open;
        percent = ((difference/pairOpen.open)*100);
      } else {
        double difference = pairOpen.open-pairClose.close;
        percent = (-(difference/pairClose.close)*100);
      }
      rate = rate.copyWith(
          pairs: pairs,
          latestPair: pairClose,
          startPair:pairOpen,
          percent: percent.toStringAsFixed(2),
          avgClose: (closeTotal/pairs.length).toStringAsFixed(2),
          avgOpen: (openTotal/pairs.length).toStringAsFixed(2),

      );
      yield RateState.success(rate);
    } catch (e){
      yield RateState.failure(e.toString());
    }

  }
}