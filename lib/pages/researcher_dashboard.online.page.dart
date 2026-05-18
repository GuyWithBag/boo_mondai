// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard_page.dart
// PURPOSE: Researcher dashboard — manage codes, view participants and results
// PROVIDERS: ResearchController, AuthController
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';

class ResearcherDashboardPage extends HookWidget {
  const ResearcherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final research = context.watch<ResearchController>();
    final auth = context.read<AuthController>();
    final tabIndex = useState(0);
    final controller = context.read<ResearchController>();

    useEffect(() {
      Future.microtask(() => controller.fetchAllResearchData());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Research Dashboard')),
      body: research.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DashboardTabBar(
                  selectedIndex: tabIndex.value,
                  onChanged: (i) => tabIndex.value = i,
                ),
                Expanded(
                  child: IndexedStack(
                    index: tabIndex.value,
                    children: [
                      CodesTab(
                        codes: research.codes,
                        researcherId: auth.currentProfile.id,
                      ),
                      ParticipantsTab(participants: research.researchProfiles),
                      ResultsTab(
                        surveyResponses: research.surveyResponses,
                        testResults: research.testResults,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
