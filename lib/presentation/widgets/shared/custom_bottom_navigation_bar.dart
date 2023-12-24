import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  const CustomBottomNavigationBar({super.key, required this.pageIndex});

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  int getCurrentIndex(BuildContext context) {
    return int.parse(GoRouterState.of(context).pathParameters['page'] ?? '0');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0,
        onTap: (value) => onItemTapped(context, value),
        currentIndex: getCurrentIndex(context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.label_outline), label: 'Categorías'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favoritos')
        ]);
  }
}
