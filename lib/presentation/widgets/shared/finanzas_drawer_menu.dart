import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinanzasDrawerMenu extends StatelessWidget {
  const FinanzasDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Finanzas Menú',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Quincenas'),
            onTap: () {
              context.go('/finanzas');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Gastos Fijos'),
            onTap: () {
              context.go('/finanzas/gastosfijos');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Configuraciones Generales'),
            onTap: () {
              context.go('/finanzas/config');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
