import 'package:flutter/material.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // we use blue/noir

      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        // Barre superieure avec le titre et l'icone d'engrenege
        backgroundColor: Colors.grey[100],
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () {
              // Action pour ouvrir les parametres
            },
          ),
        ],
      ),

      //2. Le corps de l'ecran avec tout le design de la maquette
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 2.Photo de profile ambree

            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 3),

                ),
                child: const CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.white,

                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Joseph Silver',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 6),
            //3. badge du campus
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(40), // Rend la couleur ambree tres transparente
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Kigali campus',
                style: TextStyle(fontSize: 13, color: Colors.amber, fontWeight:FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            // 4. Bloc des Statistiques (Carte flottante)

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('23', 'Events'),
                    Container(height: 30, width: 1, color: Colors.grey.withValues(alpha: 0.2)), // separateur vertical
                    _buildStatItem('5', 'Communities'),
                    Container(height: 30, width: 1, color: Colors.grey.withValues(alpha: 0.2)),
                    _buildStatItem('87', 'Connexions'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 4. Le Menu : Style 'Clean State' sur fond blsnc pur
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.chat_bubble_outline_rounded, 'My posts'),
                  _buildDivider(),
                  _buildMenuItem(Icons.bookmark_border_rounded, 'Save'),
                  _buildDivider(),
                  _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
                  _buildDivider(),
                  _buildMenuItem(Icons.manage_accounts_rounded, 'Settings'),
                  _buildDivider(),
                  _buildMenuItem(Icons.help_outline_rounded, 'Help & support'),
            
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],

        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
      );
    }
    Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        
      ],
    );
  }
  
  // Widget d'aide pour le menu

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
        
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500)
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26, size: 14),
      onTap: () {

      },
    );
  }
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
