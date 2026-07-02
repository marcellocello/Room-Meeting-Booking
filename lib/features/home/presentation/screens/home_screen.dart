import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/home/data/home_data.dart';
import 'package:roomsync/features/home/presentation/widgets/home_shimmer.dart';
import 'package:roomsync/features/home/presentation/widgets/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeData? _data;
  bool _isLoading = true;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _fadeController.reset();

    final data = await HomeMockData.fetch();

    if (!mounted) return;
    setState(() {
      _data = data;
      _isLoading = false;
    });
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.secondary,
          backgroundColor: AppColors.surface,
          displacement: 20,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                scrolledUnderElevation: 1,
                shadowColor: AppColors.ambientShadow,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                titleSpacing: AppSpacing.md,
                title: const Text(
                  'RoomSync',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textCharcoal,
                    letterSpacing: -0.3,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 22),
                    onPressed: () {},
                    color: AppColors.textCharcoal,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: GestureDetector(
                      onTap: () {
                        context.go('/profile');
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.secondary,
                        child: const Text(
                          'A',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppSpacing.md),
                    _isLoading
                      ? _WelcomeShimmer()
                      : FadeTransition(
                          opacity: _fadeAnim,
                          child: _WelcomeHeader(data: _data!),
                        ),
                    const SizedBox(height: AppSpacing.md),
                    _isLoading
                      ? const NextBookingShimmer()
                      : FadeTransition(
                          opacity: _fadeAnim,
                          child: _data!.nextBooking != null
                            ? NextBookingCard(booking: _data!.nextBooking!)
                            : const SizedBox.shrink(),
                        ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'QUICK ACTIONS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _isLoading
                      ? const QuickActionsShimmer()
                      : FadeTransition(
                          opacity: _fadeAnim,
                          child: QuickActions(
                            onFindRoom: () {},
                            onMyBookings: () {},
                          ),
                        ),
                    const SizedBox(height: AppSpacing.lg),
                    _isLoading
                      ? const SizedBox(height: 32)
                      : FadeTransition(
                          opacity: _fadeAnim,
                          child: SectionHeader(
                            title: 'Available Now',
                            actionLabel: 'View Map',
                            onAction: () {},
                          ),
                        ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_isLoading) ...[
                      const RoomCardShimmer(),
                      const SizedBox(height: AppSpacing.md),
                      const RoomCardShimmer(),
                    ] else if (_data!.availableRooms.isEmpty)
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: NoRoomsCard(onViewSchedule: () {}),
                      )
                    else
                      ...(_data!.availableRooms.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final room = entry.value;
                        return FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.08 + idx * 0.04),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _fadeController,
                              curve: Interval(
                                idx * 0.15,
                                1.0,
                                curve: Curves.easeOutCubic,
                              ),
                            )),
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: idx < _data!.availableRooms.length - 1
                                  ? AppSpacing.md
                                  : 0,
                              ),
                              child: RoomCard(
                                room: room,
                                onBook: () {},
                              ),
                            ),
                          ),
                        );
                      })),
                    const SizedBox(height: AppSpacing.xl),
                    _isLoading
                      ? const ScheduleShimmer()
                      : FadeTransition(
                          opacity: _fadeAnim,
                          child: DailyScheduleSection(
                            items: _data!.schedule,
                          ),
                        ),
                    const SizedBox(height: AppSpacing.xxl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final HomeData data;
  const _WelcomeHeader({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Alex',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }
}

class _WelcomeShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 240,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

class Shimmer extends StatelessWidget {
  final Widget child;
  const Shimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return shimmer.Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: const Color(0xFFF6F3F5),
      child: child,
    );
  }
}