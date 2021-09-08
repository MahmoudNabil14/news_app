import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_app/app_cubit/app_cubit.dart';
import 'package:news_app/layout/news_app/cubit/cubit.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';
import 'package:news_app/modules/search/search_screen.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/network/shared/dio_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsApp extends StatelessWidget {
  static bool searchState  = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder: (context,state){
        NewsCubit cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'News App'
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.search)
              ),
              IconButton(
                  onPressed: (){
                      AppCubit.get(context).ChangeAppTheme();
                  },
                  icon: Icon(Icons.brightness_4_outlined)
              ),

            ],
          ),
          body:  cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          onTap: (index){
            cubit.ChangeBottomNavBar(index);
          },
          items: cubit.bottomItems,
        ),
        );
      },

    );
  }
}
