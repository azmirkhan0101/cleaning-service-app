import 'package:cleaning_service_app/features/location/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationSearchWidget extends StatefulWidget {
  // final LocationController controller;
  final String hintText;
  final Function(Map<String, dynamic>)? onResultSelected;
  final bool showLabel;
  final String? labelText;

  const LocationSearchWidget({
    super.key,
    // required this.controller,
    this.hintText = "Search for a location...",
    this.onResultSelected,
    this.showLabel = false,
    this.labelText,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  late final LocationController controller;

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // Ensure controller exists before using it
    controller = Get.put(LocationController(), permanent: true);
    // Listen to text changes to update UI
    controller.selectedAddress.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks and setState after dispose
    controller.selectedAddress.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller.selectedAddress,
            onChanged: (value) {
              controller.searchLocations(value);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: controller.selectedAddress.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        controller.selectedAddress.clear();
                        controller.clearSearchResults();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),

        // Search results dropdown
        Obx(
          () =>
              controller.showSearchResults.value &&
                  controller.searchResults.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final result = controller.searchResults[index];
                      // print(result);
                      return InkWell(
                        onTap: () {
                          controller.selectSearchResult(result);
                          if (widget.onResultSelected != null) {
                            widget.onResultSelected!(result);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: index < controller.searchResults.length - 1
                                ? Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result['main_text']?.toString() ??
                                          'Unknown location',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if ((result['secondary_text']?.toString() ??
                                            '')
                                        .isNotEmpty) ...[
                                      SizedBox(height: 2),
                                      Text(
                                        result['secondary_text']?.toString() ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
