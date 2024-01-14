import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
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
    );
  }
}
