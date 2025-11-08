# Booking Integration Summary

## Overview

The booking system has been successfully refactored to support both OWNER and PROVIDER roles using a unified codebase with role-aware API endpoint selection.

## Architecture

### Role Detection

- Uses `AppStorageService.getUserRole()` to determine if the logged-in user is "OWNER" or "PROVIDER"
- All controllers automatically select the appropriate endpoints based on the detected role

### API Endpoints Structure

#### Owner Endpoints

- `GET /booking/my-bookings?limit=X&page=Y` - All bookings (with pagination)
- `GET /booking/owner/pending-bookings` - Pending bookings (array response)
- `GET /booking/owner/ongoing-bookings` - Ongoing bookings (array response)
- `GET /booking/owner/completed-bookings` - Completed bookings (array response)
- `GET /booking/owner/cancelled-bookings` - Cancelled bookings (array response)

#### Provider Endpoints

- `GET /booking/provider-bookings?limit=X&page=Y` - All bookings (with pagination)
- `GET /booking/provider/pending-bookings` - Pending bookings (array response)
- `GET /booking/provider/ongoing-bookings` - Ongoing bookings (array response)
- `GET /booking/provider/completed-bookings` - Completed bookings (array response)
- `GET /booking/provider/cancelled-bookings` - Cancelled bookings (array response)

## Controllers

### OwnerBookingController

**Location**: `lib/features/bookings/controllers/owner_booking_controller.dart`

**Responsibilities**:

- Manages "All" tab with pagination (page, limit, hasMore, isLoadingMore)
- Orchestrates 4 separate status-specific controllers
- Provides unified interface via `currentBookings` and `isCurrentlyLoading` getters
- Implements infinite scroll with ScrollController
- Role-aware: Automatically selects owner or provider endpoints

**Key Methods**:

- `fetchAllBookings()` - Fetches all bookings with pagination
- `loadMoreBookings()` - Loads next page when user scrolls near bottom
- `refreshBookings()` - Refreshes current tab data
- `filterServices(int index)` - Switches between tabs

**Key Properties**:

- `userRole` - Current user's role (OWNER/PROVIDER)
- `isProvider` - Boolean indicating if user is a provider
- `_allBookingsEndpoint` - Dynamically returns correct endpoint based on role

### Status-Specific Controllers

Each status has its own controller that works identically for both roles:

#### PendingBookingsController

- Endpoint: `ownerPendingBookings` or `providerPendingBookings`
- Method: `fetchPendingBookings()`

#### OngoingBookingsController

- Endpoint: `ownerOngoingBookings` or `providerOngoingBookings`
- Method: `fetchOngoingBookings()`

#### CompletedBookingsController

- Endpoint: `ownerCompletedBookings` or `providerCompletedBookings`
- Method: `fetchCompletedBookings()`

#### CancelledBookingsController

- Endpoint: `ownerCancelledBookings` or `providerCancelledBookings`
- Method: `fetchCancelledBookings()`

## UI Screens

### OwnerBookingScreen

**Location**: `lib/features/bookings/screens/owner_booking_screen.dart`

**Features**:

- Works for both OWNER and PROVIDER roles
- 5 tabs: All, Pending, Ongoing, Completed, Cancelled
- Infinite scroll pagination on "All" tab only
- Pull-to-refresh on all tabs
- Empty state messages
- Loading indicators (initial load and load more)

### ProviderBookingsScreen

**Location**: `lib/features/bookings/screens/provider_bookings_screen.dart`

**Status**: Now identical to OwnerBookingScreen

- Uses same OwnerBookingController
- Same UI implementation
- Automatically uses provider endpoints when provider is logged in

## Data Models

### BookingsResponseModel

**Location**: `lib/features/bookings/models/booking_model.dart`

**Factory Methods**:

1. `fromJson(Map<String, dynamic> json)` - For paginated responses
   - Structure: `{success, message, data: {bookings: [], page, totalPages, totalCount}}`

2. `fromArrayJson(Map<String, dynamic> json)` - For status-specific endpoints
   - Structure: `{success, message, data: [...]}`

## How It Works

### Initialization

1. User opens booking screen (owner or provider)
2. Controller detects role via `AppStorageService.getUserRole()`
3. Fetches "All" bookings from appropriate endpoint
4. Initializes all 4 status-specific controllers

### Tab Switching

1. User taps a tab (e.g., "Pending")
2. `filterServices(index)` is called
3. Controller returns appropriate data via `currentBookings` getter
4. If tab data is empty, triggers fetch from appropriate endpoint

### Pagination (All Tab Only)

1. User scrolls near bottom (200px threshold)
2. `_scrollListener` detects scroll position
3. Calls `loadMoreBookings()` if `hasMore` is true
4. Increments `currentPage` and fetches next batch
5. Appends new data to existing list

### Refresh

1. User pulls down to refresh
2. `refreshBookings()` called
3. Resets page to 1 (for All tab)
4. Fetches fresh data for current tab
5. Replaces existing data

## Key Features

### DRY Principle

- Single screen implementation serves both roles
- Single controller with role detection
- Identical UI/UX for owner and provider

### Robust Parsing

- `_asDouble()` and `_asInt()` helpers handle API variations
- Supports both string and numeric values from backend
- Prevents runtime crashes from type mismatches

### Performance Optimizations

- Pagination reduces initial load time
- Lazy loading of status-specific tabs
- ScrollController for efficient infinite scroll
- Separate controllers prevent unnecessary rebuilds

## Testing Checklist

### As OWNER

- [ ] All bookings load with pagination
- [ ] Pending bookings display correctly
- [ ] Ongoing bookings display correctly
- [ ] Completed bookings display correctly
- [ ] Cancelled bookings display correctly
- [ ] Scroll to load more works on All tab
- [ ] Pull to refresh works on all tabs
- [ ] Tapping booking opens details screen

### As PROVIDER

- [ ] All bookings load with pagination
- [ ] Pending bookings display correctly
- [ ] Ongoing bookings display correctly
- [ ] Completed bookings display correctly
- [ ] Cancelled bookings display correctly
- [ ] Scroll to load more works on All tab
- [ ] Pull to refresh works on all tabs
- [ ] Tapping booking opens details screen

## Troubleshooting

### Issue: Wrong endpoint called

**Solution**: Verify `AppStorageService.getUserRole()` returns correct role

### Issue: Pagination not working

**Solution**:

- Check if backend returns `page`, `totalPages`, and `totalCount` in response
- Verify `hasMore` calculation logic in controller

### Issue: Empty state shows but data exists

**Solution**:

- Check if `currentBookings` getter returns correct controller's data
- Verify tab index matches controller assignment

### Issue: Type conversion errors

**Solution**:

- Backend may return numbers as strings
- `_asDouble()` and `_asInt()` helpers handle this automatically
- Check model's fromJson implementation

## Future Enhancements

1. **Search/Filter**: Add search functionality across bookings
2. **Sorting**: Allow sorting by date, price, status
3. **Caching**: Implement local caching to reduce API calls
4. **Offline Support**: Store bookings locally for offline viewing
5. **Real-time Updates**: WebSocket support for live booking updates
