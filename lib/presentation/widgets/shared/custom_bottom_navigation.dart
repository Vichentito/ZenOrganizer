import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIdex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/notes/details/')) {
      return 1;
    }
    switch (location) {
      case '/':
        return 0;
      case '/notes':
        return 3;
      case '/finanzas':
        return 4;
      case '/finanzas/gastosfijos':
        return 4;
      case '/finanzas/config':
        return 4;
      case '/finanzas/quincenaDetails':
        return 4;
      case '/plantas':
        return 5;
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
        context.go('/rutines');
        break;
      case 2:
        context.go('/assistant');
        break;
      case 3:
        context.go('/notes');
        break;
      case 4:
        context.go('/finanzas');
        break;
      case 5:
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
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Rutinas'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Asistente'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notes_rounded), label: 'Notas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded), label: 'Finanzas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.nature_rounded), label: 'Plantas'),
        ],
        onTap: (value) => onItemTapped(context, value));
  }
}
