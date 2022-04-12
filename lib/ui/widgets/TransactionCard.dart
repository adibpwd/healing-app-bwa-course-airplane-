import 'package:airplane/models/transaction_model.dart';
import 'package:airplane/ui/widgets/booking_details_item.dart';
import 'package:airplane/ui/widgets/destination_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  TransactionCard(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: kWhiteColor,
      ),
      child: Column(
        children: [
          // NOTE : DESINATION TILE
          // DestinationTile(
          //   name: transaction.destination.name,
          //   city: transaction.destination.city,
          //   imageUrl: transaction.destination.imageUrl,
          // ),
          DestinationTile(transaction.destination),
          // NOTE : BOOKING DETAILS TEXT
          Container(
            margin: EdgeInsets.only(
              top: 30,
            ),
            child: Text(
              "Booking Details",
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ),
          // NOTE : BOOKING DETAILS ITEM
          BookingDetailsItem(
            title: 'Traveler',
            valueText: "${transaction.amountOfTraveler} Person",
            valueColor: kBlackColor,
          ),
          BookingDetailsItem(
            title: 'Seat',
            valueText: transaction.selectedSeats,
            valueColor: kBlackColor,
          ),
          BookingDetailsItem(
            title: 'Insurance',
            valueText: transaction.insurance ? "YES" : "NO",
            valueColor: transaction.insurance ? kGreenColor : kRedColor,
          ),
          BookingDetailsItem(
            title: 'Refundable',
            valueText: transaction.refundable ? "YES" : "NO",
            valueColor: transaction.refundable ? kGreenColor : kRedColor,
          ),
          BookingDetailsItem(
            title: 'VAT',
            valueText: "${(transaction.vat * 100).toStringAsFixed(0)}%",
            valueColor: kBlackColor,
          ),
          BookingDetailsItem(
            title: 'Price',
            valueText: NumberFormat.currency(
              locale: "id",
              symbol: "IDR ",
              decimalDigits: 0,
            ).format(transaction.price),
            valueColor: kBlackColor,
          ),
          BookingDetailsItem(
            title: 'Grand Total',
            valueText: NumberFormat.currency(
              locale: "id",
              symbol: "IDR ",
              decimalDigits: 0,
            ).format(transaction.grandTotal),
            valueColor: kPrimaryColor,
          ),
        ],
      ),
    );
    ;
  }
}
