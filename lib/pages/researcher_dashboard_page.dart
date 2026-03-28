// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard_page.dart
// PURPOSE: Researcher dashboard — manage codes, view participants and results
// PROVIDERS: ResearchProvider, AuthProvider
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/pages/researcher_dashboard/dashboard_tab_bar.dart';
import 'package:boo_mondai/pages/researcher_dashboard/codes_tab.dart';
import 'package:boo_mondai/pages/researcher_dashboard/participants_tab.dart';
import 'package:boo_mondai/pages/researcher_dashboard/results_tab.dart';

class ResearcherDashboardPage extends HookWidget {
  const ResearcherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final research = context.watch<ResearchProvider>();
    final auth = context.read<AuthProvider>();
    final tabIndex = useState(0);

    useEffect(() {
      Future.microtask(
          () => context.read<ResearchProvider>().fetchAllResearchData());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Dashboard'),
      ),
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
                        researcherId: auth.userProfile?.id ?? '',
                      ),
                      ParticipantsTab(
                        participants: research.researchUsers,
                      ),
                      ResultsTab(
                        testResults: research.testResults,
                        proficiencyData: research.proficiencyData,
                        languageInterestData: research.languageInterestData,
                        experienceSurveyData: research.experienceSurveyData,
                        previewUsefulnessData: research.previewUsefulnessData,
                        fsrsUsefulnessData: research.fsrsUsefulnessData,
                        ugcData: research.ugcData,
                        susData: research.susData,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
