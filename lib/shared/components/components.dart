
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:news_app/layout/news_app/cubit/cubit.dart';
import 'package:news_app/layout/news_app/news_layout.dart';
import 'package:news_app/modules/web_view_screen/web_view_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
Widget buildArticleItem(article,context) =>
    InkWell(
      splashColor: Colors.orange,
      onTap: (){
        navigateTo(context, WebViewScreen(article['url']),);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage'] == null ?
                  'https://im-media.voltron.voanews.com/Drupal/01live-166/styles/sourced/s3/2020-04/ap_paper.jpg?itok=pevRrI3j' :article['urlToImage'] }'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            '${article['title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

      ),
    );
Widget articleBuilder (list,context,{
  isSearch = false ,
})=> Conditional.single(
  context: context,
  conditionBuilder: (BuildContext context) => list.length>0,
  widgetBuilder: (context) => SmartRefresher(
    enablePullDown: true,
    enablePullUp: false,
    header: WaterDropMaterialHeader(
      backgroundColor: Colors.orange,
      color: Colors.white,
    ),
    footer: CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
      Widget body ;
      if(mode==LoadStatus.idle){
        body =  Text("pull up load");
      }
      else if(mode==LoadStatus.loading){
        body =  CupertinoActivityIndicator();
      }
      else if(mode == LoadStatus.failed){
        body = Text("Load Failed!Click retry!");
      }
      else if(mode == LoadStatus.canLoading){
        body = Text("release to load more");
      }
      else{
        body = Text("No more Data");
      }
      return Container(
        height: 55.0,
        child: Center(child:body),
      );
    },),
    controller: NewsCubit.get(context).currentIndex == 0 ? NewsCubit.get(context).busiRefreshController :
    NewsCubit.get(context).currentIndex == 1 ? NewsCubit.get(context).sporRefreshController
        :NewsCubit.get(context).currentIndex == 2 ? NewsCubit.get(context).scieRefreshController:
    NewsCubit.get(context).healRefreshController,
    onRefresh: NewsCubit.get(context).onRefresh,
    onLoading: NewsCubit.get(context).onLoading,
    child: ListView.separated(
        physics: BouncingScrollPhysics() ,
        itemBuilder: (context,index) => buildArticleItem(list[index],context),
        separatorBuilder: (context,index) => Padding(
          padding: EdgeInsets.symmetric( horizontal: 20.0 ),
          child: Container(
            height: 1,
            color: Colors.grey[300],
            width: double.infinity,
          ),
        ),
        itemCount: list.length),
  ),
  fallbackBuilder: (context) => Center(child: CircularProgressIndicator(),),
);
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String label,
  required IconData prefix ,
  Function? onChanged,
  Function? onSubmit,
  IconData? suffix ,
  Function? suffixPressed,
  Function? onTap,
  bool obscure = false,
  bool isClickable = true,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: obscure,
  enabled: isClickable,
  onChanged: (String value){
    return onChanged!(value);
  },
  onFieldSubmitted: (String value){
    return onSubmit!(value);
  },
  // onTap: (){
  //   return onTap!();
  // },
  decoration: InputDecoration(
    prefixIcon: Icon(
      prefix,
    ),
    labelText: label,
    suffixIcon: suffix!=null ? IconButton(icon: Icon(suffix), onPressed: (){suffixPressed!();} ): null,
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10.0)
    ),

  ),

  validator: (s){
    return validate(s);
  },
);

void navigateTo(context,widget){
Navigator.push(context,MaterialPageRoute(builder: (context)=> widget));
}
