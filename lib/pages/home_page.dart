import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:bills_calculator/basic_components/bill_card.dart';
import 'package:bills_calculator/basic_components/drawer.dart';
import 'package:bills_calculator/basic_components/floating_new_bill_button.dart';
import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/models/months.dart';
import 'package:bills_calculator/pages/add_bill_page.dart';
import 'package:bills_calculator/core/bills_provider.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

String initialFilter = 'unpaid';
String initialCurrency = 'lei';
double totalOfSelected = 0;
double totalPerPerson = 0;

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = Auth().currentUser;

  Widget generateBillsWidget(BillsProvider billsProvider) {
    if (billsProvider.loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (billsProvider.selectedBillsForMonth.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height / 1.8,
        child: RefreshIndicator(
          onRefresh: () {
            return _databaseService.getBills(context);
          },
          child: ListView(
              shrinkWrap: true,
              children: billsProvider.selectedBillsForMonth
                  .map((e) => BillCard(e))
                  .toList()),
        ),
      );
    } else {
      return const Center(child: Text('No Bills'));
    }
  }

  @override
  void initState() {
    _databaseService.getBills(context).then((bills) {
      Provider.of<BillsProvider>(context, listen: false)
          .changeSelectedBills(initialFilter);
      Provider.of<BillsProvider>(context, listen: false)
          .changeMonthFilter(months.first.name);
    });

    Provider.of<BillsProvider>(context, listen: false).addListener(() {
      List<Bill> bills = Provider.of<BillsProvider>(context, listen: false)
          .selectedBillsForMonth;
      setState(() {
        totalOfSelected = 0;
        totalPerPerson = 0;
        if (bills.isNotEmpty) {
          initialCurrency = bills[0].currency;
          for (var i = 0; i < bills.length; i++) {
            totalOfSelected += bills[i].total;
          }
          totalPerPerson = totalOfSelected / bills[0].nrOfPeople;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(AppLocalizations.of(context)!.homeTitle),
        drawer: BillsDrawer(),
        body: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownMenu<Month>(
                  expandedInsets: EdgeInsets.zero,
                  initialSelection: months.first,
                  dropdownMenuEntries: months.map((Month month) {
                    return DropdownMenuEntry<Month>(
                      value: month,
                      label: Provider.of<LanguageProvider>(context).locale ==
                              const Locale('ro')
                          ? month.romanianName
                          : month.name,
                    );
                  }).toList(),
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        Provider.of<BillsProvider>(context, listen: false)
                            .changeMonthFilter(value.name);
                      });
                    }
                  },
                ),
                SegmentedButton(
                  segments: [
                    ButtonSegment(
                        value: 'unpaid',
                        label: Text(
                          AppLocalizations.of(context)!.segmentedUnpaid,
                          style:
                              const TextStyle(fontSize: GlobalThemeVariables.p),
                        ),
                        enabled: true),
                    ButtonSegment(
                        value: 'paid',
                        label: Text(
                          AppLocalizations.of(context)!.segmentedPaid,
                          style:
                              const TextStyle(fontSize: GlobalThemeVariables.p),
                        ),
                        enabled: true),
                    ButtonSegment(
                        value: 'all',
                        label: Text(
                          AppLocalizations.of(context)!.segmentedAll,
                          style:
                              const TextStyle(fontSize: GlobalThemeVariables.p),
                        ),
                        enabled: true)
                  ],
                  selected: {initialFilter},
                  onSelectionChanged: (newFilter) {
                    setState(() {
                      Provider.of<BillsProvider>(context, listen: false)
                          .changeSelectedBills(newFilter.first);
                      initialFilter = newFilter.first;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${totalOfSelected.toStringAsFixed(2)} $initialCurrency',
                          style:
                              const TextStyle(fontSize: GlobalThemeVariables.p),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.totalPerPerson}${totalPerPerson.toStringAsFixed(2)} $initialCurrency',
                          style:
                              const TextStyle(fontSize: GlobalThemeVariables.p),
                        )
                      ]),
                ),
                Consumer<BillsProvider>(
                    builder: (context, billsProvider, child) {
                  return generateBillsWidget(billsProvider);
                })
              ],
            )),
        floatingActionButton: FloatingNewBillButton('New Bill', () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddBillFormPage()));
        }));
  }
}
