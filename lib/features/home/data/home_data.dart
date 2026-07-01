class UpcomingBooking {
  final String id;
  final String roomName;
  final String title;
  final String participants;
  final String startTime;
  final String endTime;
  final String floor;
  final int minutesLeft;

  const UpcomingBooking({
    required this.id,
    required this.roomName,
    required this.title,
    required this.participants,
    required this.startTime,
    required this.endTime,
    required this.floor,
    required this.minutesLeft,
  });
}

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

class DailyScheduleItem {
  final String time;
  final String? bookingTitle;
  final String? roomName;
  final bool isBooked;

  const DailyScheduleItem({
    required this.time,
    this.bookingTitle,
    this.roomName,
    required this.isBooked,
  });
}

class HomeData {
  final UpcomingBooking? nextBooking;
  final List<RoomModel> availableRooms;
  final List<DailyScheduleItem> schedule;
  final int totalBookingsToday;

  const HomeData({
    this.nextBooking,
    required this.availableRooms,
    required this.schedule,
    required this.totalBookingsToday,
  });
}

abstract class HomeMockData {
  static Future<HomeData> fetch() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return const HomeData(
      totalBookingsToday: 3,
      nextBooking: UpcomingBooking(
        id: 'bk-001',
        roomName: 'Room 302',
        title: 'Weekly Sync',
        participants: 'Alex, Sarah + 3 others',
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        floor: 'Floor 3',
        minutesLeft: 15,
      ),
      availableRooms: [
        RoomModel(
          id: 'rm-001',
          name: 'The Library',
          floor: 'Floor 2',
          capacityMin: 8,
          capacityMax: 12,
          facilities: ['Projector', 'Whiteboard'],
          isAvailable: true,
        ),
        RoomModel(
          id: 'rm-002',
          name: 'Boardroom A',
          floor: 'Floor 4',
          capacityMin: 20,
          capacityMax: 30,
          facilities: ['Video Conferencing', 'Whiteboard'],
          isAvailable: true,
        ),
      ],
      schedule: [
        DailyScheduleItem(time: '09:00', isBooked: false),
        DailyScheduleItem(
          time: '10:00',
          bookingTitle: 'Weekly Sync',
          roomName: 'Room 302',
          isBooked: true,
        ),
        DailyScheduleItem(time: '11:00', isBooked: false),
        DailyScheduleItem(time: '12:00', isBooked: false),
        DailyScheduleItem(
          time: '13:00',
          bookingTitle: 'Design Review',
          roomName: 'The Library',
          isBooked: true,
        ),
        DailyScheduleItem(time: '14:00', isBooked: false),
        DailyScheduleItem(
          time: '15:00',
          bookingTitle: 'Sprint Planning',
          roomName: 'Boardroom A',
          isBooked: true,
        ),
        DailyScheduleItem(time: '16:00', isBooked: false),
        DailyScheduleItem(time: '17:00', isBooked: false),
      ]
    );
  }
}