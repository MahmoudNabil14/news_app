
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/layout/news_app/app_cubit/app_cubit.dart';
import 'package:news_app/layout/news_app/app_cubit/app_states.dart';
import 'package:news_app/layout/news_app/cubit/cubit.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/network/local/cache_helper/cache_helper.dart';
import 'package:news_app/shared/network/shared/dio_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'layout/news_app/news_layout.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  runApp(MyApp(isDark!=null ? isDark : isDark =false ));
}

class MyApp extends StatelessWidget {
   final bool isDark ;
  MyApp(this.isDark);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
    providers: [
    BlocProvider(
    create: (BuildContext context) => AppCubit()..ChangeAppTheme(fromShared: isDark),
    ),
    BlocProvider(
    create: (BuildContext context) => NewsCubit()..getBusiness(),
    ),
    ],
    child: BlocConsumer<AppCubit,AppStates>(
    listener: (context,state){},
    builder: (context,state){
    return  RefreshConfiguration(
      headerBuilder: () => WaterDropMaterialHeader(
        color: Colors.orange,
      ),        // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
      footerBuilder:  () => ClassicFooter(),        // Configure default bottom indicator
      headerTriggerDistance: 80.0,        // header trigger refresh trigger distance
      springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // custom spring back animate,the props meaning see the flutter api
      maxOverScrollExtent :100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
      maxUnderScrollExtent:0, // Maximum dragging range at the bottom
      enableScrollWhenRefreshCompleted: true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
      enableLoadingWhenFailed : true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
      hideFooterWhenNotFull: false, // Disable pull-up to load more functionality when Viewport is less than one screen
      enableBallisticLoad: true,
      child: MaterialApp(
      theme: ThemeData(
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      titleTextStyle: TextStyle(
      fontSize: 20.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      ),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(
      color: Colors.black
      ),
      ),
      textTheme: TextTheme(
      bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black
      )
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      ),
      ),
      darkTheme: ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(

        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      scaffoldBackgroundColor: HexColor('333739'),
      appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      titleTextStyle: TextStyle(
      fontSize: 20.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      ),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: HexColor('333739'),
      elevation: 0.0,
      iconTheme: IconThemeData(
      color: Colors.white
      ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
      bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white
      )
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: HexColor('333739'),
      ),
      ),
      themeMode: AppCubit.get(context).isDark ? ThemeMode.dark:ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: NewsApp(),
      ),
    );
    },
    ),
    );
  }
}
