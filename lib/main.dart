import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/isar_service.dart';
import 'package:flutter_application_2/views/kelime_ekle.dart';

import 'package:flutter_application_2/views/kelimeler_listesi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarService = IsarService();
  await isarService.init();

  runApp(MyApp(isarService: isarService));
}

class MyApp extends StatelessWidget {
  final IsarService isarService;
  const MyApp({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(isarService: isarService),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final IsarService isarService;
  const MyHomePage({super.key, required this.isarService});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      KelimelerListesi(isarService: widget.isarService),
      KelimeEkle(isarService: widget.isarService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelimelerim", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange.shade400,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        indicatorColor: Colors.deepOrange.shade400,
        selectedIndex: pageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            icon: Icon(Icons.list_alt),
            label: 'Kelimelerim',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.add_circle_outline_outlined,
              color: Colors.white,
            ),
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'Ekle',
          ),
        ],
      ),
    );
  }
}
