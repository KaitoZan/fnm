import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'filter_ctrl.dart';


class SearchBarFilter extends StatelessWidget {
  final String tag;

  const SearchBarFilter({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.find<FilterController>();
    
    final TextEditingController currentController = tag == 'home'
        ? filterController.homeSearchInputController
        : filterController.favSearchInputController;
        
    final FocusNode currentFocusNode = tag == 'home'
        ? filterController.homeSearchFocusNode
        : filterController.favSearchFocusNode;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: currentController,
              focusNode: currentFocusNode,
              decoration: InputDecoration(
                hintText: 'ค้นหา...',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.grey[700], size: 18),
                  onPressed: () {
                    filterController.applyFilters();
                    filterController.clearSearchFocus(tag);
                  },
                ),
              ),
              onSubmitted: (value) {
                filterController.applyFilters();
                filterController.clearSearchFocus(tag);
              },
              onTapOutside: (event) {
                 filterController.clearSearchFocus(tag);
              },
              autofocus: false,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}