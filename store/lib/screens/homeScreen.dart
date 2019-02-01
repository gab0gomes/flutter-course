import 'package:flutter/material.dart';
import 'package:store/tabs/categoriesTab.dart';
import 'package:store/tabs/homeTab.dart';
import 'package:store/tabs/ordersTab.dart';
import 'package:store/tabs/placesTab.dart';
import 'package:store/widgets/cartButton.dart';
import 'package:store/widgets/customDrawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pageController = PageController();

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Categorias'),
            centerTitle: true,
          ),
          floatingActionButton: CartButton(),
          body: CategoriesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Lojas'),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Meus pedidos'),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}