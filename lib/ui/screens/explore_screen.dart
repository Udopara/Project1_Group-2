import 'package:flutter/material.dart';
import 'package:formative_assignment1/data/dummy_database.dart';
import 'package:formative_assignment1/data/session.dart';
import 'package:formative_assignment1/theme/app_theme.dart';
import 'package:formative_assignment1/ui/widgets/app_bottom_nav_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // DATA HELPERS
  // ─────────────────────────────────────────────

  List<ClubModel> get allClubs => DummyDatabase.clubs;

  List<EventModel> get allEvents => DummyDatabase.events;

  List<ClubModel> get myClubs {
    final user = Session.currentUser;
    if (user == null) return [];

    return DummyDatabase.clubs
        .where((c) => c.memberIds.contains(user.id))
        .toList();
  }

  int get totalClubsCount => DummyDatabase.clubs.length;

  int get myClubsCount => myClubs.length;

  // ─────────────────────────────────────────────
  // UI FILTERS
  // ─────────────────────────────────────────────

  Widget _buildBody() {
    switch (_tabController.index) {
      case 0:
        return _allView();
      case 1:
        return _eventsView();
      case 2:
        return _opportunitiesView();
      case 3:
        return _clubsView();
      default:
        return _allView();
    }
  }

  // ─────────────────────────────────────────────
  // VIEWS
  // ─────────────────────────────────────────────

  Widget _allView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Recommended Events"),

        ...allEvents.take(3).map(
              (e) => _eventTile(e),
            ),

        const SizedBox(height: AppSpacing.lg),

        _sectionTitle("Explore Communities"),

        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allClubs.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final club = allClubs[index];
              return _clubCard(club);
            },
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        _bottomClubSummary(),
      ],
    );
  }

  Widget _eventsView() {
    return Column(
      children: allEvents.map(_eventTile).toList(),
    );
  }

  Widget _opportunitiesView() {
    return const Center(
      child: Text("Opportunities coming soon"),
    );
  }

  Widget _clubsView() {
    final list = _tabController.index == 3 ? myClubs : allClubs;

    return Column(
      children: [
        ...list.map(_clubListTile),

        const SizedBox(height: AppSpacing.lg),

        _bottomClubSummary(),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: AppTextStyles.headingMedium,
      ),
    );
  }

  Widget _eventTile(EventModel event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: ListTile(
        // ✅ FIX for ListTile ink warning
        tileColor: AppColors.white,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: const Icon(Icons.event, color: AppColors.primary),
        title: Text(event.title),
        subtitle: Text(event.location),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _clubCard(ClubModel club) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(club.name, style: AppTextStyles.headingSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "${club.memberIds.length} members",
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _clubListTile(ClubModel club) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      child: ListTile(
        // ✅ FIX for ink splash warning
        tileColor: AppColors.white,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Text(club.name[0]),
        ),
        title: Text(club.name),
        subtitle: Text(club.description),
        trailing: Text("${club.memberIds.length}"),
      ),
    );
  }

  Widget _bottomClubSummary() {
    final user = Session.currentUser;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clubs Summary",
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text("Total Clubs: $totalClubsCount"),
          Text("My Clubs: $myClubsCount"),
          if (user != null)
            Text("Logged in as: ${user.fullName}"),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MAIN BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Text("Explore", style: AppTextStyles.displayLarge),

              const SizedBox(height: AppSpacing.md),

              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search opportunities, events, people...",
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.input),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Events"),
                  Tab(text: "Opportunities"),
                  Tab(text: "Clubs"),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: SingleChildScrollView(
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}