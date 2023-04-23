import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:omni_datetime_picker/src/components/calendar.dart';
import 'package:omni_datetime_picker/src/components/custom_tab_bar.dart';
import 'package:omni_datetime_picker/src/components/time_picker_spinner.dart';

class OmniDtpRangeNormal extends StatefulWidget {
  const OmniDtpRangeNormal(
      {super.key,
      this.startInitialDate,
      this.startFirstDate,
      this.startLastDate,
      this.endInitialDate,
      this.endFirstDate,
      this.endLastDate,
      this.isShowSeconds,
      this.is24HourMode,
      this.minutesInterval,
      this.secondsInterval,
      this.isForce2Digits,
      this.constraints,
      this.type,
      this.selectableDayPredicate,
      this.onChange});

  final DateTime? startInitialDate;
  final DateTime? startFirstDate;
  final DateTime? startLastDate;

  final DateTime? endInitialDate;
  final DateTime? endFirstDate;
  final DateTime? endLastDate;

  final bool? isShowSeconds;
  final bool? is24HourMode;
  final int? minutesInterval;
  final int? secondsInterval;
  final bool? isForce2Digits;
  final BoxConstraints? constraints;
  final OmniDateTimePickerType? type;
  final bool Function(DateTime)? selectableDayPredicate;
  final Function(List<DateTime> dates)? onChange;

  @override
  State<OmniDtpRangeNormal> createState() => _OmniDtpRangeNormalState();
}

class _OmniDtpRangeNormalState extends State<OmniDtpRangeNormal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late DateTime selectedStartDateTime;
  late DateTime selectedEndDateTime;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    selectedStartDateTime = widget.startInitialDate ?? DateTime.now();
    selectedEndDateTime = widget.endInitialDate ?? DateTime.now();
    super.initState();
  }

  List<DateTime> onChange() {
    return [selectedStartDateTime, selectedEndDateTime];
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: widget.constraints ??
          const BoxConstraints(
            maxWidth: 350,
            maxHeight: 598,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTabBar(tabController: _tabController),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 550,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                PickerView(
                  type: widget.type,
                  initialDate: widget.startInitialDate,
                  firstDate: widget.startFirstDate,
                  lastDate: widget.startLastDate,
                  isShowSeconds: widget.isShowSeconds,
                  is24HourMode: widget.is24HourMode ?? false,
                  minutesInterval: widget.minutesInterval,
                  secondsInterval: widget.secondsInterval,
                  isForce2Digits: widget.isForce2Digits ?? false,
                  onDateChange: (value) {
                    DateTime tempDateTime = DateTime(
                      value.year,
                      value.month,
                      value.day,
                      selectedStartDateTime.hour,
                      selectedStartDateTime.minute,
                      widget.isShowSeconds ?? false
                          ? selectedStartDateTime.second
                          : 0,
                    );

                    setState(() {
                      selectedStartDateTime = tempDateTime;
                    });

                    widget.onChange?.call(onChange());
                  },
                  onTimeChange: (value) {
                    DateTime tempDateTime = DateTime(
                      selectedStartDateTime.year,
                      selectedStartDateTime.month,
                      selectedStartDateTime.day,
                      value.hour,
                      value.minute,
                      widget.isShowSeconds ?? false ? value.second : 0,
                    );

                    setState(() {
                      selectedStartDateTime = tempDateTime;
                    });
                    widget.onChange?.call(onChange());
                  },
                ),
                PickerView(
                  type: widget.type,
                  initialDate: widget.endInitialDate,
                  firstDate: widget.endFirstDate,
                  lastDate: widget.endLastDate,
                  isShowSeconds: widget.isShowSeconds,
                  is24HourMode: widget.is24HourMode ?? false,
                  minutesInterval: widget.minutesInterval,
                  secondsInterval: widget.secondsInterval,
                  isForce2Digits: widget.isForce2Digits ?? false,
                  onDateChange: (value) {
                    DateTime tempDateTime = DateTime(
                      value.year,
                      value.month,
                      value.day,
                      selectedEndDateTime.hour,
                      selectedEndDateTime.minute,
                      widget.isShowSeconds ?? false
                          ? selectedEndDateTime.second
                          : 0,
                    );

                    setState(() {
                      selectedEndDateTime = tempDateTime;
                    });
                    widget.onChange?.call(onChange());
                  },
                  onTimeChange: (value) {
                    DateTime tempDateTime = DateTime(
                      selectedEndDateTime.year,
                      selectedEndDateTime.month,
                      selectedEndDateTime.day,
                      value.hour,
                      value.minute,
                      widget.isShowSeconds ?? false ? value.second : 0,
                    );

                    setState(() {
                      selectedEndDateTime = tempDateTime;
                    });
                    widget.onChange?.call(onChange());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PickerView extends StatefulWidget {
  const PickerView(
      {super.key,
      this.initialDate,
      this.firstDate,
      this.lastDate,
      this.isShowSeconds,
      required this.onTimeChange,
      required this.onDateChange,
      this.is24HourMode,
      this.minutesInterval,
      this.secondsInterval,
      this.isForce2Digits,
      this.type,
      this.selectableDayPredicate});

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final bool? isShowSeconds;
  final bool? is24HourMode;
  final int? minutesInterval;
  final int? secondsInterval;
  final bool? isForce2Digits;

  final void Function(DateTime) onDateChange;
  final void Function(DateTime) onTimeChange;

  final bool Function(DateTime)? selectableDayPredicate;

  final OmniDateTimePickerType? type;

  @override
  State<PickerView> createState() => _PickerViewState();
}

class _PickerViewState extends State<PickerView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizations = MaterialLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Calendar(
          initialDate: widget.initialDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onDateChanged: widget.onDateChange,
          selectableDayPredicate: widget.selectableDayPredicate,
        ),
        if (widget.type == OmniDateTimePickerType.dateAndTime)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: TimePickerSpinner(
              time: widget.initialDate,
              amText: localizations.anteMeridiemAbbreviation,
              pmText: localizations.postMeridiemAbbreviation,
              isShowSeconds: widget.isShowSeconds ?? false,
              is24HourMode: widget.is24HourMode ?? false,
              minutesInterval: widget.minutesInterval ?? 1,
              secondsInterval: widget.secondsInterval ?? 1,
              isForce2Digits: widget.isForce2Digits ?? false,
              onTimeChange: widget.onTimeChange,
            ),
          ),
      ],
    );
  }
}
