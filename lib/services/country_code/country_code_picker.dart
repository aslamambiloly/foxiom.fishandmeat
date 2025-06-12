import 'package:collection/collection.dart' show IterableExtension;
import 'package:country_flags/country_flags.dart';
import 'package:ecom_one/services/country_code/selection_dialog.dart';
import 'package:flutter/material.dart';

import 'country_code.dart';
import 'country_codes.dart';

export 'country_code.dart';

class CountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCode>? onChanged;
  final ValueChanged<CountryCode?>? onInit;
  final String? initialSelection;
  final List<String> favorite;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final WidgetBuilder? emptySearchBuilder;
  final Widget Function(CountryCode?)? builder;
  final bool showOnlyCountryWhenClosed;
  final bool alignLeft;
  final bool showFlag;
  final List<String> countryFilter;

  const CountryCodePicker({
    super.key,
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.favorite = const [],
    this.countryFilter = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.builder,
  });

  @override
  CountryCodePickerState createState() => CountryCodePickerState();
}

class CountryCodePickerState extends State<CountryCodePicker> {
  late List<CountryCode> _elements;
  late List<CountryCode> _favoriteElements;
  CountryCode? _selectedItem;

  @override
  void initState() {
    super.initState();

    // 1) Build full list
    _elements =
        codes
            .map(
              (s) => CountryCode(
                name: s['name'],
                code: s['code'],
                dialCode: s['dial_code'],
              ),
            )
            .toList();

    // 2) Apply filter if provided
    if (widget.countryFilter.isNotEmpty) {
      _elements =
          _elements
              .where((c) => widget.countryFilter.contains(c.code))
              .toList();
    }

    // 3) Initialize selection
    _selectedItem = _findInitial(widget.initialSelection, _elements);

    // 4) Callback onInit
    widget.onInit?.call(_selectedItem);

    // 5) Build favorites list
    _favoriteElements =
        _elements
            .where(
              (e) =>
                  widget.favorite.firstWhereOrNull(
                    (f) =>
                        e.code!.toUpperCase() == f.toUpperCase() ||
                        e.dialCode == f,
                  ) !=
                  null,
            )
            .toList();
  }

  @override
  void didUpdateWidget(covariant CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection ||
        oldWidget.countryFilter != widget.countryFilter) {
      // Rebuild elements if filter changed
      _elements =
          codes
              .map(
                (s) => CountryCode(
                  name: s['name'],
                  code: s['code'],
                  dialCode: s['dial_code'],
                ),
              )
              .toList();

      if (widget.countryFilter.isNotEmpty) {
        _elements =
            _elements
                .where((c) => widget.countryFilter.contains(c.code))
                .toList();
      }

      _selectedItem = _findInitial(widget.initialSelection, _elements);
      widget.onInit?.call(_selectedItem);

      _favoriteElements =
          _elements
              .where(
                (e) =>
                    widget.favorite.firstWhereOrNull(
                      (f) =>
                          e.code!.toUpperCase() == f.toUpperCase() ||
                          e.dialCode == f,
                    ) !=
                    null,
              )
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return InkWell(
        onTap: _showSelectionDialog,
        child: widget.builder!(_selectedItem),
      );
    }

    return TextButton(
      style: TextButton.styleFrom(padding: widget.padding),
      onPressed: _showSelectionDialog,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.showFlag && _selectedItem != null)
            Padding(
              padding:
                  widget.alignLeft
                      ? const EdgeInsets.only(right: 8.0, left: 8.0)
                      : const EdgeInsets.only(right: 8.0),
              child: CountryFlag.fromCountryCode(
                _selectedItem!.code!.toUpperCase(),
                height: 25.0,
                width: 25.0,
                shape: const RoundedRectangle(8),
              ),
            ),
          if (!widget.showOnlyCountryWhenClosed ||
              !(widget.showOnlyCountryWhenClosed && _selectedItem != null))
            Text(
              _selectedItem?.toCountryCodeString() ?? '',
              style:
                  widget.textStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontFamily: 'Sora-Bold',
                  ),
            ),
        ],
      ),
    );
  }

  CountryCode _findInitial(String? sel, List<CountryCode> list) {
    if (sel == null) return list.first;
    return list.firstWhere(
      (e) => e.code!.toUpperCase() == sel.toUpperCase() || e.dialCode == sel,
      orElse: () => list.first,
    );
  }

  void _showSelectionDialog() {
    showDialog<CountryCode>(
      context: context,
      builder:
          (_) => SelectionDialog(
            _elements,
            _favoriteElements,
            showCountryOnly: widget.showCountryOnly,
            emptySearchBuilder: widget.emptySearchBuilder,
            searchDecoration: widget.searchDecoration,
            searchStyle: widget.searchStyle,
            showFlag: widget.showFlag,
          ),
    ).then((selection) {
      if (selection != null) {
        setState(() {
          _selectedItem = selection;
        });
        widget.onChanged?.call(selection);
      }
    });
  }
}
