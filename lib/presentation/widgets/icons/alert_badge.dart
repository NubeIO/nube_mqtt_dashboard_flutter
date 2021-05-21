import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class AlertBadgeIcon extends StatelessWidget {
  final int count;
  final void Function() onNotificationPressed;

  const AlertBadgeIcon({
    Key key,
    this.count = 0,
    this.onNotificationPressed,
  }) : super(key: key);

  Widget notificationIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: onNotificationPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      showBadge: count != 0,
      position: BadgePosition.topEnd(top: 8.0, end: 12.0),
      borderRadius: BorderRadius.circular(4),
      badgeColor: Theme.of(context).colorScheme.primary,
      badgeContent: Text(
        count.toString(),
        style: Theme.of(context).textTheme.caption,
      ),
      animationType: BadgeAnimationType.scale,
      child: notificationIcon(context),
    );
  }
}
