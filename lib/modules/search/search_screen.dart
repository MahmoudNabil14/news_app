import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:news_app/layout/news_app/cubit/cubit.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/components/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatelessWidget {
  RefreshController searRefreshController = RefreshController(initialRefresh: false);
  static var searchController = TextEditingController();
   late var search_list ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
         search_list = NewsCubit.get(context).search;
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                    Navigator.pop(context);
                    searchController.text= '';
                    NewsCubit.get(context).search =[];
                  },

              ),
            ),
            body: Column(
              children:[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0 , horizontal: 20.0),
                  child: defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      onChanged: (String value){

                      },
                      onSubmit: (String value){
                        if (value == '' ){
                          NewsCubit.get(context).search =[];
                          NewsCubit.get(context).emit(NewsGetSearchLoadingState());
                        }
                        else {
                          NewsCubit.get(context).getSearch(value);
                        }
                      },
                      validate: (){},
                      label: 'Search',
                      prefix: Icons.search ),
                  ),
                Expanded(
                    child: Conditional.single(
                      context: context,
                      conditionBuilder: (BuildContext context) => search_list.length>0,
                      widgetBuilder: (context) => SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: WaterDropMaterialHeader(
                        backgroundColor: Colors.orange,
                        color: Colors.white,
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("pull up load");
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("release to load more");
                          } else {
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: searRefreshController,
                      onRefresh: (){
                        Future.delayed(Duration(milliseconds: 2000));
                        NewsCubit.get(context).search = [];
                        search_list = [];
                        NewsCubit.get(context).getSearch(searchController.text);
                        NewsCubit.get(context).emit(NewsRefreshSearchState());
                        searRefreshController.refreshCompleted();
                      },
                      onLoading: (){
                        Future.delayed(Duration(milliseconds: 2000));
                        searRefreshController.loadComplete();
                      },
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              buildArticleItem(search_list[index], context),
                          separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  height: 1,
                                  color: Colors.grey[300],
                                  width: double.infinity,
                                ),
                              ),
                          itemCount: search_list.length),
                    ),
                    fallbackBuilder: (context) => Center(child: CircularProgressIndicator(),),
                  ),
                ),
              ],
            ),
          );
        });

  }
}
