import 'package:flutter/material.dart';

/// Entry point for secondary sections (reviews, team, settings).
///
/// Keeping the adaptive shell to five primary destinations (Material 3 bottom
/// navigation guidance) means less-frequent sections are grouped here. Each
/// entry pushes its own full screen, so the sections remain independent and
/// individually routable.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const List<_MoreEntry> _entries = [
    _MoreEntry(
      path: '/reviews',
      title: 'نظرات مشتریان',
      description: 'مدیریت نظرات و امتیازها',
      icon: Icons.star_rounded,
      tone: _EntryTone.amber,
    ),
    _MoreEntry(
      path: '/team',
      title: 'کاربران فروشگاه',
      description: 'مدیریت اعضای تیم و دسترسی‌ها',
      icon: Icons.group_rounded,
      tone: _EntryTone.blue,
    ),
    _MoreEntry(
      path: '/settings',
      title: 'تنظیمات',
      description: 'تنظیمات اعلان و پیکربندی',
      icon: Icons.settings_rounded,
      tone: _EntryTone.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('بیشتر')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return Card(
            child: ListTile(
              onTap: () => Navigator.of(context).pushNamed(entry.path),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: entry.tone.container(colorScheme),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  entry.icon,
                  color: entry.tone.foreground(colorScheme),
                  size: 20,
                ),
              ),
              title: Text(
                entry.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                entry.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          );
        },
      ),
    );
  }
}

class _MoreEntry {
  const _MoreEntry({
    required this.path,
    required this.title,
    required this.description,
    required this.icon,
    required this.tone,
  });

  final String path;
  final String title;
  final String description;
  final IconData icon;
  final _EntryTone tone;
}

enum _EntryTone {
  teal,
  amber,
  blue;

  Color container(ColorScheme scheme) => switch (this) {
    _EntryTone.teal => scheme.primaryContainer,
    _EntryTone.amber => const Color(0xFFFEF3C7),
    _EntryTone.blue => const Color(0xFFDBEAFE),
  };

  Color foreground(ColorScheme scheme) => switch (this) {
    _EntryTone.teal => scheme.onPrimaryContainer,
    _EntryTone.amber => const Color(0xFFB45309),
    _EntryTone.blue => const Color(0xFF1D4ED8),
  };
}
