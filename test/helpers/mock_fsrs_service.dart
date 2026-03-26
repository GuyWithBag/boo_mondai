// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/mock_fsrs_service.dart
// PURPOSE: Generates a MockFsrsService via mockito for provider and service tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:mockito/annotations.dart';
import 'package:boo_mondai/services/fsrs_service.dart';

@GenerateMocks([FsrsService])
export 'mock_fsrs_service.mocks.dart';
