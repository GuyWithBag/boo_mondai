// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/research_code_entry_page.dart
// PURPOSE: Code entry screen for unlocking research study flows
// PROVIDERS: ResearchProvider, AuthProvider
// HOOKS: useTextEditingController, useFocusNode, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ResearchCodeEntryPage extends HookWidget {
  const ResearchCodeEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final step = useState<_Step>(_Step.code);
    final pendingRole = useState<String?>(null);
    final pendingUnlock = useState<String?>(null);

    return switch (step.value) {
      _Step.code => _CodeStep(
          onOnboarding: (unlock, role) {
            pendingRole.value = role;
            pendingUnlock.value = unlock;
            step.value = _Step.demographics;
          },
          onNavigate: (route) => context.go(route),
        ),
      _Step.demographics => _DemographicsStep(
          role: pendingRole.value!,
          unlock: pendingUnlock.value!,
          onComplete: (route) => context.go(route),
        ),
    };
  }
}

enum _Step { code, demographics }

// ── Code entry step ─────────────────────────────────────

class _CodeStep extends HookWidget {
  final void Function(String unlock, String role) onOnboarding;
  final void Function(String route) onNavigate;

  const _CodeStep({required this.onOnboarding, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final codeController = useTextEditingController();
    final codeFocus = useFocusNode();
    final research = context.watch<ResearchProvider>();
    final auth = context.watch<AuthProvider>();
    final message = useState<String?>(null);

    useEffect(() {
      codeFocus.requestFocus();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter your researcher code',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: codeController,
                    focusNode: codeFocus,
                    decoration: const InputDecoration(
                      hintText: 'e.g. VOCAB-A-001',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  if (research.error != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ErrorText(research.error!),
                  ],
                  if (message.value != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      message.value!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: research.isLoading
                        ? null
                        : () async {
                            final code = codeController.text.trim();
                            if (code.isEmpty) return;
                            final userId = auth.userProfile?.id;
                            if (userId == null) return;

                            final unlocked = await context
                                .read<ResearchProvider>()
                                .redeemCode(userId, code);

                            if (unlocked == null || !context.mounted) return;

                            if (unlocked == 'onboarding_group_a' ||
                                unlocked == 'onboarding_group_b') {
                              final role = unlocked == 'onboarding_group_a'
                                  ? 'group_a_participant'
                                  : 'group_b_participant';
                              onOnboarding(unlocked, role);
                              return;
                            }

                            final route = _routeForUnlock(unlocked);
                            if (route != null) {
                              onNavigate(route);
                            } else {
                              message.value = 'Unlocked: $unlocked';
                              codeController.clear();
                            }
                          },
                    child: research.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Redeem Code'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Demographics step (shown after onboarding code) ──────

class _DemographicsStep extends HookWidget {
  final String role;
  final String unlock;
  final void Function(String route) onComplete;

  const _DemographicsStep({
    required this.role,
    required this.unlock,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final ageController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final research = context.watch<ResearchProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Participant Details')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tell us about yourself',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'This information is used for research purposes only.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(labelText: 'First name'),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Last name'),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n < 1 || n > 120) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                    ),
                    if (research.error != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      ErrorText(research.error!),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: research.isLoading
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              final userId = auth.userProfile?.id;
                              if (userId == null) return;

                              await context
                                  .read<ResearchProvider>()
                                  .addResearchProfile(
                                    userId: userId,
                                    role: role,
                                    targetLanguage:
                                        auth.userProfile?.targetLanguage ??
                                            'japanese',
                                    firstName: firstNameController.text.trim(),
                                    lastName: lastNameController.text.trim(),
                                    age: int.parse(ageController.text.trim()),
                                    userName: auth.userProfile?.userName,
                                  );

                              if (!context.mounted) return;
                              if (context.read<ResearchProvider>().error !=
                                  null) return;

                              final route = _routeForUnlock(unlock);
                              if (route != null) onComplete(route);
                            },
                      child: research.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? _routeForUnlock(String unlocks) {
  switch (unlocks) {
    case 'onboarding_group_a':
    case 'onboarding_group_b':
      return '/research/survey/proficiency_screener';
    case 'vocabulary_test_a':
      return '/research/test/A';
    case 'vocabulary_test_b':
      return '/research/test/B';
    case 'experience_survey_short_term':
      return '/research/survey/experience_survey?timePoint=short_term';
    case 'experience_survey_long_term':
      return '/research/survey/experience_survey?timePoint=long_term';
    case 'preview_usefulness':
      return '/research/survey/preview_usefulness';
    case 'fsrs_usefulness':
      return '/research/survey/fsrs_usefulness';
    case 'ugc_perception':
      return '/research/survey/ugc_perception';
    case 'sus':
      return '/research/survey/sus';
    default:
      return null;
  }
}
