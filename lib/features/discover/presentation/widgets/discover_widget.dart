import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:roomsync/core/theme/app_theme.dart';
import 'package:roomsync/features/discover/data/discover_data.dart';

class DiscoverSearch extends StatelessWidget {
  const DiscoverSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textCharcoal,
            fontSize: 14
          ),
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Search for rooms, buildings, or amenities...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.borderSubtle)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.borderSubtle)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.secondary, width: 1.5)
            ),
          ),
        ),
        const Gap(AppSpacing.md),
        Row(
          children: [
            const Text(
              'Sort by:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<String>(
                initialValue: 'Nearest',
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textCharcoal,
                ),
                items: const [
                  DropdownMenuItem(value: 'Nearest', child: Text('Nearest')),
                  DropdownMenuItem(value: 'Capacity', child: Text('Capacity')),
                  DropdownMenuItem(value: 'Available', child: Text('Available')),
                ],
                onChanged: (value) {},
              ),
            ),
          ],
        )
      ],
    );
  }
}

class RoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onBook;

  const RoomCard({super.key, required this.room, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [kAmbientShadow],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _RoomImagePlaceholder(roomId: room.id, image: room.imageUrl ?? 'null'),
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _StatusBadge(isAvailable: room.isAvailable),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + floor
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        room.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      room.floor,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${room.capacityMin}–${room.capacityMax}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Icon(Icons.tv_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      room.facilities.join(', '),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: room.isAvailable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: OutlinedButton(
                              onPressed: onBook,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.secondary,
                                side: const BorderSide(color: AppColors.secondary),
                                backgroundColor: AppColors.secondary,
                                minimumSize: const Size.fromHeight(40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                              ),
                              child: const Text(
                                'Book Now',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 13
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .2,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.transparent,
                                side: const BorderSide(color: Colors.transparent),
                                backgroundColor: Colors.transparent,
                                minimumSize: const Size.fromHeight(40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                              ),
                              child: Icon(Icons.info_outline, size: 18, color: AppColors.outline)
                            ),
                          ),
                        ],
                      )
                    : OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.surfaceGray,
                          side: const BorderSide(color: AppColors.surfaceGray),
                          backgroundColor: AppColors.surfaceGray,
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        child: const Text(
                          'View Schedule',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                            fontSize: 13
                          ),
                        ),
                      )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomImagePlaceholder extends StatelessWidget {
  final String roomId;
  final String image;
  const _RoomImagePlaceholder({required this.roomId, required this.image});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF1E293B),
      const Color(0xFF0F2544),
      const Color(0xFF1A1A2E),
    ];
    final idx = roomId.hashCode % colors.length;

    return image == 'null'
        ? Container(
            height: 160,
            width: double.infinity,
            color: colors[idx.abs()],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.meeting_room_outlined, size: 40, color: Colors.white.withAlpha(60)),
              ],
            ),
          )
        : Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image!),
                fit: BoxFit.cover,
              ),
            ),
        );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAvailable;
  const _StatusBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: isAvailable ? AppColors.available : AppColors.booked, width: 1)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.available : AppColors.booked,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isAvailable ? 'Available' : 'Booked',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isAvailable ? AppColors.available : AppColors.booked,
            ),
          ),
        ],
      ),
    );
  }
}

class NoRoomsCard extends StatelessWidget {
  final VoidCallback onViewSchedule;
  const NoRoomsCard({super.key, required this.onViewSchedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Rooms Available Right Now',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'All rooms are currently occupied or reserved. Check back later or view your upcoming bookings.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: onViewSchedule,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: const BorderSide(color: AppColors.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: const Text('View Schedule'),
          ),
        ],
      ),
    );
  }
}