
import 'package:flutter/material.dart';

import 'models/coffee_item.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/music_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quotes_screen.dart';
import 'services/auth_service.dart';
import 'widgets/bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrewBloomApp());
}

class BrewBloomApp extends StatelessWidget {
  const BrewBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brew & Bloom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF160F20),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF633A91),
          brightness: Brightness.dark,
          primary: const Color(0xFF633A91),
          secondary: const Color(0xFFFFA6D5),
          surface: const Color(0xFF281B36),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF160F20),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF281B36),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF493454)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF493454)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFFFA6D5),
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();
  bool _checking = true;
  bool _loggedIn = false;
  String _name = 'Coffee Lover';
  String _email = 'hello@brewandbloom.com';

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final loggedIn = await _authService.isLoggedIn();
    final name = await _authService.getName();
    final email = await _authService.getEmail();

    if (!mounted) return;

    setState(() {
      _loggedIn = loggedIn;
      _name = name;
      _email = email;
      _checking = false;
    });
  }

  Future<void> _login() async {
    await _authService.login(name: _name, email: _email);

    if (!mounted) return;

    setState(() => _loggedIn = true);
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return;

    setState(() => _loggedIn = false);
  }

  Future<void> _saveProfile(String name, String email) async {
    await _authService.updateProfile(name: name, email: email);

    if (!mounted) return;

    setState(() {
      _name = name;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF160F20),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFA6D5),
          ),
        ),
      );
    }

    if (!_loggedIn) {
      return LoginScreen(onLogin: _login);
    }

    return MainShell(
      name: _name,
      email: _email,
      onLogout: _logout,
      onSaveProfile: _saveProfile,
    );
  }
}

class MainShell extends StatefulWidget {
  final String name;
  final String email;
  final VoidCallback onLogout;
  final Future<void> Function(String name, String email) onSaveProfile;

  const MainShell({
    super.key,
    required this.name,
    required this.email,
    required this.onLogout,
    required this.onSaveProfile,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Map<CoffeeItem, int> _cart = {};

  int get _cartCount =>
      _cart.values.fold(0, (total, quantity) => total + quantity);

  void _addToCart(CoffeeItem item) {
    setState(() {
      _cart[item] = (_cart[item] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to your cart'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF633A91),
      ),
    );
  }

  void _increaseQuantity(CoffeeItem item) {
    setState(() {
      _cart[item] = (_cart[item] ?? 0) + 1;
    });
  }

  void _decreaseQuantity(CoffeeItem item) {
    setState(() {
      final quantity = _cart[item] ?? 0;

      if (quantity <= 1) {
        _cart.remove(item);
      } else {
        _cart[item] = quantity - 1;
      }
    });
  }

  Future<void> _openCart() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CartScreen(
          cart: Map<CoffeeItem, int>.from(_cart),
          onIncrease: _increaseQuantity,
          onDecrease: _decreaseQuantity,
          onCheckout: _checkout,
        ),
      ),
    );

    if (mounted) setState(() {});
  }

  Future<void> _checkout() async {
    if (_cart.isEmpty) return;

    final total = _cart.entries.fold<double>(
      0,
      (sum, entry) => sum + entry.key.price * entry.value,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF281B36),
        title: const Text('Confirm your order'),
        content: Text(
          'Your order total is ₱${total.toStringAsFixed(2)}. '
          'Would you like to place your order?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Not yet'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA6D5),
              foregroundColor: const Color(0xFF21142F),
            ),
            child: const Text('Confirm order'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _cart.clear());

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully! Thank you for choosing Brew & Bloom.'),
        backgroundColor: Color(0xFF633A91),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        userName: widget.name,
        onBrowseMenu: () => setState(() => _currentIndex = 1),
        onBrowseQuotes: () => setState(() => _currentIndex = 2),
        onBrowseMusic: () => setState(() => _currentIndex = 3),
        onAdd: _addToCart,
      ),
      MenuScreen(onAdd: _addToCart),
      const QuotesScreen(),
       const MusicScreen(),
      ProfileScreen(
        name: widget.name,
        email: widget.email,
        cartCount: _cartCount,
        onLogout: widget.onLogout,
        onSave: widget.onSaveProfile,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCart,
        backgroundColor: const Color(0xFFFFA6D5),
        foregroundColor: const Color(0xFF21142F),
        child: Badge(
          isLabelVisible: _cartCount > 0,
          label: Text('$_cartCount'),
          child: const Icon(Icons.shopping_bag_rounded),
        ),
      ),
    );
  }
}
