import 'dart:js_util';

import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';

import '../chrome_api.dart';
import 'summary_api_client.dart';

class ChromePopup extends StatefulWidget {
  const ChromePopup({super.key});

  @override
  State<ChromePopup> createState() => _ChromePopupState();
}

class _ChromePopupState extends State<ChromePopup> {
  late bool isLoading;
  late SummaryApiClient summaryApiClient;

  String? _summary;

  @override
  void initState() {
    isLoading = false;
    summaryApiClient = SummaryApiClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/atomsbox_logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            AppText.bodySmall(' for Chrome'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppExpansionTile.gradient(
                      title: AppText('Summary #1'),
                      children: [AppText('Placeholder')],
                    ),
                    const SizedBox(height: AppConstants.sm),
                    AppExpansionTile.gradient(
                      title: AppText('Summary #2'),
                      children: [AppText('Placeholder')],
                    ),
                    const SizedBox(height: AppConstants.sm),
                    AppExpansionTile.gradient(
                      title: AppText('Summary #3'),
                      children: [AppText('Placeholder')],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppConstants.sm),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppConstants.xlg * 4),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [CircularProgressIndicator()],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(_summary ?? 'Choose which tab to summarize'),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String url = await selectUrl();

          setState(() {
            isLoading = true;
          });

          String summary = await getSummary(url);

          setState(() {
            _summary = summary;
            isLoading = false;
          });
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
        label: AppText('Summarize'),
      ),
    );
  }

  Future<String> selectUrl() async {
    List tab = await promiseToFuture(
      query(ParameterQueryTabs(active: true, lastFocusedWindow: true)),
    );
    return tab[0].url;
  }

  Future<String> getSummary(String url) async {
    return summaryApiClient.getSummary(url);
  }
}