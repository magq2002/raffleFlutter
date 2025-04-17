import 'package:flutter/material.dart';
import '../features/raffles/presentation/pages/raffle_page.dart';
import '../features/raffles/presentation/pages/giveaway_page.dart';
import '../features/raffles/presentation/pages/trash_page.dart';
import '../features/raffles/presentation/pages/history_page.dart';
import '../features/raffles/presentation/pages/settings_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RafflePage(),
    GiveawayPage(),
    TrashPage(),
    HistoryPage(),
    SettingsPage(),
  ];

  final List<String> _titles = [
    'Raffles',
    'Giveaways',
    'Trash',
    'History',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard), label: "Raffles"),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard), label: "Giveaways"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Trash"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
