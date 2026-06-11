import 'package:flutter/material.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';
import 'package:formative_assignment1/theme/app_theme.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = "";

  final List<Map<String, dynamic>> communities = [
    {
      "name": "ALU Debate Society",
      "members": 128,
      "description":
          "Refining critical thinking and public speaking through competitive rhetoric.",
      "category": "Academic",
      "joined": false,
      "icon": Icons.record_voice_over_outlined,
      "color": AppColors.primary,
    },
    {
      "name": "Entrepreneurship Club",
      "members": 245,
      "description":
          "Nurturing the next generation of African business leaders and startup founders.",
      "category": "Innovation",
      "joined": true,
      "icon": Icons.lightbulb_outline,
      "color": AppColors.gradientEnd,
    },
    {
      "name": "Women in Leadership",
      "members": 310,
      "description":
          "Empowering women to take lead roles in politics, tech, and global industry.",
      "category": "Leadership",
      "joined": false,
      "icon": Icons.female,
      "color": AppColors.success,
    },
    {
      "name": "Developers Guild",
      "members": 189,
      "description":
          "Building real-world projects and mastering modern web and mobile stacks.",
      "category": "Technology",
      "joined": false,
      "icon": Icons.code,
      "color": AppColors.primary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
    });

    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }


  List<Map<String, dynamic>> get filteredCommunities {
    List<Map<String, dynamic>> data = communities;

    // TAB FILTER
    if (_tabController.index == 1) {
      data = data.where((c) => c["joined"] == true).toList();
    }

    // SEARCH FILTER
    if (searchQuery.isNotEmpty) {
      data = data.where((c) {
        final name = c["name"].toString().toLowerCase();
        final category = c["category"].toString().toLowerCase();
        return name.contains(searchQuery) ||
            category.contains(searchQuery);
      }).toList();
    }

    return data;
  }

  void toggleJoin(String name) {
    setState(() {
      final index = communities.indexWhere((c) => c["name"] == name);
      communities[index]["joined"] =
          !(communities[index]["joined"] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredCommunities;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      bottomNavigationBar: AppBottomNavBar(currentIndex: 5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        "Explore Communities",
                        style: AppTextStyles.displayLarge,
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        "Find your tribe and thrive across campuses.",
                        style: AppTextStyles.bodyMedium,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // SEARCH
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText:
                              "Search clubs, societies, or interests...",
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.input),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // TABS
                      TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.primary,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textMuted,
                        labelStyle: AppTextStyles.labelMedium,
                        tabs: const [
                          Tab(text: "All Clubs"),
                          Tab(text: "My Clubs"),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // EMPTY STATE + LIST ANIMATION
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: data.isEmpty
                            ? const EmptyState()
                            : ListView.builder(
                                key: ValueKey(data.length),
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final club = data[index];

                                  return CommunityCard(
                                    name: club["name"],
                                    members: club["members"],
                                    description: club["description"],
                                    category: club["category"],
                                    joined: club["joined"],
                                    icon: club["icon"],
                                    color: club["color"],
                                    onJoinToggle: () =>
                                        toggleJoin(club["name"]),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: AppSpacing.lg),
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


class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.search_off,
              size: 60, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            "No communities found",
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Try adjusting your search or explore all clubs.",
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
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
  final VoidCallback onJoinToggle;

  const CommunityCard({
    super.key,
    required this.name,
    required this.members,
    required this.description,
    required this.category,
    required this.joined,
    required this.icon,
    required this.color,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppRadius.statTile),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppRadius.badge),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(name,
                style: AppTextStyles.headingMedium),
          ),

          const SizedBox(height: AppSpacing.xs),

          Row(
            children: [
              const Icon(Icons.groups_2_outlined,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text("$members Members",
                  style: AppTextStyles.bodySmall),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(description,
                style: AppTextStyles.bodyMedium),
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onJoinToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: joined
                        ? AppColors.primaryLight
                        : AppColors.primary,
                    foregroundColor: joined
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                  child: Text(joined ? "✓ Joined" : "Join"),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.cardBorder),
                  borderRadius:
                      BorderRadius.circular(AppRadius.button),
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