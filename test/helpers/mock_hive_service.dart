// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/mock_hive_service.dart
// PURPOSE: Generates a MockHiveService via mockito for provider and service tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:mockito/annotations.dart';
import 'package:boo_mondai/services/hive_service.dart';

@GenerateMocks([HiveService])
export 'mock_hive_service.mocks.dart';
