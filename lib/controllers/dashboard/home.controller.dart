import 'dart:async';
import 'package:ecom_one/utils/toast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  var greeting = 'Hello!'.obs;
  final RxInt currentSlotIndex = 0.obs;
  late final Stream<DateTime> timeStream;

  final RefreshController refreshCtrl = RefreshController(
    initialRefresh: false,
  );

  final Uri _whatsAppUri = Uri.parse(
    'https://api.whatsapp.com/send?phone=917994468982&text=Hey%20foxiom',
  );

  Future<void> openChat(context) async {
    if (await canLaunchUrl(_whatsAppUri)) {
      await launchUrl(_whatsAppUri, mode: LaunchMode.externalApplication);
    } else {
      ToastHelper.showErrorToast(context, 'Error', 'Could not open WhatsApp');
    }
  }

  //search bar
  final RxBool showSearchPrompt = false.obs;
  Timer? _toggleTimer;

  //countdown
  final RxString countdown = ''.obs;
  final RxString time1 = ''.obs;
  final RxString time2 = ''.obs;
  Timer? _timer;
  DateTime? _slotEnd;

  @override
  void onInit() {
    super.onInit();
    updateGreeting();
    _setupSlot();
    _startAutoToggle(Duration(seconds: 3));

    timeStream =
        Stream<DateTime>.periodic(
          const Duration(seconds: 1),
          (_) => DateTime.now(),
        ).asBroadcastStream();
  }

  void _startAutoToggle(Duration interval) {
    _toggleTimer?.cancel();
    _toggleTimer = Timer.periodic(interval, (_) {
      showSearchPrompt.value = !showSearchPrompt.value;
    });
  }

  Future<void> onRefresh() async {
    await refreshData();
    refreshCtrl.refreshCompleted();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(milliseconds: 300));
    updateGreeting();
    _setupSlot();
  }

  void _setupSlot() {
    final now = DateTime.now();
    // [orderStartHour, orderEndHour, deliverHour, deliverMinute]
    final slots = [
      [8, 10, 11, 0],
      [10, 12, 13, 0],
      [12, 14, 15, 0],
      [14, 16, 17, 0],
      [16, 18, 19, 0],
    ];

    // 1) If we're before the first slot today, schedule it for today.
    final first = slots[0];
    final startFirst = DateTime(now.year, now.month, now.day, first[0]);
    final endFirst = DateTime(now.year, now.month, now.day, first[1]);
    if (now.isBefore(startFirst)) {
      currentSlotIndex.value = 0;
      _slotEnd = endFirst;
      final deliverStart = DateTime(
        now.year,
        now.month,
        now.day,
        first[2],
        first[3],
      );
      final deliverEnd = deliverStart.add(Duration(minutes: 30));
      time1.value = DateFormat.j().format(deliverStart); // e.g. "11 AM"
      time2.value = DateFormat.jm().format(deliverEnd); // e.g. "11:30 AM"
      _startCountdown();
      return;
    }

    // 2) Otherwise see if we're in any slot _today_
    for (var i = 0; i < slots.length; i++) {
      final slot = slots[i];
      final start = DateTime(now.year, now.month, now.day, slot[0]);
      final end = DateTime(now.year, now.month, now.day, slot[1]);
      if (!now.isBefore(start) && now.isBefore(end)) {
        currentSlotIndex.value = i;
        _slotEnd = end;
        final deliverStart = DateTime(
          now.year,
          now.month,
          now.day,
          slot[2],
          slot[3],
        );
        final deliverEnd = deliverStart.add(Duration(minutes: 30));
        time1.value = DateFormat.j().format(deliverStart);
        time2.value = DateFormat.jm().format(deliverEnd);
        _startCountdown();
        return;
      }
    }

    // 3) If we've passed _all_ today's slots, schedule the first slot _tomorrow_
    final tomorrow = now.add(Duration(days: 1));
    final tomFirstEnd = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      first[1],
    );
    currentSlotIndex.value = 0; // next slot is tomorrow’s first
    _slotEnd = tomFirstEnd;
    final deliverStart = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      first[2],
      first[3],
    );
    final deliverEnd = deliverStart.add(Duration(minutes: 30));
    time1.value = DateFormat.j().format(deliverStart);
    time2.value = DateFormat.jm().format(deliverEnd);
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _updateCountdown();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_slotEnd == null) return;

    final now = DateTime.now();
    final diff = _slotEnd!.difference(now);

    if (diff.inSeconds <= 0) {
      _timer?.cancel();
      _setupSlot();
      return;
    }

    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
    countdown.value = '$hours:$minutes:$seconds';
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      greeting.value = 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      greeting.value = 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      greeting.value = 'Good evening';
    } else {
      greeting.value = 'Good night';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _toggleTimer?.cancel();
    super.onClose();
  }
}
