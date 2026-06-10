import 'package:flutter/material.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> communities = [
    {
      "name": "ALU Debate Society",
      "members": 128,
      "description":
          "Refining critical thinking and public speaking through competitive rhetoric.",
      "category": "Academic",
      "joined": false,
      "icon": Icons.record_voice_over_outlined,
      "color": Colors.indigo,
    },
    {
      "name": "Entrepreneurship Club",
      "members": 245,
      "description":
          "Nurturing the next generation of African business leaders and startup founders.",
      "category": "Innovation",
      "joined": true,
      "icon": Icons.lightbulb_outline,
      "color": Colors.pink,
    },
    {
      "name": "Women in Leadership",
      "members": 310,
      "description":
          "Empowering women to take lead roles in politics, tech, and global industry.",
      "category": "Leadership",
      "joined": false,
      "icon": Icons.female,
      "color": Colors.teal,
    },
    {
      "name": "Developers Guild",
      "members": 189,
      "description":
          "Building real-world projects and mastering modern web and mobile stacks.",
      "category": "Technology",
      "joined": false,
      "icon": Icons.code,
      "color": Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FC),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 5),
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Explore Communities",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Find your tribe and thrive across campuses.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText:
                                "Search clubs, societies, or interests...",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: primaryColor,
                        labelColor: primaryColor,
                        unselectedLabelColor: Colors.black54,
                        tabs: const [
                          Tab(text: "All Clubs"),
                          Tab(text: "My Clubs"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: communities.length,
                        itemBuilder: (context, index) {
                          final club = communities[index];

                          return CommunityCard(
                            name: club["name"],
                            members: club["members"],
                            description: club["description"],
                            category: club["category"],
                            joined: club["joined"],
                            icon: club["icon"],
                            color: club["color"],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final String name;
  final int members;
  final String description;
  final String category;
  final bool joined;
  final IconData icon;
  final Color color;

  const CommunityCard({
    super.key,
    required this.name,
    required this.members,
    required this.description,
    required this.category,
    required this.joined,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.groups_2_outlined, size: 16),
              const SizedBox(width: 5),
              Text(
                "$members Members",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: joined
                          ? const Color(0xFFDCE2FF)
                          : const Color(0xFF4F46E5),
                      foregroundColor: joined
                          ? const Color(0xFF4F46E5)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      joined ? "✓ Joined" : "Join",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}