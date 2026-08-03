import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'dart:io';
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    // Assuming local timezone, we can set it to a default or let timezone package handle it.
    // For simplicity, we just initialize it.

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    
    // For iOS (if needed in future)
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings: initSettings);
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleItemReminder(ItemEntity item, DateTime scheduledTime) async {
    final id = item.id;
    
    final androidDetails = AndroidNotificationDetails(
      'item_reminders',
      'تذكيرات الملاحظات',
      channelDescription: 'إشعارات لتذكيرك بمراجعة ملاحظاتك',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    await _localNotifications.zonedSchedule(
      id: id,
      title: 'تذكير بمراجعة ملاحظة',
      body: item.content.length > 50 ? '${item.content.substring(0, 50)}...' : item.content,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleDailyMotivation() async {
    final tip = getRandomTip();

    final androidDetails = AndroidNotificationDetails(
      'daily_motivation',
      'التحفيز اليومي',
      channelDescription: 'إشعار يومي لتذكيرك بمراجعة عقلك الثاني',
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    // Schedule for 8:00 PM everyday
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _localNotifications.zonedSchedule(
      id: 9999, // Unique ID for daily notification
      title: '💡 نصيحة اليوم',
      body: tip,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at the same time
    );
  }

  String getRandomTip() {
    final tips = [
      "عقلك الثاني هو سلاحك السري، حافظ على ترتيبه!",
      "قليل دائم خير من كثير منقطع.",
      "تنظيم أفكارك يوفر نصف وقتك.",
      "لا تعتمد على ذاكرتك في كل شيء، اكتب لترتاح.",
      "كل فكرة عظيمة بدأت بملاحظة صغيرة.",
      "راجع مهامك اليوم، خطوة صغيرة تصنع فرقاً كبيراً.",
      "الاستمرارية هي مفتاح النجاح، تفقد أهدافك.",
    ];
    final random = Random();
    return tips[random.nextInt(tips.length)];
  }
}
