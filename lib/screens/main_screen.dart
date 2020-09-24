import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/cart.dart';
import 'package:restaurant_ui_kit/screens/favorite_screen.dart';
import 'package:restaurant_ui_kit/screens/home.dart';
import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:restaurant_ui_kit/screens/profile.dart';
import 'package:restaurant_ui_kit/screens/search.dart';
import 'package:restaurant_ui_kit/util/cartModel.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/util/foodsInCart.dart';
import 'package:restaurant_ui_kit/widgets/badge.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  PageController _pageController;
  int _page = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            Constants.appName,
          ),
          elevation: 0.0,
          actions: <Widget>[
           Consumer<CartModel>(
             builder: (context,cartModel,child){
               return IconButton(
                 icon: IconBadge(
                   icon:Icons.shopping_cart,
                   size: 24.0,
                   count: cartModel.quantity,
                 ),
                 color: _page == 3
                     ? Theme.of(context).accentColor
                     : Theme
                     .of(context)
                     .textTheme.caption.color,
                 onPressed: (){
                   Navigator.of(context).push(
                     MaterialPageRoute(
                       builder: (BuildContext context) {
                         return CartScreen(cartModel: cartModel);
                         // return DishesScreen(foods: foods,cart: widget.cart,);
                       },
                     ),
                   );
                 },
               );
             },
           ),
            // IconButton(
            //   icon: IconBadge(
            //     icon: Icons.notifications,
            //     size: 22.0,
            //     count: 0,
            //   ),
            //   onPressed: (){
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context){
            //           return Notifications();
            //         },
            //       ),
            //     );
            //   },
            //   tooltip: "Notifications",
            // ),
          ],
        ),

        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            // Home(cart: cart,),
            Home(),
            FavoriteScreen(),
            SearchScreen(),
            Consumer<CartModel>(
                builder: (context,cartModel,child){
                  return CartScreen(cartModel: cartModel);
                }
            ),
            Profile(),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width:7),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 24.0,
                ),
                color: _page == 0
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(0),
              ),

              IconButton(
                icon:Icon(
                  Icons.favorite,
                  size: 24.0,
                ),
                color: _page == 1
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(1),
              ),

              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 24.0,
                  // color: Theme.of(context).primaryColor,
                ),
                color: _page == 2
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(2),
              ),

              // IconButton(
              //   icon: Icon(
              //     Icons.shopping_cart,
              //     size: 24.0,
              //   ),
              //   color: _page == 3
              //       ? Theme.of(context).accentColor
              //       : Theme
              //       .of(context)
              //       .textTheme.caption.color,
              //   onPressed: ()=>_pageController.jumpToPage(3),
              // ),

              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                color: _page == 4
                    ? Theme.of(context).accentColor
                    : Theme
                    .of(context)
                    .textTheme.caption.color,
                onPressed: ()=>_pageController.jumpToPage(4),
              ),

              SizedBox(width:7),
            ],
          ),
          color: Theme.of(context).primaryColor,
          shape: CircularNotchedRectangle(),
        ),
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   elevation: 4.0,
        //   child: Icon(
        //     Icons.search,
        //   ),
        //   onPressed: ()=>_pageController.jumpToPage(2),
        // ),

      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
