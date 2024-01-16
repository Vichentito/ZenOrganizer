import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIdex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    switch (location) {
      case '/':
        return 0;
      case '/notes':
        return 1;
      case '/gastos':
        return 2;
      case '/plantas':
        return 3;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/notes');
        break;
      case 2:
        context.go('/gastos');
        break;
      case 3:
        context.go('/plantas');
        break;
      default:
        context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: getCurrentIdex(context),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: 'ToDo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notes_rounded), label: 'Notas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded), label: 'Gastos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.nature_rounded), label: 'Plantas'),
        ],
        onTap: (value) => onItemTapped(context, value));
  }
}
