// lib/screens/main_navigation_page.dart

import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'home_screen.dart';
import 'category_list_screen.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 1; // Empieza en el centro (Dashboard)

  // Lista de páginas que se mostrarán según el índice seleccionado
  final List<Widget> _pages = const [
    HomeScreen(),           // Index 0 - Gastos
    DashboardScreen(),      // Index 1 - Inicio (Bienvenida)
    CategoryListScreen(),   // Index 2 - Categorías
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Muestra la página activa
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Gastos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Categorías',
          ),
        ],
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10.0,
      ),
    );
  }
}
