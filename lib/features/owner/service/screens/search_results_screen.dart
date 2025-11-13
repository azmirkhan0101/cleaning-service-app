import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/owner/service/models/search_filter_model.dart';
import 'package:cleaning_service_app/features/owner/service/models/service_model.dart';
import 'package:cleaning_service_app/features/owner/service/screens/owner_service_details_screen.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<FilteredService> services;
  final int totalResults;
  final AppliedFilters? appliedFilters;

  const SearchResultsScreen({
    super.key,
    required this.services,
    required this.totalResults,
    this.appliedFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Search Result', backButton: true),

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips row (if any filters applied)
            if (appliedFilters != null)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (appliedFilters!.categoryId != null)
                    _buildFilterChip('Category: ${appliedFilters!.categoryId}'),
                  if (appliedFilters!.date != null)
                    _buildFilterChip('Date: ${appliedFilters!.date}'),
                  if (appliedFilters!.time != null)
                    _buildFilterChip('Time: ${appliedFilters!.time}'),
                  if (appliedFilters!.experience != null)
                    _buildFilterChip(
                      'Experience: ${appliedFilters!.experience}',
                    ),
                  if (appliedFilters!.instantBooking != null)
                    _buildFilterChip(
                      'Instant: ${appliedFilters!.instantBooking}',
                    ),
                  if (appliedFilters!.gender != null)
                    _buildFilterChip('Gender: ${appliedFilters!.gender}'),
                  if (appliedFilters!.language != null)
                    _buildFilterChip('Language: ${appliedFilters!.language}'),
                  if (appliedFilters!.priceRange != null &&
                      appliedFilters!.priceRange!.min.isNotEmpty &&
                      appliedFilters!.priceRange!.max.isNotEmpty)
                    _buildFilterChip(
                      'Price: €${appliedFilters!.priceRange!.min} - €${appliedFilters!.priceRange!.max}',
                    ),
                ],
              ),
            const SizedBox(height: 12),
            // Grid of service cards
            Expanded(
              child: services.isEmpty
                  ? Center(
                      child: Text(
                        'No services found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final s = services[index];
                        final serviceModel = ServiceModel(
                          id: s.id,
                          serviceName: s.serviceName,
                          serviceImage: s.serviceImage,
                          averageRatings: s.averageRating,
                          providerName: s.providerName,
                          providerProfilePicture: s.providerProfilePicture,
                          isApprovalRequired:
                              false, // Not available in FilteredService
                          price: s.rateByHour,
                        );
                        return GestureDetector(
                          onTap: () => Get.to(
                            () => OwnerServiceDetailsScreen(),
                            arguments: {'serviceId': serviceModel.id},
                          ),
                          child: ServiceCard(service: serviceModel),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
