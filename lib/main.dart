import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fxrates/pages/rate/list.dart';

import 'businees/rate/bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return  ScreenUtilInit(
        designSize: Size(414, 736),
        builder: () =>MultiBlocProvider(
          providers: [
            BlocProvider<RateBloc>(create: (_) => RateBloc()),
          ],
          child: MaterialApp(
            title: "Fx Rates",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
           //   primarySwatch:primaryColor,
            ),
            home:ForexRateList(),
          ),
        )
    );

  }
}