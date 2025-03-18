import 'package:bills_calculator/basic_components/app_bar.dart';
import 'package:bills_calculator/basic_components/bill_card.dart';
import 'package:bills_calculator/basic_components/drawer.dart';
import 'package:bills_calculator/core/auth.dart';
import 'package:bills_calculator/core/database_service.dart';
import 'package:bills_calculator/core/language_provider.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/models/months.dart';
import 'package:bills_calculator/pages/add_bill_page.dart';
import 'package:bills_calculator/core/bills_provider.dart';
import 'package:bills_calculator/pages/existing_bills_page.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

String initialFilter = 'unpaid';
List<String> slideFilter = ['paid', 'unpaid', 'all'];
String initialCurrency = 'lei';
double totalOfSelected = 0;
double totalPerPerson = 0;
bool isSelectionMode = false;
Map<int, bool> selectedFlag = {};

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

  slidePaidFilter(direction) {
    int currentIndex = slideFilter.indexOf(initialFilter);
    if (direction == 'left') {
      if (currentIndex == 0) {
        initialFilter = slideFilter[slideFilter.length - 1];
      } else {
        initialFilter = slideFilter[currentIndex - 1];
      }
    } else {
      if (currentIndex == slideFilter.length - 1) {
        initialFilter = slideFilter[0];
      } else {
        initialFilter = slideFilter[currentIndex + 1];
      }
    }
    Provider.of<BillsProvider>(context, listen: false)
        .changeSelectedBills(initialFilter);
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

  Widget _buildSelectIcon(bool isSelected, Bill data) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text('${data.name}'),
      );
    }
  }

  generateMultiSelectItems(List<Bill> bills) {
    return MultiSelectContainer(
        prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
            disabledPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.do_disturb_alt_sharp,
                size: 14,
              ),
            )),
        items: bills.map(
          (e) {
            return MultiSelectCard(value: e, label: '${e.name} - ${e.month}');
          },
        ).toList(),
        onChange: (allSelectedItems, selectedItem) {
          print(allSelectedItems);
          Provider.of<BillsProvider>(context, listen: false).billsToEdit =
              allSelectedItems;
        });
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (Provider.of<BillsProvider>(context, listen: false)
                .bills
                .isNotEmpty) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title:
                      const Text('Create new or continue with existing bills?'),
                  content: const Text(''),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddBillFormPage()));
                      },
                      child: const Text('New Bill'),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text('Select bills to continue with'),
                                content: generateMultiSelectItems(
                                    Provider.of<BillsProvider>(context,
                                            listen: false)
                                        .bills),
                                actions: [
                                  TextButton(
                                    child: const Text('Continue with selected'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ExistingBillsPage()));
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: const Text('Continue with existing'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddBillFormPage()));
            }
          },
          label: Text('New Bill'),
          icon: const Icon(Icons.add),
        ));
  }
}
