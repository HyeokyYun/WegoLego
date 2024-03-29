import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatelessWidget {
  final bool? showSearchIcon;
  final bool? isSearching;
  final Color? searchBackgroundColor;
  final Color? searchTextHintColor;
  final Color? clearSearchButtonColor;
  final Color? searchTextColor;
  final FocusNode? searchFocusNode;
  final Function()? onClearButtonPressed;
  final Function(String)? onSearchQueryChanged;
  final Function(String)? onSearchQueryUpdated;
  final Function(String)? onEditingComplete;
  TextEditingController? searchQueryController;
  SearchField(
      {this.showSearchIcon = false,
      this.isSearching = false,
      this.searchBackgroundColor,
      this.searchTextColor,
      this.searchTextHintColor,
      this.clearSearchButtonColor,
      this.searchFocusNode,
      this.searchQueryController,
      this.onClearButtonPressed,
      this.onSearchQueryChanged,
      this.onSearchQueryUpdated,
      this.onEditingComplete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 43.0.h,
      width: 340.w,
      margin: showSearchIcon!
          ? const EdgeInsets.only(bottom: 3.5, top: 3.5, right: 2.0, left: 2.0)
          : isSearching!
              ? const EdgeInsets.only(bottom: 3.5, top: 3.5, right: 10.0)
              : const EdgeInsets.only(
                  bottom: 3.5, top: 3.5, right: 10.0, left: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: searchBackgroundColor ?? Colors.blueGrey.withOpacity(.2),
      ),
      child: TextField(
        controller: searchQueryController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffF5FAFA)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffFFA300)),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xffB1B1B1),
          ),
          filled: true,
          fillColor: Color(0xffF5F5F5),
          hintText: "Search...",
          suffixIcon: searchQueryController!.text.isNotEmpty
              ? IconButton(
                  alignment: Alignment.centerRight,
                  color: Color(0xffB1B1B1),
                  icon: const Icon(Icons.clear),
                  onPressed: onClearButtonPressed!,
                )
              : const SizedBox(
                  height: 0.0,
                  width: 0.0,
                ),
        ),
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: searchTextColor, fontSize: 16.0),
        onChanged: (query) => onSearchQueryChanged!(query),
        // onSubmitted: (query) => onSearchQueryUpdated!(query),
        // onEditingComplete: () => onEditingComplete!,
      ),
    );
  }
}
