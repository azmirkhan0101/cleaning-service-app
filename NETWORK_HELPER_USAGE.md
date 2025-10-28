# NetworkHelper Usage Guide

## ✅ Successfully Converted to GetxService

The `NetworkHelper` has been converted to a **GetxService** and is now properly initialized in your dependency injection.

---

## 📦 How to Use

### **1. In Controllers**

```dart
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _networkHelper = Get.find<NetworkHelper>();
  
  Future<void> login(String email, String password) async {
    final result = await _networkHelper.post<User>(
      'https://api.example.com/login',
      body: {
        'email': email,
        'password': password,
      },
      parser: (data) => User.fromJson(data['user']),
    );
    
    result.fold(
      (error) {
        // Handle error
        Get.snackbar('Error', error.message);
      },
      (user) {
        // Handle success
        print('Welcome ${user.name}');
      },
    );
  }
}
```

---

### **2. In Services (Repository Pattern)**

```dart
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _networkHelper = Get.find<NetworkHelper>();
  
  Future<Either<ErrorResponseModel, User>> login(String email, String password) {
    return _networkHelper.post<User>(
      ApiConstants.loginUrl,
      body: {'email': email, 'password': password},
      parser: (data) => User.fromJson(data),
    );
  }
  
  Future<Either<ErrorResponseModel, List<Service>>> getServices() {
    return _networkHelper.get<List<Service>>(
      ApiConstants.servicesUrl,
      parser: (data) => (data['services'] as List)
          .map((e) => Service.fromJson(e))
          .toList(),
    );
  }
}
```

---

### **3. Available Methods**

#### **GET Request**
```dart
final result = await Get.find<NetworkHelper>().get<User>(
  'https://api.example.com/user/123',
  parser: (data) => User.fromJson(data),
  timeout: Duration(seconds: 15), // Optional
);
```

#### **POST Request**
```dart
final result = await Get.find<NetworkHelper>().post<Response>(
  'https://api.example.com/create',
  body: {'name': 'John', 'email': 'john@example.com'},
  parser: (data) => Response.fromJson(data),
);
```

#### **PUT Request**
```dart
final result = await Get.find<NetworkHelper>().put<User>(
  'https://api.example.com/user/123',
  body: {'name': 'Updated Name'},
  parser: (data) => User.fromJson(data),
);
```

#### **PATCH Request**
```dart
final result = await Get.find<NetworkHelper>().patch<User>(
  'https://api.example.com/user/123',
  body: {'email': 'newemail@example.com'},
  parser: (data) => User.fromJson(data),
);
```

#### **DELETE Request**
```dart
final result = await Get.find<NetworkHelper>().delete<void>(
  'https://api.example.com/user/123',
);
```

#### **Multipart/File Upload**
```dart
final result = await Get.find<NetworkHelper>().multipart<Response>(
  url: 'https://api.example.com/upload',
  method: 'POST',
  fields: {'title': 'My Image'},
  files: [
    MultipartBody(
      key: 'image',
      file: File('/path/to/image.jpg'),
    ),
  ],
  parser: (data) => Response.fromJson(data),
);
```

---

## 🔑 Authentication

By default, all requests include the auth token from `AppStorageService`.

### **Disable Auth for Specific Request**
```dart
final result = await Get.find<NetworkHelper>().post<User>(
  'https://api.example.com/public/endpoint',
  withAuth: false, // No token sent
  body: {'email': email},
);
```

---

## ⏱️ Custom Timeout

```dart
final result = await Get.find<NetworkHelper>().get<Data>(
  'https://slow-api.example.com/data',
  timeout: Duration(minutes: 2), // Custom timeout
);
```

---

## 🎯 Error Handling

The service returns `Either<ErrorResponseModel, T>`:

```dart
final result = await Get.find<NetworkHelper>().get<User>(...);

result.fold(
  (error) {
    // Left side - Error occurred
    print('Status Code: ${error.statusCode}');
    print('Message: ${error.message}');
    
    // Different error types
    if (error.statusCode == 401) {
      // Unauthorized - logout user
    } else if (error.statusCode == 404) {
      // Not found
    } else if (error.statusCode == -1) {
      // Network error (no internet, timeout)
    }
  },
  (user) {
    // Right side - Success
    print('User: ${user.name}');
  },
);
```

---

## 🧪 Testing

### **Mock NetworkHelper in Tests**

```dart
class MockNetworkHelper extends GetxService implements NetworkHelper {
  @override
  Future<Either<ErrorResponseModel, T>> get<T>(...) async {
    return Right(MockUser() as T);
  }
}

// In test
void main() {
  setUp(() {
    Get.put<NetworkHelper>(MockNetworkHelper());
  });
}
```

---

## 📝 Best Practices

1. **Use Repository Pattern**: Create service classes that wrap NetworkHelper
2. **Parser Functions**: Always provide parser to convert JSON to models
3. **Error Handling**: Use `fold()` to handle both success and error cases
4. **Timeouts**: Set custom timeouts for slow endpoints
5. **Loading States**: Combine with GetX reactive state in controllers

---

## 🚀 Example: Complete Flow

```dart
// 1. API Constants
class ApiConstants {
  static const baseUrl = 'https://api.example.com';
  static const login = '$baseUrl/auth/login';
  static const services = '$baseUrl/services';
}

// 2. Service Layer
class AuthService extends GetxService {
  final _network = Get.find<NetworkHelper>();
  
  Future<Either<ErrorResponseModel, User>> login(String email, String password) {
    return _network.post<User>(
      ApiConstants.login,
      body: {'email': email, 'password': password},
      parser: (data) => User.fromJson(data['user']),
    );
  }
}

// 3. Controller Layer
class AuthController extends GetxController {
  final _authService = Get.find<AuthService>();
  final isLoading = false.obs;
  
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    
    final result = await _authService.login(email, password);
    
    result.fold(
      (error) => Get.snackbar('Error', error.message),
      (user) {
        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Welcome ${user.name}');
      },
    );
    
    isLoading.value = false;
  }
}
```

---

## ✨ Benefits of GetxService

- ✅ **Single Instance**: Managed by GetX lifecycle
- ✅ **Easy Injection**: Use `Get.find<NetworkHelper>()`
- ✅ **Testable**: Easy to mock for unit tests
- ✅ **Memory Efficient**: Only created when needed
- ✅ **Consistent**: Follows your app's GetX architecture

---

**You're all set!** 🎉 The NetworkHelper is now properly integrated as a GetxService.
