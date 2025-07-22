// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pencatatan_keuangan/category_index.dart';
import 'package:pencatatan_keuangan/dashboard_screen.dart';
import 'package:pencatatan_keuangan/trasactions_index.dart';
import 'presentation/dashboard/cubit/dashboard_cubit.dart';
import 'presentation/transaction_list/cubit/transaction_list_cubit.dart';
import 'presentation/category_list/cubit/category_list_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna utama dan varian
    const primary = Color(0xFF00695C);
    final primaryDark = Colors.teal.shade700;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashboardCubit()..transaction()),
        BlocProvider(create: (_) => TransactionListCubit()..transaction()),
        BlocProvider(create: (_) => CategoryListCubit()..category()),
      ],
      child: MaterialApp(
        title: 'Pencatatan Keuangan Harian',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primary,
            primary: primary,
            onPrimary: Colors.white,
            secondary: Colors.amber[600]!,
            error: Colors.red[700]!,            
            surface: Colors.white,
            primaryContainer: primaryDark,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: AppBarTheme(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: primaryDark,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
          ),
          chipTheme: ChipThemeData(
            selectedColor: primary.withOpacity(0.1),
            labelStyle: TextStyle(color: primaryDark),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            secondarySelectedColor: primary.withOpacity(0.1),
            brightness: Brightness.light,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final _pages = [
    const DashboardScreen(title: 'Pencatatan Keuangan Harian'),
    const TransactionPage(title: 'Daftar Transaksi'),
    const CategoryPage(title: 'Daftar Kategori'),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
        ],
      ),
    );
  }
}