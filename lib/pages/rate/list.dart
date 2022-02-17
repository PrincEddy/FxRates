import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fxrates/businees/rate/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fxrates/businees/rate/event.dart';
import 'package:fxrates/businees/rate/state.dart';
import 'package:fxrates/model/rate/rate.dart';

class ForexRateList extends StatefulWidget {
  const ForexRateList({Key? key}) : super(key: key);

  @override
  _ForexRateListState createState() => _ForexRateListState();
}

class _ForexRateListState extends State<ForexRateList> {
  Timer? timer;
  Rate? rate1;
  @override
  void initState() {
    context.read<RateBloc>().add(LoadRate());
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if(rate1!=null) {
        return context.read<RateBloc>().add(RateUpdate(rate1!));
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fx Rates"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        child: BlocBuilder<RateBloc, RateState>(builder: (context, state) {
          return state.when(() {
            return Container();
          }, loading: () {
            return LoadingWidget() ;
          }, success: (Rate rate) {
            rate1=rate;
            return RateItem(rate: rate);
          }, failure: (message) {
            return ErrorWidget(message: message);
          },loadUpdate: (Rate rate){
            return Column(
              children: [
                RateItem(rate: rate),
                SizedBox(height: 50.h,),
                LoadingWidget(title: "Updating BTC/USD Prices....",)
              ],
            );
          });
        }),
      ),
    );
  }
}




class RateItem extends StatelessWidget {

  const RateItem({Key? key,required this.rate,this.fade=false}) : super(key: key);
  final Rate rate;
  final bool fade;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TopCard(rate: rate),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PriceCard(icon: Icons.arrow_upward,title: "Latest Highest Price", color: Colors.green.withOpacity(fade?0.2:1), value: '\$ ${rate.latestPair!.high.toStringAsFixed(2)}',time: rate.latestPair!.time,),
            PriceCard(icon: Icons.arrow_downward,title: "Latest Lowest Price", color: Colors.red.withOpacity(fade?0.2:1), value: '\$ ${rate.latestPair!.low.toStringAsFixed(2)}',time: rate.latestPair!.time),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PriceCard(icon: Icons.open_in_full,title: "Average Open Price", color: Colors.teal.withOpacity(fade?0.2:1), value: '\$ ${rate.avgOpen}'),
            PriceCard(icon: Icons.close_fullscreen,title: "Average Close Price", color: Colors.deepOrange.withOpacity(fade?0.2:1), value: '\$ ${rate.avgClose}'),

          ],
        ),
      ],
    );
  }
}



class TopCard extends StatelessWidget {
  const TopCard({Key? key,required this.rate}) : super(key: key);
  final Rate rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(

                  child: Text("BTC/USD",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.w,
                      margin: EdgeInsets.only(right: 10.w,left: 20.w),
                      decoration: BoxDecoration(
                        shape:BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(rate.percent.startsWith('-')?Icons.arrow_downward:Icons.arrow_upward,color:rate.percent.startsWith('-')?Colors.red:Colors.green,size: 20.w,),
                    ),
                    Text("${rate.percent}%",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp
                    ),)
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape:BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.open_in_full,color:Colors.blue,size: 30.w,),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${DateTime.fromMillisecondsSinceEpoch(rate.timeFrom*1000).toLocal().toString().substring(0, 16)}",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.sp
                          ),),
                          SizedBox(height: 5.h,),
                          Text("\$ ${rate.startPair!.open.toStringAsFixed(2)}",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape:BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.close_fullscreen,color:Colors.blue,size: 30.w,),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${DateTime.fromMillisecondsSinceEpoch(rate.timeTo*1000).toLocal().toString().substring(0, 16)}",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.sp
                          ),),
                          SizedBox(height: 5.h,),
                          Text("\$ ${rate.latestPair!.close.toStringAsFixed(2)}",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


class PriceCard extends StatelessWidget {
  const PriceCard(
      {Key? key, required this.title, required this.color, required this.value,required this.icon,this.time=0})
      : super(key: key);
  final String title;
  final Color color;
  final String value;
  final IconData icon;
  final int time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190.w,
      height: 90.h,
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape:BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(icon,color: color,size: 30.w,),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$title",style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp
                    ),),
                    SizedBox(height: 5.h,),
                    Text("$value",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp
                    ),)
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible:time!=0,
              child: Container(
            margin: EdgeInsets.only(
              top: 5.h
            ),
            child:   Text("${DateTime.fromMillisecondsSinceEpoch(time*1000).toLocal().toString().substring(0, 16)}",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10.sp
            ),),
          ))
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key,this.title='Loading BTC/USD Prices....'}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: Colors.blue,
              size: 50.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key,required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200.h),
      child: Center(
        child: Column(
          children: [
            Text(
              "$message",
              style: TextStyle(color: Colors.red),
            ),
            TextButton(
                onPressed: () {
                  context.read<RateBloc>().add(LoadRate());
                },
                child: Text("Retry"))
          ],
        ),
      ),
    );
  }
}