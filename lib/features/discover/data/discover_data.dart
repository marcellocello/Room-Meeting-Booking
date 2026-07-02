class RoomModel {
  final String id;
  final String name;
  final String floor;
  final int capacityMin;
  final int capacityMax;
  final List<String> facilities;
  final bool isAvailable;
  final String? imageUrl;

  const RoomModel({
    required this.id,
    required this.name,
    required this.floor,
    required this.capacityMin,
    required this.capacityMax,
    required this.facilities,
    required this.isAvailable,
    this.imageUrl,
  });
}

class DiscoverData {
  final List<RoomModel> rooms;

  const DiscoverData({
    required this.rooms
  });
}

abstract class DiscoverMockData {
  static Future<DiscoverData> fetch() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return const DiscoverData(
      rooms: [
        RoomModel(
          id: 'rm-001',
          name: 'The Library',
          floor: 'Floor 2',
          capacityMin: 8,
          capacityMax: 12,
          facilities: ['Projector', 'Whiteboard'],
          isAvailable: true,
          imageUrl: 'assets/images/room-1.jpg'
        ),
        RoomModel(
          id: 'rm-002',
          name: 'Boardroom A',
          floor: 'Floor 4',
          capacityMin: 20,
          capacityMax: 30,
          facilities: ['Video Conferencing', 'Whiteboard'],
          isAvailable: true,
          imageUrl: 'assets/images/room-2.jpg'
        ),
        RoomModel(
          id: 'rm-003',
          name: 'Main Room Meeting',
          floor: 'Floor 1',
          capacityMin: 4,
          capacityMax: 10,
          facilities: ['Android TV', 'Whiteboard'],
          isAvailable: false,
          imageUrl: 'assets/images/room-3.jpg'
        ),
        RoomModel(
          id: 'rm-004',
          name: 'Violet Rooms',
          floor: 'Floor 3',
          capacityMin: 4,
          capacityMax: 10,
          facilities: ['Android TV', 'Whiteboard'],
          isAvailable: true,
          imageUrl: 'assets/images/room-4.jpg'
        ),
        RoomModel(
          id: 'rm-005',
          name: 'Lavender Room',
          floor: 'Floor 2',
          capacityMin: 15,
          capacityMax: 20,
          facilities: ['Android TV', 'Whiteboard'],
          isAvailable: true,
          imageUrl: 'assets/images/room-5.jpg'
        ),
      ],
    );
  }
}