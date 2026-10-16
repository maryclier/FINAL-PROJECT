import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final int cartCount;
  final VoidCallback onLogout;
  final Future<void> Function(String name, String email) onSave;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.cartCount,
    required this.onLogout,
    required this.onSave,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.name != widget.name && !_editing) {
      _nameController.text = widget.name;
    }

    if (oldWidget.email != widget.email && !_editing) {
      _emailController.text = widget.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name and email.')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await widget.onSave(name, email);

      if (!mounted) return;

      setState(() => _editing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update your profile.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF463453),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF463453),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA970D8), Color(0xFFFF9FD3)],
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 58,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              widget.email,
              style: const TextStyle(color: Colors.white60),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF61466D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_bag_rounded,
                  color: Color(0xFFFF9FD3),
                  size: 32,
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Items in your cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${widget.cartCount}',
                  style: const TextStyle(
                    color: Color(0xFFFF9FD3),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PERSONAL INFORMATION',
                style: TextStyle(
                  color: Color(0xFFFF9FD3),
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _editing = !_editing);
                },
                child: Text(_editing ? 'Cancel' : 'Edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _profileField(
            label: 'Full name',
            controller: _nameController,
            enabled: _editing,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 14),
          _profileField(
            label: 'Email address',
            controller: _emailController,
            enabled: _editing,
            icon: Icons.email_outlined,
          ),
          if (_editing) ...[
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9FD3),
                  foregroundColor: const Color(0xFF2C2035),
                ),
                child: _saving
                    ? const CircularProgressIndicator()
                    : const Text('Save Changes'),
              ),
            ),
          ],
          const SizedBox(height: 30),
          const Divider(color: Color(0xFF8C6B9A)),
          const SizedBox(height: 12),
          const Text(
            'BREW & BLOOM',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'A little coffee, a little comfort, and a moment just for you.',
            style: TextStyle(color: Colors.white60, height: 1.5),
          ),
          const SizedBox(height: 26),
          OutlinedButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF9FD3),
              side: const BorderSide(color: Color(0xFFFF9FD3)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _profileField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: const Color(0xFFFF9FD3)),
        filled: true,
        fillColor: const Color(0xFF61466D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF8C6B9A)),
        ),
      ),
    );
  }
}
