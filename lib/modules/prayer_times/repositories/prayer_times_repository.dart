import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/prayer_times/repositories/db_repository.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:nedaa/utils/services/rest_api_service.dart';

class CurrentPrayerTimesState {
  DayPrayerTimes today;
  DayPrayerTimes tomorrow;
  DayPrayerTimes yesterday;

  CurrentPrayerTimesState(this.today, this.tomorrow, this.yesterday);
}

class PrayerTimesRepository {
  DBRepository db;

  /// use `newRepo` to create a new repo
  PrayerTimesRepository._() : db = DBRepository();

  static Future<PrayerTimesRepository> newRepo(
    UserLocation location,
    CalculationMethod method,
    String timezone,
  ) async {
    var repo = PrayerTimesRepository._();
    await repo.db.open();

    if ((location.location != null) ||
        (location.country != null && location.city != null)) {
      await repo.getCurrentPrayerTimesState(location, method, timezone);
    }
    return repo;
  }

  Future<void> cleanCache() {
    return db.resetDatabase();
  }

  Future<CurrentPrayerTimesState> getCurrentPrayerTimesState(
    UserLocation location,
    CalculationMethod method,
    String timezone,
  ) async {
    var today = getCurrentTimeWithTimeZone(
        await getTimezone(location.location!, method));
    var todayPrayerTimes = await db.getDayPrayerTimes(today);

    if (todayPrayerTimes == null) {
      if (location.location != null) {
        var year =
            await getPrayerTimesForYear(location.location!, method, timezone);
        await db.insertAllPrayerTimes(year);
        todayPrayerTimes = await db.getDayPrayerTimes(today);
      } else {
        throw Exception('No location provided');
      }
    }

    var yesterday = today.subtract(const Duration(days: 1));
    var yesterdayPrayerTimes = await db.getDayPrayerTimes(yesterday);
    if (yesterdayPrayerTimes == null) {
      if (location.location != null) {
        var year = await getPrayerTimesForYear(
            location.location!, method, timezone,
            year: yesterday.year);
        await db.insertAllPrayerTimes(year);
        yesterdayPrayerTimes = await db.getDayPrayerTimes(yesterday);
      } else {
        throw Exception('No location provided');
      }
    }

    var tomorrow = today.add(const Duration(days: 1));
    var tomorrowPrayerTimes = await db.getDayPrayerTimes(tomorrow);
    if (tomorrowPrayerTimes == null) {
      if (location.location != null) {
        var year = await getPrayerTimesForYear(
            location.location!, method, timezone,
            year: tomorrow.year);
        await db.insertAllPrayerTimes(year);
        tomorrowPrayerTimes = await db.getDayPrayerTimes(tomorrow);
      } else {
        throw Exception('No location provided');
      }
    }

    await db.deleteAllBefore(yesterday);

    var state = CurrentPrayerTimesState(
        todayPrayerTimes!, tomorrowPrayerTimes!, yesterdayPrayerTimes!);

    return state;
  }
}
