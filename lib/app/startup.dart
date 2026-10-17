import 'package:flutter/foundation.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'startup.g.dart';

/// Soft-deleted transactions are kept this long for undo, then purged.
const Duration kSoftDeleteRetention = Duration(days: 7);

/// Runs once before the first frame of content: optional demo seed, purge
/// of old soft-deleted rows, and recurring materialisation.
@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final now = ref.read(clockProvider).now();

  if (kDebugMode && kSeedDemoFlag && await databaseIsEmpty(db)) {
    await seedDemoData(db, now: now);
    await ref.read(onboardingDoneProvider.notifier).set(done: true);
  }

  await ref.read(txnRepositoryProvider).purgeDeletedBefore(now.subtract(kSoftDeleteRetention));
  await ref.read(recurringRepositoryProvider).materializeDue();
}
