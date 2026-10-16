import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/coffee_item.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/music_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quotes_screen.dart';
import 'screens/welcome_screen.dart';
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
        scaffoldBackgroundColor: const Color(0xFF463453),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA970D8),
          brightness: Brightness.dark,
          primary: const Color(0xFFA970D8),
          secondary: const Color(0xFFFF9FD3),
          surface: const Color(0xFF61466D),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF463453),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF61466D),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF8C6B9A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF8C6B9A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFFF9FD3), width: 1.5),
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
  bool _showWelcome = true;

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

  Future<void> _login(String name, String email) async {
    await _authService.login(name: name, email: email);

    if (!mounted) return;

    setState(() {
      _loggedIn = true;
      _showWelcome = false;
      _name = name;
      _email = email;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return;

    setState(() {
      _loggedIn = false;
      _showWelcome = true;
      _name = 'Coffee Lover';
      _email = 'hello@brewandbloom.com';
    });
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
        backgroundColor: Color(0xFF463453),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF9FD3)),
        ),
      );
    }

    if (!_loggedIn && _showWelcome) {
      return WelcomeScreen(
        onGetStarted: () {
          setState(() {
            _showWelcome = false;
          });
        },
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
  static const String _selectedTabKey = 'brew_bloom_selected_tab';

  int _currentIndex = 0;
  bool _tabChanged = false;

  final Map<CoffeeItem, int> _cart = {};

  @override
  void initState() {
    super.initState();
    _restoreSelectedTab();
  }

  Future<void> _restoreSelectedTab() async {
    final preferences = await SharedPreferences.getInstance();
    final selectedTab = preferences.getInt(_selectedTabKey);
    if (!mounted ||
        _tabChanged ||
        selectedTab == null ||
        selectedTab < 0 ||
        selectedTab >= 5) {
      return;
    }

    setState(() {
      _currentIndex = selectedTab;
    });
  }

  Future<void> _selectTab(int index) async {
    _tabChanged = true;
    setState(() {
      _currentIndex = index;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_selectedTabKey, index);
  }

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
        backgroundColor: const Color(0xFFA970D8),
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

    if (mounted) {
      setState(() {});
    }
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
        backgroundColor: const Color(0xFF61466D),
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
              backgroundColor: const Color(0xFFFF9FD3),
              foregroundColor: const Color(0xFF2C2035),
            ),
            child: const Text('Confirm order'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _cart.clear();
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Order placed successfully! Thank you for choosing Brew & Bloom.',
        ),
        backgroundColor: Color(0xFFA970D8),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        userName: widget.name,
        onBrowseMenu: () => _selectTab(1),
        onBrowseQuotes: () => _selectTab(2),
        onBrowseMusic: () => _selectTab(3),
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
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _selectTab,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCart,
        backgroundColor: const Color(0xFFFF9FD3),
        foregroundColor: const Color(0xFF2C2035),
        child: Badge(
          isLabelVisible: _cartCount > 0,
          label: Text('$_cartCount'),
          child: const Icon(Icons.shopping_bag_rounded),
        ),
      ),
    );
  }
}
