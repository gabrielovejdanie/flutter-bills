import 'package:bills_calculator/core/secure_storage.dart';
import 'package:bills_calculator/models/bill.dart';
import 'package:bills_calculator/models/pb_user.dart';
import 'package:pocketbase/pocketbase.dart';

class PBService {
  final String baseUrl =
      'http://139.162.175.99'; // Replace with your PocketBase URL
  final String collectionName = 'bills'; // Replace with your collection name
  late final PocketBase pb;
  static late PBUser currentUser;
  PBService() {
    pb = PocketBase(baseUrl);
    // pbLoginEmailAndPassword('g.o@gmail.com', '12345678');
    pb.authStore.clear();
    getStoredUser();
  }

  pbLoginEmailAndPassword(email, password) {
    return pb
        .collection('users')
        .authWithPassword(email, password)
        .then((resp) {
      print(resp);
      if (resp != null) {
        currentUser = PBUser.fromJson(resp.record?.toJson());
        persistLoggedUser();
        print('logged in pb: ${currentUser.name}');
      }
    });
  }

  Stream<AuthStoreEvent> checkUserChanges() {
    return pb.authStore.onChange;
  }

  getStoredUser() {
    return SecureStore.read('pb_token').then((token) {
      if (token != null) {
        SecureStore.read('pb_model').then((model) {
          pb.authStore.save(token, model.toString());
          print('saved user: ${pb.authStore.model}');
        });
      } else {
        print('no user stored, login again');
      }
    });
  }

  pbLogout() {
    pb.authStore.clear();
    SecureStore.delete('pb_auth');
    print('logged out');
  }

  persistLoggedUser() {
    SecureStore.write('pb_auth', pb.authStore.model);
  }

  Future<List<Bill>> getBills(String userId) async {
    try {
      final response = await pb.collection(collectionName).getList(
            filter: 'userId="$userId"',
          );
      List<Bill> bills = response.items
          .map((item) => Bill.fromJson(item as Map<String, Object?>))
          .toList();
      return bills;
    } catch (e) {
      print('Error fetching bills: $e');
      return [];
    }
  }
}
