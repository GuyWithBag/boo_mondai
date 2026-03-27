// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/research_code_entry_page.dart
// PURPOSE: Code entry screen for unlocking research study flows
// PROVIDERS: ResearchProvider, AuthProvider
// HOOKS: useTextEditingController, useFocusNode
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class ResearchCodeEntryPage extends HookWidget {
  const ResearchCodeEntryPage({super.key});

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
                            if (unlocked != null && context.mounted) {
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
