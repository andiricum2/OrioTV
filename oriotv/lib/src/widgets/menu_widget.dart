import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Verifica el ancho de la pantalla para decidir el diseño del menú
        bool isHorizontal = constraints.maxWidth > 600;
        double screenWidth = MediaQuery.of(context).size.width;

        return isHorizontal
            ? SizedBox(
                width: screenWidth / 8,
                child: Drawer(
                  child: ListView(
                    children: [
                      _buildDrawerItem('Inicio', () {
                        _onHomeTap(context);
                      }),
                      _buildDrawerItem('Buscar', () {
                        _onSearchTap(context);
                      }),
                      // Agrega más opciones según sea necesario
                    ],
                  ),
                ),
              )
            : BottomNavigationBar(
                items: [
                  _buildBottomNavigationBarItem(Icons.home, 'Inicio'),
                  _buildBottomNavigationBarItem(Icons.search, 'Buscar'),
                  // Agrega más ítems según sea necesario
                ],
                onTap: (index) {
                  if (index == 0) {
                    _onHomeTap(context);
                  } else if (index == 1) {
                    _onSearchTap(context);
                  }
                },
              );
      },
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  void _onHomeTap(BuildContext context) {
    // TODO: Implementar la navegación para Inicio
    print("Inicio");
  }

  void _onSearchTap(BuildContext context) {
    // TODO: Implementar la navegación para Buscar
    print("Search");
  }
}
