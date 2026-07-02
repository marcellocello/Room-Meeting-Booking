import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/discover/data/discover_data.dart';
import 'package:roomsync/features/discover/presentation/widgets/discover_shimmer.dart';
import 'package:roomsync/features/discover/presentation/widgets/discover_widget.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  DiscoverData? _data;
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

    final data = await DiscoverMockData.fetch();

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
                centerTitle: false,
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
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _isLoading
                      ? _SearchBoxShimmer()
                      : FadeTransition(
                          opacity: _fadeAnim,
                          child: DiscoverSearch(),
                        ),
                    const Gap(AppSpacing.md),
                    if (_isLoading) ...[
                      const RoomCardShimmer(),
                      const SizedBox(height: AppSpacing.md),
                      const RoomCardShimmer(),
                    ] else if (_data!.rooms.isEmpty)
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: NoRoomsCard(onViewSchedule: () {}),
                      )
                    else
                      ...(_data!.rooms.asMap().entries.map((entry) {
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
                                bottom: idx < _data!.rooms.length - 1
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

class _SearchBoxShimmer extends StatelessWidget {
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