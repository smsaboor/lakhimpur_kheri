import 'package:lakhimpur_kheri/zCountryPicker/country.dart';
import 'package:lakhimpur_kheri/zCountryPicker/countries.dart';
import 'package:lakhimpur_kheri/zCountryPicker/utils/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:lakhimpur_kheri/zCountryPicker/utils/utils.dart';

///Provides a customizable [DropdownButton] for all countries
class CountryPickerDropdown extends StatefulWidget {
  CountryPickerDropdown({
    this.itemFilter,
    this.sortComparator,
    this.priorityList,
    this.itemBuilder,
    this.initialValue,
    this.onValuePicked,
    this.isExpanded = false,
  });

  /// Filters the available country list
  final ItemFilter itemFilter;

  /// [Comparator] to be used in sort of country list
  final Comparator<Country> sortComparator;

  /// List of countries that are placed on top
  final List<Country> priorityList;

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and phoneCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final ItemBuilder itemBuilder;

  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in countryList map of countries.dart file.
  final String initialValue;

  ///This function will be called whenever a Country item is selected.
  final ValueChanged<Country> onValuePicked;

  /// Boolean property to enabled/disable expanded property of DropdownButton
  final bool isExpanded;

  @override
  _CountryPickerDropdownState createState() => _CountryPickerDropdownState();
}

class _CountryPickerDropdownState extends State<CountryPickerDropdown> {
  List<Country> _countries;
  Country _selectedCountry;

  @override
  void initState() {
    _countries =
        countryList.where(widget.itemFilter ?? acceptAllCountries).toList();

    if (widget.sortComparator != null) {
      _countries.sort(widget.sortComparator);
    }

    if (widget.priorityList != null) {
      widget.priorityList.forEach((Country country) =>
          _countries.removeWhere((Country c) => country.isoCode == c.isoCode));
      _countries.insertAll(0, widget.priorityList);
    }

    if (widget.initialValue != null) {
      try {
        _selectedCountry = _countries.firstWhere(
              (country) => country.isoCode == widget.initialValue.toUpperCase(),
        );
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    } else {
      _selectedCountry = _countries[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Country>> items = _countries
        .map((country) => DropdownMenuItem<Country>(
        value: country,
        child: widget.itemBuilder != null
            ? widget.itemBuilder(country)
            : _buildDefaultMenuItem(country)))
        .toList();

    return Row(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            isDense: true,
            isExpanded: widget.isExpanded,
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
                widget.onValuePicked(value);
              });
            },
            items: items,
            value: _selectedCountry,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultMenuItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("(${country.isoCode}) +${country.phoneCode}"),
      ],
    );
  }
}
