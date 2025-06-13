import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import 'country_code.dart';

class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    super.key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.showFlag,
  }) : searchDecoration = searchDecoration.copyWith(
         prefixIcon: Icon(Icons.search),
       );

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  late List<CountryCode> filteredElements;

  @override
  Widget build(BuildContext context) => SimpleDialog(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Select country code'),
        SizedBox(height: 20),
        TextField(
          style: TextStyle(fontFamily: 'Sora', fontSize: 12),
          decoration: InputDecoration(
            filled: true,
            hintText: "Search Country",
            hintStyle: TextStyle(fontFamily: 'Sora', fontSize: 12),
            border: InputBorder.none,
            fillColor: Colors.grey[800]
          ),
          onChanged: _filterElements,
        ),
      ],
    ),
    children: [
      Container(
        margin: EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            widget.favoriteElements.isEmpty
                ? DecoratedBox(decoration: BoxDecoration())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...widget.favoriteElements.map(
                      (f) => SimpleDialogOption(
                        child: _buildOption(f),
                        onPressed: () {
                          _selectItem(f);
                        },
                      ),
                    ),
                    Divider(),
                  ],
                ),
            ...filteredElements.isEmpty
                ? [_buildEmptySearchWidget(context)]
                : filteredElements.map(
                  (e) => SimpleDialogOption(
                    key: Key(e.toLongString()),
                    child: _buildOption(e),
                    onPressed: () {
                      _selectItem(e);
                    },
                  ),
                ),
          ],
        ),
      ),
    ],
  );

  Widget _buildOption(CountryCode e) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        widget.showFlag!
            ? Flexible(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CountryFlag.fromCountryCode(
                  e.code!.toUpperCase(),
                  height: 25.0,
                  width: 25.0,
                  shape: const RoundedRectangle(8),
                ),
              ),
            )
            : Container(),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(e.toLongString())),
              Text(e.dialCode!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }
    return Center(child: Text('No Country Found'));
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements =
          widget.elements
              .where(
                (e) =>
                    e.code!.contains(s) ||
                    e.dialCode!.contains(s) ||
                    e.name!.toUpperCase().contains(s),
              )
              .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
