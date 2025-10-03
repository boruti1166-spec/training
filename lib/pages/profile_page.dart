import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = "Guest";
  String email = "Not Available";
  String username = "Unknown";
  String levelUser = "User";
  String photoUrl = "";
  String lastVisit = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString("fullname") ?? "Guest";
      email = prefs.getString("email") ?? "Not Available";
      username = prefs.getString("username") ?? "Unknown";
      levelUser = prefs.getString("level_user") ?? "User";
      photoUrl = prefs.getString("photo") ?? "";
      lastVisit =
      "Last visit ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false, // hapus semua halaman sebelumnya
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout berhasil!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // sama kayak ScrollView di XML
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER dengan background gradient ===
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  // Tombol Logout di kanan atas
                  Positioned(
                    top: 30,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.logout, size: 30, color: Colors.white),
                      onPressed: _logout,
                    ),
                  ),

                  // Foto + Nama + Last Visit
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : const AssetImage("assets/images/default_user.png")
                            as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lastVisit,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // === DETAIL INFORMASI ===
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Nama Lengkap"),
                  _buildValue(fullName),
                  const Divider(),

                  _buildLabel("Email"),
                  _buildValue(email),
                  const Divider(),

                  _buildLabel("Username"),
                  _buildValue(username),
                  const Divider(),

                  _buildLabel("Level User"),
                  _buildValue(levelUser),
                  const Divider(),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/edit_profile");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      "Edit Profil",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildValue(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
