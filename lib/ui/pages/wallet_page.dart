import 'package:airplane/cubit/auth_cubit.dart';
import 'package:airplane/cubit/topup_cubit.dart';
import 'package:airplane/cubit/transaction_cubit.dart';
import 'package:airplane/models/topup_model.dart';
import 'package:airplane/models/transaction_model.dart';
import 'package:airplane/services/user_service.dart';
import 'package:airplane/shared/theme.dart';
import 'package:airplane/ui/widgets/TransactionCard.dart';
import 'package:airplane/ui/widgets/custom_button.dart';
import 'package:airplane/ui/widgets/custom_text_form_field.dart';
import 'package:airplane/ui/widgets/topup_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nominalTopupController = TextEditingController();
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  late TabController tabC;
  int indexTab = 0;

  @override
  void initState() {
    super.initState();

    UserService().getUserId().then((uid) {
      context.read<TransactionCubit>().fetchTransactions(uid);
      context.read<TopupCubit>().fetchTopups(uid);
    });

    tabC = TabController(length: 2, vsync: this);
    tabC.addListener(() {
      setState(() {
        indexTab = tabC.index;
      });
    });
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget inputNominalTopup() {
      return CustomTextFormField(
        title: "Nominal",
        hintText: "Fil nominal topup",
        controller: nominalTopupController,
        keyboardType: TextInputType.number,
        onChanged: (string) {
          string = '${formNum(
            string.replaceAll(',', ''),
          )}';
          nominalTopupController.value = TextEditingValue(
            text: string,
            selection: TextSelection.collapsed(
              offset: string.length,
            ),
          );
        },
      );
    }

    Widget outView() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TransactionLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TransactionSuccess) {
            if (state.transactions.length == 0) {
              return Center(child: Text("Transaction not found"));
            } else {
              return ListView.builder(
                itemCount: state.transactions.length,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultMargin,
                  vertical: defaultMargin,
                ),
                itemBuilder: (context, index) {
                  TransactionModel transaction = state.transactions[index];
                  return ListTile(
                    leading: ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(24),
                        child: Image(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              transaction.destination.imageUrl),
                        ),
                      ),
                    ),
                    subtitle: Text(
                      transaction.destination.city +
                          " - " +
                          transaction.destination.name,
                    ),
                    title: Text(
                      NumberFormat.currency(
                        locale: "id",
                        symbol: "IDR ",
                        decimalDigits: 0,
                      ).format(transaction.grandTotal),
                    ),
                  );
                },
              );
            }
          }
          if (state is TransactionFailed) {
            return Center(
              child: Text('Failed'),
            );
          }
          return Center(
            child: Text('Loading'),
          );
        },
      );
    }

    Widget inView() {
      return BlocConsumer<TopupCubit, TopupState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TopupLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TopupSuccess) {
            if (state.topups.length == 0) {
              return Center(child: Text("Transaction not found"));
            } else {
              return ListView.builder(
                itemCount: state.topups.length,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultMargin,
                  vertical: defaultMargin,
                ),
                itemBuilder: (context, index) {
                  TopupModel topup = state.topups[index];
                  return TopupTile(topup);
                },
              );
            }
            // return Text('sucess bos');
          }
          if (state is TopupFailed) {
            return Center(
              child: Text('Failed'),
            );
          }
          return Center(
            child: Text('Loading'),
          );
        },
      );
    }

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AuthSuccess) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 300,
                        height: 211,
                        padding: EdgeInsets.all(defaultMargin),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/image_card.png",
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.5),
                              blurRadius: 50,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name",
                                        style: whiteTextStyle.copyWith(
                                          fontWeight: light,
                                        ),
                                      ),
                                      Text(
                                        state.user.name,
                                        style: whiteTextStyle.copyWith(
                                          fontSize: 20,
                                          fontWeight: medium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: EdgeInsets.only(
                                    right: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icon_plane.png",
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Pay',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: medium,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              "Balance",
                              style: whiteTextStyle.copyWith(
                                fontWeight: light,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: "id",
                                symbol: "IDR ",
                                decimalDigits: 0,
                              ).format(state.user.balance),
                              style: whiteTextStyle.copyWith(
                                fontSize: 26,
                                fontWeight: medium,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    DefaultTabController(
                      length: 2,
                      child: TabBar(
                        controller: tabC,
                        unselectedLabelColor: kBlackColor,
                        labelColor: kPrimaryColor,
                        tabs: [
                          Tab(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_downward,
                                  color: kGreenColor,
                                ),
                                Text("In"),
                              ],
                            ),
                            // text: "In",
                            // icon: ,
                          ),
                          Tab(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  color: kRedColor,
                                ),
                                Text("Out"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (indexTab == 0) ...[
                      Flexible(
                        child: inView(),
                      ),
                    ],
                    if (indexTab == 1) ...[
                      Flexible(
                        child: outView(),
                      )
                    ],
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 100.0),
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.add),
                  label: Text('Top up'),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Container(
                              padding: EdgeInsets.all(24),
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: ListView(
                                children: [
                                  inputNominalTopup(),
                                  CustomButton(
                                    title: "Top up",
                                    onPressed: () {
                                      context.read<TopupCubit>().topup(
                                            nominal: int.parse(
                                                nominalTopupController.text
                                                    .replaceAll(',', '')),
                                            user_id: state.user.id,
                                            balanceNow: state.user.balance,
                                          );
                                      context
                                          .read<AuthCubit>()
                                          .getCurentUser(state.user.id);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
