// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: test/helpers/mock_supabase_service.dart
// PURPOSE: Generates a MockSupabaseService via mockito for provider and service tests
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:mockito/annotations.dart';
import 'package:boo_mondai/services/supabase_service.dart';

@GenerateMocks([SupabaseService])
export 'mock_supabase_service.mocks.dart';
